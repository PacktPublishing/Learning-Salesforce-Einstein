public with sharing class ProductViewCaptureController {

     /**
    * Makes an API call to PredictionIO Event Server To Capture Product View Event
    * @param    Id of the Product
    * @throws   AuraEnabled Exception if something fails
    */ 
    @AuraEnabled
    public static void callEventServer(String productId){
        if(productId == null){
            throw new AuraHandledException('ProductId is missing..'); 
        }
        try{
            PredictionIOSettings__c pioSettings = PredictionIOSettings__c.getValues('PredictionIOEventServer'); 
            String endPoint = pioSettings.API_Endpoint__c + '?accessKey=' + pioSettings.ApplicationID__c;
            String pioproductId = ProductSelector.getProduct(productId).PredictionIOExternalId__c;
            String piouserId = UserSelector.getCurrentUser().PredictionIOExternalId__c;
            ProductViewCaptureModel productviewEvent = new ProductViewCaptureModel('view','user',piouserId,'item',pioproductId);
            String requestBody = JSON.serialize(productviewEvent);
            HttpUtil http = new HttpUtil();
            HttpResponse response = http.invokePostRequest(endPoint,requestBody);
            if(response.getStatusCode() != 201){
                throw new AuraHandledException('Free Dyno is Sleeping ...Start the server'); 
            }
        }catch(exception e){
            throw new AuraHandledException(e.getmessage()); 
        }
       
    }

   
}