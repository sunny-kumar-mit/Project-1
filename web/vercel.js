// This file helps Vercel serve the Flutter web app
const { createServer } = require('http');
const { parse } = require('url');
const next = require('next');
const { join } = require('path');
const { readFileSync } = require('fs');

const dev = false;
const app = next({ dev });
const handle = app.getRequestHandler();

const BUILD_DIR = join(__dirname, '../build/web');

app.prepare().then(() => {
  createServer((req, res) => {
    const parsedUrl = parse(req.url, true);
    const { pathname } = parsedUrl;

    // Serve static files from build/web
    if (pathname === '/' || pathname === '/index.html') {
      const html = readFileSync(join(BUILD_DIR, 'index.html'), 'utf8');
      res.setHeader('Content-Type', 'text/html');
      res.end(html);
    } else {
      // Serve other static files
      handle(req, res, parsedUrl);
    }
  }).listen(3000, (err) => {
    if (err) throw err;
    console.log('> Ready on http://localhost:3000');
  });
});