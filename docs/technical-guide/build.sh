#!/usr/bin/env bash
# ساخت PDF مستندات فنی در دو مرحله: اجرای اول برای یافتن شمارهٔ صفحهٔ سرفصل‌ها،
# اجرای دوم برای نوشتن آن‌ها در فهرست مطالب.
# پیش‌نیاز: Node.js با بستهٔ playwright (و Chromium آن)، Python 3 با pypdf.
set -euo pipefail
cd "$(dirname "$0")"
OUT="${1:-../Shelter-DNS-Ping-Technical-Guide.pdf}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
export NODE_PATH="${NODE_PATH:-$(npm root -g)}"

node render.cjs guide.html "$TMP/pass1.pdf"
python3 toc.py "$TMP/pass1.pdf" "$TMP/pass1.pdf.headings.json" > "$TMP/toc.json"
node render.cjs guide.html "$TMP/pass2.pdf" "$TMP/toc.json"
python3 toc.py "$TMP/pass2.pdf" "$TMP/pass2.pdf.headings.json" > "$TMP/toc2.json"
if ! cmp -s "$TMP/toc.json" "$TMP/toc2.json"; then
  echo "page numbers shifted between passes; rendering a third pass" >&2
  node render.cjs guide.html "$TMP/pass2.pdf" "$TMP/toc2.json"
fi
python3 - "$TMP/pass2.pdf" "$TMP/pass2.pdf.headings.json" "$OUT" <<'PY'
import json, sys
from pypdf import PdfReader, PdfWriter
from pypdf.generic import NameObject, TextStringObject
w = PdfWriter(clone_from=PdfReader(sys.argv[1]))
# عنوان bookmarkها را با متن منطقی سرفصل‌ها جایگزین می‌کند تا متن دوجهته درست نمایش داده شود.
titles = iter(h["text"] for h in json.load(open(sys.argv[2], encoding="utf-8")))
def fix(node):
    while node is not None:
        node = node.get_object()
        node[NameObject("/Title")] = TextStringObject(next(titles))
        if "/First" in node:
            fix(node["/First"])
        node = node.get("/Next")
fix(w._root_object["/Outlines"]["/First"])
w.add_metadata({
    "/Title": "مستندات فنی DNS رفع تحریم و اپلیکیشن کاهش پینگ Shelter",
    "/Author": "Shelter",
    "/Subject": "DNS رفع تحریم، اصول کاهش پینگ، معماری و عیب‌یابی Shelter",
    "/Keywords": "Shelter, DNS, SNI proxy, ping, Wintun, WFP",
})
w.page_mode = "/UseOutlines"
with open(sys.argv[3], "wb") as f:
    w.write(f)
PY
echo "wrote $OUT"
