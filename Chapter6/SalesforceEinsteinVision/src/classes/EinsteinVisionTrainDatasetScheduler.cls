public with sharing class EinsteinVisionTrainDatasetScheduler implements Schedulable , Database.AllowsCallouts{
   
   public String datasetId ;
   
   public EinsteinVisionTrainDatasetScheduler(String datasetId){
     this.datasetId = datasetId;
   }
   
   public void execute(SchedulableContext SC) {
     trainDataset(datasetId);
   }

   @future(callout=true)
   private static void trainDataset(String datasetId){
    list<Error_Log__c> lsterrorlogs = new list<Error_Log__c>();
     //Create a new Instance of Dataset record
     Einstein_Vision_Dataset__c datasetToUpdate = new Einstein_Vision_Dataset__c();
     list<Einstein_Vision_Dataset__c> lstDatasetVision = [Select Id,Name,Public_URL__c,DatasetId__c,ModelId__c from Einstein_Vision_Dataset__c where DatasetId__c =:datasetId];
     if(lstDatasetVision.size()>0){
        Einstein_Vision_Dataset__c dataset = lstDatasetVision[0];
        //train the Dataset
        try{
            EinsteinVisionTrainDataSetResponse response = EinsteinVisionTrainDataset.trainDataSet(dataset.name,datasetId,false);
            datasetToUpdate.Id = dataset.Id;
            String modelId = response.modelId;
            datasetToUpdate.ModelId__c = modelId;
            update datasetToUpdate;
             //Schedule the Job to start polling Einstein API for status of upload
            System.schedule('DatasetTrainStatusJob', '0 '+DateTime.now().addMinutes(2).minute()+' */1 ? * *', new EinsteinVisionGetTrainingStatusScheduler(modelId));
        }catch(exception e){
           lsterrorlogs.add(EinsteinVisionUtility.logError('TRAINING',e.getMessage(),dataset.id));
           insert lsterrorlogs;
        }
     }
   }
}