const rp = require('request-promise');
var Episode7 = require('episode-7');
const updateToken = require('./update-token');
const oAuthToken = require('./oauth-token');

let loopPreventor = false;

function* queryVisionApi(
                       pvsUrl,
                       fileData,
                       modelId='3FIBARDU5LHI5XC7KAO3K2ZQYE',
                       accountId,
                       privateKey,
                       jwtToken){
  var token = jwtToken || oAuthToken.get();
  console.log('Image Data',fileData);

  var formData = {
    modelId: modelId,
    sampleBase64Content: fileData
  }
  var options = {
      url: pvsUrl+'/v1/vision/predict',
      method: 'POST',
      headers: {
        'Authorization': 'Bearer '+token,
        'Content-Type': 'multipart/form-data',
        'Connection': 'keep-alive',
        'Cache-Control': 'no-cache'

      },
      formData:formData
  }
  let { body, isUnauthorized } = yield Episode7.call((options) => {
    return rp(options)
      .then( body => ({ body }) )
      .catch( error => {
        if(error.statusCode === 401) {
          return { isUnauthorized: true };
        } else {
          throw error;
        }
      })
  },options);

  console.log('response from predict..'+body);
  
  if(!loopPreventor && isUnauthorized) {
    loopPreventor = true;
    let updatedToken = yield Episode7.call(
      updateToken,
      pvsUrl,
      accountId,
      privateKey
    );

    let visionApiResult = yield Episode7.call( 
      queryVisionApi,
      pvsUrl,
      resizedImgUrl,
      modelId
    );
    setTimeout(()=>{loopPreventor = false},1000);
    return visionApiResult;
  } else {
    return body;
  }
}

module.exports = queryVisionApi;