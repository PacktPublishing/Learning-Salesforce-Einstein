public class SimilarProductRecommenderController {

    @AuraEnabled
    public static list<Product2> queryPredictionAPI(String productId){
        list<Product2> lstProducts = new list<Product2>();
         try{
            PredictionIOSettings__c pioEngineSettings = PredictionIOSettings__c.getValues('PredictionIOEngine');
            String item = ProductSelector.getProduct(productId).PredictionIOExternalId__c;
            list<String> items = new list<String>();
            items.add(item);
            //Form Predictor RequestBody
            SimilarProductRecommenderModel productPredictor = new  SimilarProductRecommenderModel();
            productPredictor.items = items;
            productPredictor.num = 4;
            String requestBody = JSON.serialize(productPredictor);
            HttpUtil http = new HttpUtil();
            HttpResponse response = http.invokePostRequest(pioEngineSettings.API_Endpoint__c,requestBody);
            system.debug('RESPONSE..'+response.getBody());
            if(response.getStatusCode() == 200){
             PredictionIOResult result = (PredictionIOResult) System.JSON.deserialize(response.getBody(), PredictionIOResult.class);
             set<String> similarProductIds = new  set<String>();
             for(PredictionIOResult.cls_itemScores pioitem :result.itemScores){
                similarProductIds.add(pioitem.item);
             }
             lstProducts = ProductSelector.getProducts(similarProductIds);
            }else{
                throw new AuraHandledException('Engine is Down...Restart the PredictionIO Engine'); 
            }
         }catch(exception e){
            throw new AuraHandledException(e.getmessage()); 
        }
        return lstProducts;
    }

}