public with sharing class UserSelector {
  
  /**
    * Gets User Record for the Current Context
    * @param    None
    * @throws   None
    */ 

    public static User getCurrentUser(){
        return [Select Id ,Name,PredictionIOExternalId__c from User where Id = :UserInfo.getUserId() limit 1];
    }

}