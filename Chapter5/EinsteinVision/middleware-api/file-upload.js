const path     = require('path');
const sendImageToVisionApi = require('./send-image-to-vision-api');
const fs = require("fs");
const pify = require('pify');

// Mutable variable to support rewire in tests.
var Episode7 = require('episode-7');

function fileUpload(request, response, next) {
  const filePath = request.files.file.path;
  const fileExt  = path.extname(filePath).replace(/^\./,'');
  const modelId    = process.env.CUSTOM_MODEL_ID;
  const pvsUrl     = process.env.EINSTEIN_VISION_URL || 'https://api.metamind.io/';
  const accountId  = process.env.EINSTEIN_VISION_ACCOUNT_ID || 'msrivastav13@gmail.com';
  const privateKey = process.env.EINSTEIN_VISION_PRIVATE_KEY || fs.readFileSync(__dirname +'/key.pm','utf8');
  const jwtToken   = process.env.EINSTEIN_VISION_TOKEN;

  //get base64 Image Data
  let fileData = base64_encode(filePath);

  return Episode7.run(sendImageToVisionApi,
               pvsUrl,
               fileData,
               fileExt,
               modelId,
               accountId,
               privateKey,
               jwtToken)
    .then(function(predictions) {
        //response.setHeader('Content-Type', 'application/json'); 
        response.status(200).send(predictions); 
    })
    .catch( error => next(error));
}

function base64_encode(file) {
    // read binary data
    var bitmap = fs.readFileSync(file);
    // convert binary data to base64 encoded string
    return new Buffer(bitmap).toString('base64');
}

module.exports = fileUpload;