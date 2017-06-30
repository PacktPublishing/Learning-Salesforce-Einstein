public with sharing class EinsteinVisionGetStatusScheduler implements Schedulable , Database.AllowsCallouts{
   
   public String datasetId ;
   
   public EinsteinVisionGetStatusScheduler(String datasetId){
     this.datasetId = datasetId;
   }
   
   public void execute(SchedulableContext SC) {
      getDatasetCreateStatus(datasetId);
   }

   @future(callout=true)
   private static void getDatasetCreateStatus(String datasetId){
    list<Error_Log__c> lsterrorlogs = new list<Error_Log__c>();
     //Create a new Instance of Dataset record
     Einstein_Vision_Dataset__c datasetToUpdate = new Einstein_Vision_Dataset__c();
     list<Einstein_Vision_Dataset__c> lstDatasetVision = [Select Id,Public_URL__c,DatasetId__c from Einstein_Vision_Dataset__c where DatasetId__c =:datasetId];
     if(lstDatasetVision.size()>0){
        Einstein_Vision_Dataset__c dataset = lstDatasetVision[0];
        datasetToUpdate.id = lstDatasetVision[0].id;
        EinsteinVisionDatasetResult einsteinResult = EinsteinVisionGetDataset.getDataSetStatus(datasetId,false);
        if(einsteinResult.statusMsg == 'SUCCEEDED'){
            datasetToUpdate.Status__c = einsteinResult.statusMsg;
            update datasetToUpdate;
            System.schedule('TrainDataset', '0 '+DateTime.now().addMinutes(5).minute()+' */1 ? * *', new EinsteinVisionTrainDatasetScheduler(datasetId));
        }else if(einsteinResult.statusMsg == 'FAILED'){
            lsterrorlogs.add(EinsteinVisionUtility.logError('DATASET CREATION','FAILED',dataset.Id));
            datasetToUpdate.Status__c = einsteinResult.statusMsg;
            update datasetToUpdate;
            insert lsterrorlogs;
        }else{
            //Schedule the same job again after couple minutes
            System.schedule('DatasetCreateStatusJob'+System.now(), '0 '+DateTime.now().addMinutes(2).minute()+' */1 ? * *', new EinsteinVisionGetStatusScheduler(string.valueof(einsteinResult.id)));
        }
     }
   }
}