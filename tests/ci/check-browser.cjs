const { chromium } = require('playwright-core');
const { join } = require('node:path');
const { pathToFileURL } = require('node:url');

async function main() {
  const browser = await chromium.launch({
    channel: 'chromium',
    args: ['--use-gl=angle', '--use-angle=swiftshader', '--enable-unsafe-swiftshader'],
  });
  try {
    const page = await browser.newPage();
    const errors = [];
    page.on('console', message => console.log(message.text()));
    page.on('pageerror', error => {
      errors.push(error);
      console.error(error);
    });
    await page.goto(pathToFileURL(join(__dirname, 'drawing.html')).href);
    const body = page.locator('body[data-result]');
    await body.waitFor({ state: 'attached', timeout: 30000 });
    if (await body.getAttribute('data-result') !== 'pass' || errors.length > 0) {
      throw new Error('Vision browser tests failed');
    }
  } finally {
    await browser.close();
  }
}

main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
