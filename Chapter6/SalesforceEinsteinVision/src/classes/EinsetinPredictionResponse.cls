public class EinsetinPredictionResponse{
    @AuraEnabled
    public cls_probabilities[] probabilities;
    @AuraEnabled
    public String object_x;   //predictresponse
    
    public class cls_probabilities {
        @AuraEnabled
        public String label;    //beach
        @AuraEnabled
        public Double probability;  //0.9602110385894775
    }
    
    public static EinsetinPredictionResponse parse(String json){
        return (EinsetinPredictionResponse) System.JSON.deserialize(json, EinsetinPredictionResponse.class);
    }
}