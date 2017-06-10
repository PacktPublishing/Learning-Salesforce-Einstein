public with sharing class ProductSelector {
   /**
    * Gets Product from the ID
    * @param    productId
    * @throws   None
    */ 
    public static Product2 getProduct(String productId){
       return [Select Id ,Name,PredictionIOExternalId__c from Product2 where Id = :productId limit 1];
    }

    /**
    * Gets Product from the set of Ids
    * @param    productId
    * @throws   None
    */ 
    public static list<Product2> getProducts(set<String> productIds){
       return [Select Id ,Name,PredictionIOExternalId__c,Family,ProductCode from Product2 where PredictionIOExternalId__c IN :productIds];
    }

}