public class EinsteinVisionJWT {

    public static String tokenEndpoint = 'https://api.metamind.io/v1/oauth2/token';

    public class JWTHeaderParameters{
        public String alg ;
        public JWTHeaderParameters(String alg){
           this.alg = alg;
        }
    }

    public class JWTBodyParameters{

       public String iss {get;set;}
       public String sub {get;set;}
       public String aud {get;set;}
       public Long exp {get;set;}
       public Long iat {get;set;}

       public JWTBodyParameters(String iss,String sub,String aud, Integer validFor){
          this.iss = iss;
          this.sub = sub;
          this.aud = aud;
          //Current Date Time In Integer
          Long rightNow = (dateTime.now().getTime()/1000)+1;
          this.iat = rightNow;
          this.exp = rightNow + validFor;
       }
    }

    /** This method issues JWT encoded body needed By Einstein Vision To Exchange For AccessToken
    * @param   AccountId , Expiration Time, Privatekey
    * @return JWT String
    **/
    public static String issue(String accountId , Integer expirationTime,String privateKeyString) {
        String jwt = '';
        //Create Header Encoded String
        EinsteinVisionJWT.JWTHeaderParameters header = new EinsteinVisionJWT.JWTHeaderParameters('RS256');
        String encodedHeader = base64URLencode(Blob.valueOf(System.JSON.Serialize(header)));
        //Create Body Encoded String
        EinsteinVisionJWT.JWTBodyParameters body = new EinsteinVisionJWT.JWTBodyParameters('developer.salesforce.com',accountId,
                                                                                     EinsteinVisionJWT.tokenEndpoint
                                                                                    ,expirationTime);
       system.debug('BODY...'+System.JSON.Serialize(body));
       jwt = encodedHeader + '.' + base64URLencode(Blob.valueOf(System.JSON.Serialize(body)));
       Blob signature = null;
       Blob privateKey = EncodingUtil.base64Decode(privateKeyString);
       signature = Crypto.sign('rsa-sha256', Blob.valueOf(jwt), privateKey);
       jwt += '.' + base64URLencode(signature);  
       return jwt;
    }

    private static String base64URLencode(Blob input){ 
        String output = encodingUtil.base64Encode(input);
        output = output.replace('+', '-');
        output = output.replace('/', '_');
        while ( output.endsWith('=')){
            output = output.subString(0,output.length()-1);
        }
        return output;
    }
}