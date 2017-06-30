public with sharing class EinstieinVisionCreateDatasetUtil{

    public static final String endpoint = 'https://api.metamind.io/v1/vision/datasets/upload';

     /** This method creates DatasetFromURL.The public URL can be a image zip file stored in cloudinary/box/google
    * @param   Public URL
    * @return  EinsteinVisionDatasetResult that comprises of datasetId and status as upload
    **/

    public static EinsteinVisionDatasetResult createDatasetFromURLAsync(String publicURL,Boolean commitToken){
        EinsteinVisionDatasetResult dataset = new EinsteinVisionDatasetResult();
        String body = '';
        body += EinsteinVisionUtility.WriteBoundary();
        body += EinsteinVisionUtility.WriteBodyParameter('path', publicURL);
        body += EinsteinVisionUtility.WriteBoundary(EinsteinVisionUtility.EndingType.CrLf);
        Blob bodyBlob = EncodingUtil.base64Decode(body);
        //Invoke AccessTokenManager To Get accessToken
        EinsteinVisionAccessTokenManager.AccessToken accessTokenObject = EinsteinVisionAccessTokenManager.getcurrentAccessToken();
        HttpResponse result = EinsteinVisionHttpUtility.makeCallout(bodyBlob,EinsteinVisionUtility.getContentType(),endpoint,'POST',accessTokenObject.accessToken);
        if(result.getStatusCode() == 200){
           dataset = parseResponse(result.getBody());
           //Check if token needs commit and if yes commit it 
           if(accessTokenObject.isChanged && commitToken){
               EinsteinVisionAccessTokenManager.updateAccessToken(accessTokenObject.accessToken);
           }
        }else{
           if(result.getBody()== '{"message":"Invalid access token"}'){
              //retry with new token
               HttpResponse retryresult = EinsteinVisionHttpUtility.makeCallout(bodyBlob,EinsteinVisionUtility.getContentType(),
                                                                                endpoint,'POST',
                                                                                EinsteinVisionAccessTokenManager.getNewToken(EinsteinVision__c.getOrgDefaults()).accessToken
                                                                                );
              dataset = parseResponse(retryresult.getBody());
               //Commit the new token
               if(commitToken){
                 EinsteinVisionAccessTokenManager.updateAccessToken(EinsteinVisionAccessTokenManager.getNewToken(EinsteinVision__c.getOrgDefaults()).accessToken);
               }
            }else{
              throw new EinstieinVisionException(result.getBody());
           }
        }
        return dataset;
    }

    public static EinsteinVisionDatasetResult parseResponse(String responseBody){
        String responseString = responseBody;
        responseString = responseString.replaceAll('object','object_x');
        EinsteinVisionDatasetResult dataset = EinsteinVisionDatasetResult.parse(responseString);
        return dataset;
    }

    public class EinstieinVisionException extends Exception {}

}