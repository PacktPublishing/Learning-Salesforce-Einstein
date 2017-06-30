const server                = require('./lib/express-server');
const fileUpload            = require('./lib/file-upload');
const updateToken           = require('./lib/update-token');
const oAuthToken            = require('./lib/oauth-token');
const queryVisionApi         = require('./lib/queryVisionApi');
const sendImageToVisionApi   = require('./lib/send-image-to-vision-api');

module.exports = {
  server,
  fileUpload,
  updateToken,
  oAuthToken,
  queryVisionApi,
  sendImageToVisionApi
}