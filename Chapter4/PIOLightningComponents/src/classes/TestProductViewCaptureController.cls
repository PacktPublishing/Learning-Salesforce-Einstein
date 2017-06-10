@isTest
private class TestProductViewCaptureController{

    static testmethod void testcallEventServer(){
        Product2 product = new Product2();
        product.Name = 'Test PIO Product';
        product.Family = 'PIO Family';
        product.ProductCode = 'PIOCODE';
        product.PredictionIOExternalId__c = 'i1';
        insert product;
         //Insert the Custom Setting For PredictionIO EventServer
        PredictionIOSettings__c pioEventServer = new PredictionIOSettings__c();
        pioEventServer.Name = 'PredictionIOEventServer';
        pioEventServer.API_Endpoint__c = 'https://predictionioserver.herokuapp.com/events.json';
        pioEventServer.ApplicationID__c = '123';
        insert pioEventServer;
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockPredictionIOEventServerResponse());
        Test.StartTest();
            ProductViewCaptureController.callEventServer(product.Id);
        Test.StopTest();
    }

}