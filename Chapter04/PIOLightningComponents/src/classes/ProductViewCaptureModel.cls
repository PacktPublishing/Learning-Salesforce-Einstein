public class ProductViewCaptureModel {

    @AuraEnabled
    public String event;    //view
    @AuraEnabled
    public String entityType;    //user
    @AuraEnabled
    public String entityId;    //
    @AuraEnabled
    public String targetEntityType;    //item
    @AuraEnabled
    public String targetEntityId;    //

    public ProductViewCaptureModel(String event,String entityType,String entityId,String targetEntityType,String targetEntityId){
        this.event = event;
        this.entityType = entityType;
        this.entityId = entityId;
        this.targetEntityType = targetEntityType;
        this.targetEntityId = targetEntityId;
    }

}