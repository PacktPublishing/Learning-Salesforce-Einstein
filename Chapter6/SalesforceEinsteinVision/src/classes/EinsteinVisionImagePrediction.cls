public without sharing class EinsteinVisionImagePrediction{
   
   @AuraEnabled
   public static EinsetinPredictionResponse predict(String fileName, String base64Data, String contentType,String modelId){
       //Build Request Body
      base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
      return invokePredictionAPI(fileName,base64Data,contentType,modelId);
   }

   public static EinsetinPredictionResponse invokePredictionAPI(String fileName, String base64Data, String contentType,String modelId ){
    String endpoint = 'https://api.metamind.io/v1/vision/predict';
    if(modelId == null){
        throw new AuraHandledException('ModelId is missing');
    }
    blob requestBody = build(modelId,EinsteinVisionImagePrediction.Types.BASE64,base64Data,'');

    EinsetinPredictionResponse predictionresponse = new EinsetinPredictionResponse();
    //Invoke AccessTokenManager To Get accessToken
    EinsteinVisionAccessTokenManager.AccessToken accessTokenObject = EinsteinVisionAccessTokenManager.getcurrentAccessToken();
    HttpResponse result = EinsteinVisionHttpUtility.makeCallout(requestBody,EinsteinVisionUtility.getContentType(),endpoint,'POST',accessTokenObject.accessToken);
    if(result.getStatusCode() == 200){
        predictionresponse = parseResponse(result.getBody());
        //Check if token needs commit and if yes commit it 
        if(accessTokenObject.isChanged ){
            EinsteinVisionAccessTokenManager.updateAccessToken(accessTokenObject.accessToken);
        }
    }else{
        if(result.getBody()== '{"message":"Invalid access token"}'){
            //retry with new token
            HttpResponse retryresult = EinsteinVisionHttpUtility.makeCallout(requestBody,EinsteinVisionUtility.getContentType(),
                                                                                endpoint,'POST',
                                                                                EinsteinVisionAccessTokenManager.getNewToken(EinsteinVision__c.getOrgDefaults()).accessToken
                                                                                );
            system.debug('RESULT2..'+retryresult.getBody());
            if(retryresult.getStatusCode()!=200){
                throw new EinstieinVisionCreateDatasetUtil.EinstieinVisionException(retryresult.getBody());
            }else{
                predictionresponse = parseResponse(retryresult.getBody());
                //Commit the new token
                    EinsteinVisionAccessTokenManager.updateAccessToken(EinsteinVisionAccessTokenManager.getNewToken(
                    EinsteinVision__c.getOrgDefaults())
                    .accessToken);
            }
        }else{
            throw new EinstieinVisionCreateDatasetUtil.EinstieinVisionException(result.getBody());
        }
     }
     return predictionresponse;
   }

    /** This method builds the Body part required
    * @param  modelId ,EinsteinVisionImagePrediction.Types,data (Can be URL/Base64 String)
    * @return  Blob body
    **/

   public static Blob build(String modelId,EinsteinVisionImagePrediction.Types type,String data,String sampleId) {
        String body = '';
        body += EinsteinVisionUtility.WriteBoundary();
        body += EinsteinVisionUtility.WriteBodyParameter('modelId', modelId);
        if (sampleId!=null && !sampleId.equals('')) {
            body += EinsteinVisionUtility.WriteBoundary();
            body += EinsteinVisionUtility.WriteBodyParameter('sampleId', sampleId);
        }
        body += EinsteinVisionUtility.WriteBoundary();
        if (type==Types.BASE64) {
            body += EinsteinVisionUtility.WriteBodyParameter('sampleBase64Content', data);
        } else if (type==Types.URL) {
            body += EinsteinVisionUtility.WriteBodyParameter('sampleLocation', data);
        }
        body += EinsteinVisionUtility.WriteBoundary(EinsteinVisionUtility.EndingType.CrLf);
        Blob bodyBlob = EncodingUtil.base64Decode(body);
        return bodyBlob;
    }

    public enum Types {
        BASE64,
        FILEBLOB,
        URL
    }
    
    public static EinsetinPredictionResponse parseResponse(String responseBody){
        String responseString = responseBody;
        responseString = responseString.replaceAll('object','object_x');
        EinsetinPredictionResponse predictionresponse = EinsetinPredictionResponse.parse(responseString);
          system.debug('RESULT RESPONSE...'+responseBody);
         system.debug('RESULT RESPONSE...'+predictionresponse);
        return predictionresponse;
    }

}