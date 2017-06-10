public class EinsteinVisionTrainDataSetResponse{

    public Integer datasetId;   //57
    public Integer datasetVersionId;    //0
    public String name_x; //Beach and Mountain Model
    public String status;   //SUCCEEDED
    public Double progress;    //1
    public String createdAt;    //2016-09-16T18:03:21.000+0000
    public String updatedAt;    //2016-09-16T18:03:21.000+0000
    public Double learningRate; //0.001
    public Double epochs;  //3
    public String object_x;   //training
    public String modelId;  //7JXCXTRXTMNLJCEF2DR5CJ46QU
    public cls_trainParams trainParams;
    public cls_trainStats trainStats;
    public String modelType;    //image
    public class cls_trainParams {
        public Double trainSplitRatio;  //0.7
    }
    
    public class cls_trainStats {
    
    }
    
    public static EinsteinVisionTrainDataSetResponse parse(String json){
        return (EinsteinVisionTrainDataSetResponse) System.JSON.deserialize(json, EinsteinVisionTrainDataSetResponse.class);
    }
    
  }