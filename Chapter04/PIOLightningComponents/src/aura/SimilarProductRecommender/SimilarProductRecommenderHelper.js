({
    /**
     * Call apex controller method queryPredictionAPI to fetch similar products
     * @param component,event
     * @return void
     */
    getResults : function(component, event) {
        var action = component.get("c.queryPredictionAPI");
        //console.log('hello');
        var self = this;
        action.setParams({ 
            productId : component.get("v.recordId") ,
        });
        action.setCallback(this, function(res){
            //console.log('hello');
            var resState = res.getState();
            if (component.isValid() && resState === "SUCCESS") {
                var response = res.getReturnValue();
                component.set("v.products", res.getReturnValue());
                component.set("v.countOfResults", res.getReturnValue().length);
            } else if (component.isValid() && resState === "ERROR") {
                self.toast('Error',res.getError()[0].message,'error','sticky');
            }
        });
        $A.enqueueAction(action);
    },

    /**
     * toast methodd to show error message on the component
     * @param title,msg,type,mode,duration
     * @return void
     */
    toast: function(title, msg, type, mode, duration){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
                 'title': title,
                 'message': msg,
                 'type': type,
                 'mode': mode,
                 'duration': duration || 0
         });
         toastEvent.fire();
    }
    
})