"""شمارهٔ صفحهٔ هر سرفصل را از bookmarkهای PDF بیرون می‌کشد.

استفاده: python3 toc.py <pdf> <headings.json> > toc-pages.json
"""
import json
import sys

from pypdf import PdfReader


def flatten(reader, items, out):
    for it in items:
        if isinstance(it, list):
            flatten(reader, it, out)
        else:
            out.append((it.title.strip(), reader.get_destination_page_number(it) + 1))


def main():
    reader = PdfReader(sys.argv[1])
    headings = json.load(open(sys.argv[2], encoding="utf-8"))
    marks = []
    flatten(reader, reader.outline, marks)
    if len(marks) != len(headings):
        sys.exit(f"bookmark count {len(marks)} != heading count {len(headings)}")
    # Chromium عنوان bookmarkهای دوجهته (فارسی + لاتین) را با ترتیب دیداری می‌نویسد،
    # پس تطبیق بر اساس ترتیب انجام می‌شود، نه متن.
    pages = {}
    for (_, page), h in zip(marks, headings):
        if h["id"]:
            pages[h["id"]] = page
    json.dump(pages, sys.stdout, ensure_ascii=False)


main()
