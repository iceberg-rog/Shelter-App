// رندر guide.html به PDF با Chromium (Playwright).
// استفاده: node render.cjs <input.html> <output.pdf> [toc-pages.json]
const fs = require("fs");
const path = require("path");
const { chromium } = require("playwright");

(async () => {
  const [, , input, output, tocFile] = process.argv;
  const pages = tocFile ? JSON.parse(fs.readFileSync(tocFile, "utf8")) : {};
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.addInitScript((p) => { window.__tocPages = p; }, pages);
  await page.goto("file://" + path.resolve(input), { waitUntil: "load" });
  await page.evaluate(() => document.fonts.ready);
  // ترتیب سرفصل‌ها همان ترتیب bookmarkهای PDF است؛ toc.py از آن برای نگاشت شناسه به صفحه استفاده می‌کند.
  const headings = await page.evaluate(() =>
    [...document.querySelectorAll("h1, h2, h3, h4, h5, h6")]
      .filter((h) => h.getClientRects().length > 0)
      .map((h) => ({ id: h.id, text: h.textContent.trim() })));
  fs.writeFileSync(output + ".headings.json", JSON.stringify(headings));
  await page.pdf({
    path: output,
    preferCSSPageSize: true,
    printBackground: true,
    outline: true,
    tagged: true,
  });
  await browser.close();
})().catch((e) => { console.error(e); process.exit(1); });
