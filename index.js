const http = require('http');
const { spawn } = require('child_process');

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('R Shiny app is running.  Check the console for the URL.');
});

const port = 3000;
server.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);

  // Run the Shiny app using a separate R process
  const shinyProcess = spawn('R', ['-e', 'shiny::runApp("./shiny-package")']);

  shinyProcess.stdout.on('data', (data) => {
    console.log(`stdout: ${data}`);
  });

  shinyProcess.stderr.on('data', (data) => {
    console.error(`stderr: ${data}`);
  });

  shinyProcess.on('close', (code) => {
    console.log(`Shiny app process exited with code ${code}`);
  });
});
