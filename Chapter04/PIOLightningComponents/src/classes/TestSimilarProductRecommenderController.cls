@isTest
private class TestSimilarProductRecommenderController{

     static testmethod void queryPredictionAPI(){
        list<Product2> lstProducts = new  list<Product2>();
        for(Integer i=1 ; i<6 ;i++){
            Product2 product = new Product2();
            product.Name = 'Test PIO Product' + i;
            product.Family = 'PIO Family' + i;
            product.ProductCode = 'PIOCODE' + i;
            product.PredictionIOExternalId__c = 'i'+i;
            lstProducts.add(product);
        }
        insert lstProducts;
         //Insert the Custom Setting For PredictionIO EventServer
        PredictionIOSettings__c pioEventServer = new PredictionIOSettings__c();
        pioEventServer.Name = 'PredictionIOEngine';
        pioEventServer.API_Endpoint__c = 'https://nameless-spire-13670.herokuapp.com/queries.json';
        pioEventServer.ApplicationID__c = '123';
        insert pioEventServer;
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockPredictionIOEngineResponse());
        Test.StartTest();
            list<Product2> lstProduct = SimilarProductRecommenderController.queryPredictionAPI(lstProducts[0].Id);
            system.assertEquals(lstProduct.size(),2);
        Test.StopTest();
    }

}