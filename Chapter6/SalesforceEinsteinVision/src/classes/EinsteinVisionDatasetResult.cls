public class EinsteinVisionDatasetResult{
    
    @AuraEnabled
    public Integer id;  //1000014
    @AuraEnabled
    public String name; //mountainvsbeach
    @AuraEnabled
    public String createdAt;    //2017-02-16T16:25:57.000+0000
    @AuraEnabled
    public String updatedAt;    //2017-02-16T16:25:57.000+0000
    @AuraEnabled
    public cls_labelSummary labelSummary;
    @AuraEnabled
    public Integer totalExamples;   //0
    @AuraEnabled
    public boolean available;
    @AuraEnabled
    public String statusMsg;    //UPLOADING
    @AuraEnabled
    public String type; //image
    @AuraEnabled
    public String object_x;   //dataset
    
    public class cls_labelSummary {
        public cls_labels[] labels;
    }
    
    public class cls_labels {
       @AuraEnabled
       public String datasetId ;
       @AuraEnabled
       public String Id;
       @AuraEnabled
       public String name;
       @AuraEnabled
       public Integer numExamples; 
    
    }
    
    public static EinsteinVisionDatasetResult parse(String json){
        return (EinsteinVisionDatasetResult) System.JSON.deserialize(json, EinsteinVisionDatasetResult.class);
    }
    
 }