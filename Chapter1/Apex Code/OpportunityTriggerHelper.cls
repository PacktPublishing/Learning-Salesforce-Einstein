//Apex Class to make a Callout to google Prediction API

public with sharing class opportunityTriggerHelper{

   @future(callout=true)
   public static void predictProbability(Id OpportunityId){
       
        Opportunity oppData = [Select Id,Amount,Type, Predicted_Probability__c from Opportunity where Id =:OpportunityId];
       
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Google_Auth');
        req.setMethod('POST');
        req.setHeader('content-type','application/json');
    
        //Form the Body
        PredictionAPIInput apiInput = new PredictionAPIInput();
        PredictionAPIInput.csvData csvData = new PredictionAPIInput.csvData();
        csvData.csvInstance  = new list<String>{oppData.Type,String.valueof(oppData.Amount)};
        apiInput.input = csvData;
    
        Http http = new Http();
        req.setBody(JSON.serialize(apiInput));
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        
        if(res.getStatusCode() == 200){
           Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
           oppData.Predicted_Probability__c = Decimal.valueof((string)result.get('outputValue'));
           update oppData;
        }
   }
}