public with sharing class EinsteinVisionGetDataset{

    /** This method gets the status of the dataset using the DatasetId
    * @param    endpoint 
    * @return EinsteinVisionDatasetResult
    **/
    public static EinsteinVisionDatasetResult getDataSetStatus(String datasetId,Boolean commitToken){
        EinsteinVisionDatasetResult dataset = new EinsteinVisionDatasetResult();
        String endpoint = 'https://api.metamind.io/v1/vision/datasets/';
        //Invoke AccessTokenManager To Get accessToken
        EinsteinVisionAccessTokenManager.AccessToken accessTokenObject = EinsteinVisionAccessTokenManager.getcurrentAccessToken();
        HttpResponse result = EinsteinVisionHttpUtility.makegetCallout(endpoint+datasetId,accessTokenObject.accessToken);
         if(result.getStatusCode() == 200){
           dataset = EinstieinVisionCreateDatasetUtil.parseResponse(result.getBody());
           //Check if token needs commit and if yes commit it 
           if(accessTokenObject.isChanged && commitToken){
               EinsteinVisionAccessTokenManager.updateAccessToken(accessTokenObject.accessToken);
           }
        }else{
           if(result.getBody()== '{"message":"Invalid access token"}'){
              //retry with new token
              HttpResponse retryresult = EinsteinVisionHttpUtility.makegetCallout(endpoint+datasetId,
              EinsteinVisionAccessTokenManager.getNewToken(EinsteinVision__c.getOrgDefaults()).accessToken);
              dataset = EinstieinVisionCreateDatasetUtil.parseResponse(retryresult.getBody());
               //Commit the new token
               if(commitToken){
                EinsteinVisionAccessTokenManager.updateAccessToken(accessTokenObject.accessToken);
               }
            }else{
              throw new EinstieinVisionCreateDatasetUtil.EinstieinVisionException(result.getBody());
           }
      }
      return dataset;
    }

     /** This method gets the status of the dataset using the DatasetId
    * @param    endpoint 
    * @return EinsteinVisionDataSetList
    **/
    public static EinsteinVisionDataSetList getAllDataSets(){
        EinsteinVisionDataSetList dataset = new EinsteinVisionDataSetList();
        String endpoint = 'https://api.metamind.io/v1/vision/datasets';
        //Invoke AccessTokenManager To Get accessToken
        EinsteinVisionAccessTokenManager.AccessToken accessTokenObject = EinsteinVisionAccessTokenManager.getcurrentAccessToken();
        HttpResponse result = EinsteinVisionHttpUtility.makegetCallout(endpoint,accessTokenObject.accessToken);
         if(result.getStatusCode() == 200){
           dataset = parseResponse(result.getBody());
           //Check if token needs commit and if yes commit it 
           if(accessTokenObject.isChanged){
               EinsteinVisionAccessTokenManager.updateAccessToken(accessTokenObject.accessToken);
           }
        }else{
           if(result.getBody()== '{"message":"Invalid access token"}'){
              //retry with new token
              HttpResponse retryresult = EinsteinVisionHttpUtility.makegetCallout(endpoint,
              EinsteinVisionAccessTokenManager.getNewToken(EinsteinVision__c.getOrgDefaults()).accessToken);
              dataset = parseResponse(retryresult.getBody());
               //Commit the new token
               EinsteinVisionAccessTokenManager.updateAccessToken(accessTokenObject.accessToken);
            }else{
              throw new EinstieinVisionCreateDatasetUtil.EinstieinVisionException(result.getBody());
           }
      }
      return dataset;
    }

    private static EinsteinVisionDataSetList parseResponse(String responseBody){
        String responseString = responseBody;
        responseString = responseString.replaceAll('object','object_x');
        EinsteinVisionDataSetList dataset = EinsteinVisionDataSetList.parse(responseString);
        return dataset;
    }

}