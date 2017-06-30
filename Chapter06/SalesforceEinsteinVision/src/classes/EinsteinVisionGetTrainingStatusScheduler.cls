public with sharing class EinsteinVisionGetTrainingStatusScheduler implements Schedulable , Database.AllowsCallouts{
   
   public String modelId ;
   
   public EinsteinVisionGetTrainingStatusScheduler(String modelId){
     this.modelId = modelId;
   }
   
   public void execute(SchedulableContext SC) {
     getDatasetTrainJobStatus(modelId);
   }

   @future(callout=true)
   private static void getDatasetTrainJobStatus(String modelId){
    list<Error_Log__c> lsterrorlogs = new list<Error_Log__c>();
     //Create a new Instance of Dataset record
     Einstein_Vision_Dataset__c datasetToUpdate = new Einstein_Vision_Dataset__c();
     list<Einstein_Vision_Dataset__c> lstDatasetVision = [Select Id,Public_URL__c,ModelId__c,Training_Status__c,DatasetId__c from Einstein_Vision_Dataset__c where  ModelId__c =: modelId];
     if(lstDatasetVision.size()>0){
        Einstein_Vision_Dataset__c dataset = lstDatasetVision[0];
        datasetToUpdate.id = lstDatasetVision[0].id;
        EinsteinVisionTrainDataSetResponse einsteinTrainingResult = EinsteinVisionTrainDataset.gettrainingStatus(modelId,false);
        if(einsteinTrainingResult.status == 'SUCCEEDED'){
          datasetToUpdate.Training_Status__c = einsteinTrainingResult.status;
          update datasetToUpdate;
        }else if(einsteinTrainingResult.status == 'FAILED'){
            lsterrorlogs.add(EinsteinVisionUtility.logError('TRAINING','FAILED',dataset.Id));
            datasetToUpdate.Training_Status__c = einsteinTrainingResult.status;
            update datasetToUpdate;
            insert lsterrorlogs;
        }else{
            //Schedule the same job again after couple minutes
            System.schedule('DatasetTrainStatusJob'+System.now(), '0 '+DateTime.now().addMinutes(5).minute()+' */1 ? * *', new EinsteinVisionGetTrainingStatusScheduler(modelId));
        }
      }
   }

   
}