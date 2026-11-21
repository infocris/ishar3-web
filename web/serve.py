# Local HTTP server for Ishar 3 (js-dos and ALIS/WebAssembly).
# - No caching: the browser always reloads the latest files.
# - COOP/COEP headers: required by ALIS's WebAssembly threads (SharedArrayBuffer).
# - GET  /game/<file>           : game files ($ISHAR3_GAME, default: game/ next to web/).
# - GET  /saves-list/<folder>   : JSON list of the saves in web/saves/<folder>/.
# - PUT  /saves/[<folder>/]<name> : writes a save to disk.
import http.server, json, os, re, sys, urllib.parse

ROOT = os.path.dirname(os.path.abspath(__file__))
GAME = os.environ.get("ISHAR3_GAME") or os.path.join(os.path.dirname(ROOT), "game")
SAVES = os.path.join(ROOT, "saves")
GAME_EXT = re.compile(r"\.(IO|FIC|DAT|EXE|STP|TST)$", re.I)
SAFE = re.compile(r"^[A-Za-z0-9_][A-Za-z0-9_.-]*$")


class H(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *a, **kw):
        super().__init__(*a, directory=ROOT, **kw)

    def end_headers(self):
        self.send_header("Cache-Control", "no-store, must-revalidate")
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        self.send_header("Cross-Origin-Resource-Policy", "same-origin")
        super().end_headers()

    def _json(self, obj):
        body = json.dumps(obj).encode()
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _save_dir(self, parts):
        """parts = path segments after /saves/; returns (folder, name) or None."""
        if not parts or not all(SAFE.match(p) for p in parts) or len(parts) > 2:
            return None
        return os.path.join(SAVES, *parts[:-1]), parts[-1]

    def do_GET(self):
        path = urllib.parse.unquote(self.path.split("?")[0])
        if path == "/game/files.json":
            names = sorted(n for n in os.listdir(GAME)
                           if GAME_EXT.search(n) and os.path.isfile(os.path.join(GAME, n)))
            return self._json([{"name": n, "size": os.path.getsize(os.path.join(GAME, n))} for n in names])
        if path.startswith("/game/"):
            name = path[len("/game/"):]
            if not SAFE.match(name) or not GAME_EXT.search(name):
                return self.send_error(403)
            return self._send_file(os.path.join(GAME, name))
        if path.startswith("/saves-list/"):
            sub = path[len("/saves-list/"):].strip("/")
            if not SAFE.match(sub):
                return self.send_error(403)
            d = os.path.join(SAVES, sub)
            names = sorted(n for n in os.listdir(d)
                           if not n.endswith((".bak", ".tmp")) and os.path.isfile(os.path.join(d, n))) if os.path.isdir(d) else []
            return self._json(names)
        return super().do_GET()

    def _send_file(self, full):
        if not os.path.isfile(full):
            return self.send_error(404)
        with open(full, "rb") as f:
            data = f.read()
        self.send_response(200)
        self.send_header("Content-Type", "application/octet-stream")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def do_PUT(self):
        path = urllib.parse.unquote(self.path.split("?")[0])
        target = self._save_dir(path[len("/saves/"):].split("/")) if path.startswith("/saves/") else None
        if target is None:
            return self.send_error(403)
        folder, name = target
        data = self.rfile.read(int(self.headers.get("Content-Length", 0)))
        os.makedirs(folder, exist_ok=True)
        dest = os.path.join(folder, name)
        if os.path.exists(dest):
            os.replace(dest, dest + ".bak")  # keep the previous version
        with open(dest + ".tmp", "wb") as f:
            f.write(data)
        os.replace(dest + ".tmp", dest)
        self.send_response(204)
        self.end_headers()

    def log_message(self, fmt, *args):
        if self.command == "PUT":
            sys.stderr.write("save written: %s\n" % self.path)

    def handle(self):
        try:
            super().handle()
        except (BrokenPipeError, ConnectionResetError):
            pass  # tab closed or reloaded during a transfer


port = int(sys.argv[1]) if len(sys.argv) > 1 else 8333
http.server.ThreadingHTTPServer(("127.0.0.1", port), H).serve_forever()
