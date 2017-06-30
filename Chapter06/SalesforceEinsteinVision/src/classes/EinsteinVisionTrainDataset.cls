public with sharing class EinsteinVisionTrainDataset{

    public static final String endpoint = 'https://api.metamind.io/v1/vision/train';


   /** This method builds the Blob Body 
    * @param   name of the model,DatasetId of the model
    * @return HttpResponse
    **/
    private static Blob buildBlobBody(String modelname,String datasetId) {
        String body = '';
        body += EinsteinVisionUtility.WriteBoundary();
        body += EinsteinVisionUtility.WriteBodyParameter('name', modelname);
        body += EinsteinVisionUtility.WriteBoundary();
        body += EinsteinVisionUtility.WriteBodyParameter('datasetId',datasetId);
       // body += EinsteinVisionUtility.WriteBoundary();
       // body += EinsteinVisionUtility.WriteBodyParameter('learningRate', '0.0001');
        body += EinsteinVisionUtility.WriteBoundary(EinsteinVisionUtility.EndingType.CrLf);
        Blob bodyBlob = EncodingUtil.base64Decode(body);
        return bodyBlob;
    }

    /** This method trains the Dataset
    * @param   name of the model,DatasetId of the model
    * @return EinsteinVisionTrainDataSetResponse
    **/

     public static EinsteinVisionTrainDataSetResponse trainDataSet(String modelname,String datasetId,Boolean commitToken){
        blob requestBody = buildBlobBody(modelname,datasetId);
        EinsteinVisionTrainDataSetResponse trainingResult = new EinsteinVisionTrainDataSetResponse();
        //Invoke AccessTokenManager To Get accessToken
        EinsteinVisionAccessTokenManager.AccessToken accessTokenObject = EinsteinVisionAccessTokenManager.getcurrentAccessToken();
        HttpResponse result = EinsteinVisionHttpUtility.makeCallout(requestBody,EinsteinVisionUtility.getContentType(),endpoint,'POST',accessTokenObject.accessToken);
        system.debug('RESULT..'+result.getBody());
        if(result.getStatusCode() == 200){
           trainingResult = parseResponse(result.getBody());
           //Check if token needs commit and if yes commit it 
           if(accessTokenObject.isChanged && commitToken){
               EinsteinVisionAccessTokenManager.updateAccessToken(accessTokenObject.accessToken);
           }
        }else{
           if(result.getBody()== '{"message":"Invalid access token"}'){
              //retry with new token
            HttpResponse retryresult = EinsteinVisionHttpUtility.makeCallout(requestBody,EinsteinVisionUtility.getContentType(),
                                                                                endpoint,'POST',
                                                                                EinsteinVisionAccessTokenManager.getNewToken(EinsteinVision__c.getOrgDefaults()).accessToken
                                                                                );
            if(retryresult.getStatusCode()!=200){
                throw new EinstieinVisionCreateDatasetUtil.EinstieinVisionException(result.getBody());
            }else{
                trainingResult = parseResponse(retryresult.getBody());
               //Commit the new token
                if(commitToken){
                   EinsteinVisionAccessTokenManager.updateAccessToken(EinsteinVisionAccessTokenManager.getNewToken(
                   EinsteinVision__c.getOrgDefaults())
                   .accessToken);
                 }
                }
            }else{
              throw new EinstieinVisionCreateDatasetUtil.EinstieinVisionException(result.getBody());
            }
        }
        return trainingResult;
     }



      /** This method retrives the status of the training
      * @param   name of the model,DatasetId of the model
      * @return EinsteinVisionTrainDataSetResponse
     **/
     public static EinsteinVisionTrainDataSetResponse gettrainingStatus(String modelId,Boolean commitToken){
         EinsteinVisionTrainDataSetResponse trainingResult = new EinsteinVisionTrainDataSetResponse();
          //Invoke AccessTokenManager To Get accessToken
        EinsteinVisionAccessTokenManager.AccessToken accessTokenObject = EinsteinVisionAccessTokenManager.getcurrentAccessToken();
        HttpResponse result = EinsteinVisionHttpUtility.makegetCallout(endpoint+'/'+modelId,accessTokenObject.accessToken);
        if(result.getStatusCode() == 200){
        system.debug(result.getBody());
           trainingResult = parseResponse(result.getBody());
           //Check if token needs commit and if yes commit it 
           if(accessTokenObject.isChanged && commitToken){
               EinsteinVisionAccessTokenManager.updateAccessToken(accessTokenObject.accessToken);
           }
        }else{
           if(result.getBody()== '{"message":"Invalid access token"}'){
              //retry with new token
               HttpResponse retryresult = EinsteinVisionHttpUtility.makegetCallout(endpoint+'/'+modelId,
                                                                                EinsteinVisionAccessTokenManager.getNewToken(EinsteinVision__c.getOrgDefaults()).accessToken
                                                                                );
                if(retryresult.getStatusCode()!=200){
                    throw new EinstieinVisionCreateDatasetUtil.EinstieinVisionException(result.getBody());
                }else{
                    trainingResult = parseResponse(retryresult.getBody());
                    //Commit the new token
                    if(commitToken){
                     EinsteinVisionAccessTokenManager.updateAccessToken(EinsteinVisionAccessTokenManager.getNewToken(EinsteinVision__c.getOrgDefaults()).accessToken);
                    }
                }
            }else{
              throw new EinstieinVisionCreateDatasetUtil.EinstieinVisionException(result.getBody());
           }
        }
        return trainingResult;
     }



     public static EinsteinVisionTrainDataSetResponse parseResponse(String responseBody){
        String responseString = responseBody;
        responseString = responseString.replaceAll('object','object_x');
        responseString = responseString.replaceAll('name','name_x');
        EinsteinVisionTrainDataSetResponse trainingresponse = EinsteinVisionTrainDataSetResponse.parse(responseString);
        return trainingresponse;
    }

}