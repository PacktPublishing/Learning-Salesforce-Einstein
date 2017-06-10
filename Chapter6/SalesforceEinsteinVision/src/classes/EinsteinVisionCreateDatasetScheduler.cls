public with sharing class EinsteinVisionCreateDatasetScheduler implements Schedulable {

   private Id recordId ;

   public EinsteinVisionCreateDatasetScheduler(Id recordId){
      this.recordId = recordId;
   }
   
   public void execute(SchedulableContext sc) {
     createDataset(recordId);
   }
   
   @future(callout=true)
   private static void createDataset(Id recordId){
    list<Error_Log__c> lsterrorlogs = new list<Error_Log__c>();
     //Create a new Instance of Dataset record
     Einstein_Vision_Dataset__c datasetToUpdate = new Einstein_Vision_Dataset__c();
     list<Einstein_Vision_Dataset__c> lstDatasetVision = [Select Id,Public_URL__c,DatasetId__c from Einstein_Vision_Dataset__c where Id =:recordId];
     if(lstDatasetVision.size()>0){
        Einstein_Vision_Dataset__c dataset = lstDatasetVision[0];
         try{
            EinsteinVisionDatasetResult einsteinResult = EinstieinVisionCreateDatasetUtil.createDatasetFromURLAsync(dataset.Public_URL__c,false);
            datasetToUpdate.Id = recordId;
            datasetToUpdate.DatasetId__c = string.valueof(einsteinResult.id);
            update datasetToUpdate;
            //Schedule the Job to start polling Einstein API for status of upload
            System.schedule('DatasetCreateStatusJob', '0 '+DateTime.now().addMinutes(2).minute()+' */1 ? * *', new EinsteinVisionGetStatusScheduler(string.valueof(einsteinResult.id)));
        }catch(exception ex){
           lsterrorlogs.add(EinsteinVisionUtility.logError('DATASET CREATION',ex.getMessage(),dataset.id));
           insert lsterrorlogs;
        }
     }
   }
   
}