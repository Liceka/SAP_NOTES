sap.ui.define([
    "sap/ui/core/UIComponent",
    "sap/ui/model/json/JSONModel",
], function (UIComponent, JSONModel) {
    "use strict";

    //The new metadata section that simply defines a reference to the root view 
    // and the previously introduced init function that is called when the component 
    // is initialized. Instead of displaying the root view directly in the index.js file 
    // as we did previously, the component will now manage the display of the app view.
    
    return UIComponent.extend("sap.ui.demo.walkthrough.Component", {
        metadata : {
            interfaces: ["sap.ui.core.IAsyncContentCreation"],
            manifest: "json"
      },

// We instantiate our data model and the i18n model like we did before in the app 
// controller. Be aware that the models are directly set on the component and not 
// on the root view of the component      
        init : function () {
            // call the init function of the parent
            UIComponent.prototype.init.apply(this, arguments);
            // set data model
         var oData = {
            recipient : {
               name : "World"
            }
         };
         var oModel = new JSONModel(oData);
         this.setModel(oModel);

        }
    });
});
