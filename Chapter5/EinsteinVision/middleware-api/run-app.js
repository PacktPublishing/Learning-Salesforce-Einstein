const Episode7     = require('episode-7');
const createServer = require('./express-server');
const oAuthToken   = require('./oauth-token');
const updateToken  = require('./update-token');
const fs = require("fs");
const server = createServer();

const PORT = process.env.PORT || 5000;
const pvsUrl = process.env.EINSTEIN_VISION_URL || 'https://api.metamind.io/';
const accountId  = process.env.EINSTEIN_VISION_ACCOUNT_ID || 'msrivastav13@gmail.com';
const privateKey = process.env.EINSTEIN_VISION_PRIVATE_KEY || fs.readFileSync(__dirname +'/key.pm','utf8');

Episode7.run(updateToken, pvsUrl, accountId, privateKey)
.then(() => {
  server.listen(PORT, function() {
    console.log('Image Identifier is running on port', PORT);
  });
})
.catch(error => {
  console.log(`Failed to start server: ${error.stack}`);
  process.exit(1);
});