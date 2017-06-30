const queryVisionApi = require('./queryVisionApi');
const Episode7 = require('episode-7');

function* sendImageToVisionApi(pvsUrl,
                              fileData,
                              fileExt,
                              modelId,
                              accountId,
                              privateKey,
                              jwtToken) {
  // send image to Vision API
  let visionApiResult = yield Episode7.call(
    queryVisionApi,
    pvsUrl,
    fileData,
    modelId,
    accountId,
    privateKey,
    jwtToken
  );
  
  return visionApiResult;
}

module.exports = sendImageToVisionApi;