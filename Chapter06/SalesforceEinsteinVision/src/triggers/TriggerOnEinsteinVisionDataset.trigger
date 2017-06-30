trigger TriggerOnEinsteinVisionDataset on Einstein_Vision_Dataset__c (after insert) {
    //Not bulkified purposefully so that we only trigger for individual records inserted via UI
    //Use extreme caution if you plan to further bulkify this method
    if(trigger.new[0].Status__c == 'STARTED'){
       //Schedule the process of creating and training dataset
        System.schedule('DatasetCreateJob', '0 '+DateTime.now().addMinutes(2).minute()+' */1 ? * *', new EinsteinVisionCreateDatasetScheduler(trigger.new[0].Id));
    }
}