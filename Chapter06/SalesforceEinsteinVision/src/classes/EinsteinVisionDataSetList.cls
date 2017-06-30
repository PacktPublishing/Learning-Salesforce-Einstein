public class EinsteinVisionDataSetList{

    public String object_x;   //list
    public cls_data[] data;
    
    public class cls_data {
        public Integer id;  //57
        public String name; //Beach and Mountain
        public String updatedAt;    //2016-09-09T22:39:22.000+0000
        public String createdAt;    //2016-09-09T22:39:22.000+0000
        public cls_labelSummary labelSummary;
        public Integer totalExamples;   //99
        public Integer totalLabels; //2
        public boolean available;
        public String statusMsg;    //SUCCEEDED
        public String type; //image
        public String object_x;   //dataset
    }
    
    public class cls_labelSummary {
        public cls_labels[] labels;
    }
    
    public class cls_labels {
        public Integer id;  //36
        public Integer datasetId;   //57
        public String name; //beach
        public Integer numExamples; //49
    }
    
    public static EinsteinVisionDataSetList parse(String json){
        return (EinsteinVisionDataSetList) System.JSON.deserialize(json, EinsteinVisionDataSetList.class);
    }
    
  }