({
    init : function(component, event, helper) {
      var toggleText = component.find("spinner");
      $A.util.addClass(toggleText,'toggle');
    },
    
    handleFilesChange : function(component, event, helper) {
		helper.callImagePredictor(component, event);
	},
    
    showSpinner : function (component, event, helper) {
        var toggleText = component.find("spinner");
		$A.util.removeClass(toggleText,'toggle');
    },
    
    hideSpinner : function (component, event, helper) {
      var toggleText = component.find("spinner");
	  $A.util.addClass(toggleText,'toggle');
    }
})