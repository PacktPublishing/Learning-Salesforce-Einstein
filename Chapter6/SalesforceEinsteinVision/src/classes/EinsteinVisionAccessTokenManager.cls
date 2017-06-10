public without sharing class EinsteinVisionAccessTokenManager{

    public class AccessToken{
        public String accessToken {get;set;}
        public Boolean isChanged {get;set;} //Indicates that there is a 
                                            //change in access Token and the calling code needs to update the access token
        public AccessToken(String accessToken,Boolean isChanged ){
           this.accessToken = accessToken;
           this.isChanged = isChanged;
        }
    }

   /** This method gets the current access token in the System .If the access token is missing the system initiates a fresh request to get the latest access token
    * @param   
    * @return Custom class AccessToken .
    **/
   public static AccessToken getcurrentAccessToken(){
      EinsteinVision__c accessTokenRec = EinsteinVision__c.getOrgDefaults();
      if(accessTokenRec.AccessToken__c == null){
        //Requires a call to the Einstein Vision Oauth Endpoint
        return getNewToken(accessTokenRec);
      }else{
         AccessToken currentoken = new AccessToken(accessTokenRec.AccessToken__c,false);
         return currentoken;
      }
   }

   /** This method gets the latest token by performing a call to the Einstein Vision API
    * @param  Custom Settings Record accessTokenRec
    * @return Custom class AccessToken .
    **/

   public static AccessToken getNewToken(EinsteinVision__c accessTokenRec){
      String token = EinsteinVisionJWTBearerTokenExchange.getAccessToken(accessTokenRec.AccountId__c,
                                                            integer.valueof(accessTokenRec.ExpirationTime__c),
                                                            getPrivateKey(accessTokenRec.PrivateKeyName__c));
     AccessToken currentoken = new AccessToken(token,true);
     return currentoken;
   }

   /** This method updates the access token .Use this method only after all callouts in system is executed else you will recieve pending DML exception
    * @param  String access token
    * @return void
    **/

   public static void updateAccessToken(String newAccessToken){
      EinsteinVision__c accessTokenRec = EinsteinVision__c.getOrgDefaults();
      accessTokenRec.AccessToken__c = newAccessToken;
      try{
         update accessTokenRec;
      }catch(exception e){
        throw new AccessTokenManagerException('Update of the access token failed.Contact admin with the message '+e.getMessage());
      }
   }

   /** This method gets the String data from the ContentVersion Object
    * @param  File Name where Private key is stored .
    * @return String data (base64 encoded string format) stored in the content version file
    **/

   private static String getPrivateKey(String fileName){
       String privateKeyString = '';
       list<ContentVersion> base64Content = [SELECT Title, VersionData FROM ContentVersion where Title=:fileName ORDER BY Title LIMIT 1];
       if(base64Content.size()>0){
          privateKeyString = base64Content[0].VersionData.tostring();
          privateKeyString = privateKeyString.replace('-----BEGIN RSA PRIVATE KEY-----', '');
          privateKeyString = privateKeyString.replace('-----END RSA PRIVATE KEY-----', '');
          privateKeyString = privateKeyString.replace('\n', '');
       }else{
           throw new AccessTokenManagerException('The File Name for the Private Key is wrongly configured .Contact Your Admin');
       }
       return privateKeyString;
   }

   private class AccessTokenManagerException extends Exception {}

}