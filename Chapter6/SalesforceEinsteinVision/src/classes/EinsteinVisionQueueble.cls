public with sharing class EinsteinVisionQueueble implements Queueable, Database.AllowsCallouts{

    private Einstein_Vision_Dataset__c dataset{get;Set;}
   
    public EinsteinVisionQueueble(Einstein_Vision_Dataset__c dataset){
        this.dataset = dataset;
    }
    
    public void execute(QueueableContext context) {
        list<Error_Log__c> lsterrorlogs = new list<Error_Log__c>();
        String datasetId ;
        String modelId ;
        //Create a new Instance of Dataset record
        Einstein_Vision_Dataset__c datasetToUpdate = new Einstein_Vision_Dataset__c();
        datasetToUpdate.Id = dataset.id;
        //Initiate the Creation Of Dataset Call
        try{
            EinsteinVisionDatasetResult einsteinResult = EinstieinVisionCreateDatasetUtil.createDatasetFromURLAsync(dataset.Public_URL__c,false);
            datasetId = String.valueof(einsteinResult.id);
            datasetToUpdate.DatasetId__c = datasetId;
        }catch(exception ex){
           lsterrorlogs.add(logError('DATASET CREATION',ex.getMessage(),dataset.id));
           return ;
        }
        //Check the Status of the Creation of dataset
        if(datasetId !=null){
            boolean statusSucceedorFail = false ;
            while(!statusSucceedorFail){
                EinsteinVisionDatasetResult einsteinResult = EinsteinVisionGetDataset.getDataSetStatus(datasetId,false);
                if(einsteinResult.statusMsg == 'SUCCEEDED'){
                   statusSucceedorFail = true;
                   datasetToUpdate.Status__c = einsteinResult.statusMsg;
                }else if(einsteinResult.statusMsg == 'FAILED'){
                    lsterrorlogs.add(logError('DATASET CREATION','FAILED',dataset.Id));
                    statusSucceedorFail = true;
                    datasetToUpdate.Status__c = einsteinResult.statusMsg;
                    return ;
                }else{
                    Integer start = System.Now().millisecond();
                    while(System.Now().millisecond()< start+30000){ 
                    }
                    system.debug('Data Creation is Running with Status '+einsteinResult.statusMsg);
                }
            }
        }
        //train the Dataset
        try{
            EinsteinVisionTrainDataSetResponse response = EinsteinVisionTrainDataset.trainDataSet(dataset.name,datasetId,false);
            modelId = response.modelId;
            datasetToUpdate.ModelId__c = modelId;
        }catch(exception e){
           lsterrorlogs.add(logError('TRAINING',e.getMessage(),dataset.id));
           return ;
        }
        //Poll for the response until job succeeds or fails 
        if(modelId !=null){
            boolean statusTrainingSucceedorFail = false ;
            while(!statusTrainingSucceedorFail){
                EinsteinVisionTrainDataSetResponse einsteinTrainingResult = EinsteinVisionTrainDataset.gettrainingStatus(modelId,false);
                if(einsteinTrainingResult.status == 'SUCCEEDED'){
                   statusTrainingSucceedorFail = true;
                   datasetToUpdate.Training_Status__c = einsteinTrainingResult.status;
                }else if(einsteinTrainingResult.status == 'FAILED'){
                    lsterrorlogs.add(logError('TRAINING','FAILED',dataset.Id));
                    statusTrainingSucceedorFail = true;
                    datasetToUpdate.Training_Status__c = einsteinTrainingResult.status;
                     return ;
                }else{
                    Integer start = System.Now().millisecond();
                    while(System.Now().millisecond()< start+30000){ 
                    }
                    system.debug('Data Creation is Running with Status '+einsteinTrainingResult.status);
                }
            }
        }
        //Update the dataset
        update dataset;
    }

    private static Error_Log__c logError(String jobtype,String errormessage,Id datasetId){
         Error_Log__c error = new Error_Log__c();
         error.Job_Type__c = jobtype;
         error.Error_Message__c = errormessage;
         error.Einstein_Vision_Dataset__c = datasetId;
         return error;
    }

}