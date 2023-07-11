sap.ui.define([
	"sap/ui/core/mvc/Controller",
	"sap/ui/model/json/JSONModel",
	"sap/ui/core/routing/History"
], function(Controller, JSONModel, History) { 
	"use strict";

	return Controller.extend("stms.app.aelion19.annuaire.controller.BaseController", {

		getRouter: function () {
			return this.getOwnerComponent().getRouter();
		},

		getModel: function (sModel) {
			return this.getOwnerComponent().getModel(sModel);
		},

		setModel: function (sModel, oData) {
			this.getOwnerComponent().setModel(sModel, oData);
		},

		getResourceText: function (sText) {
			return this.getModel("i18n").getResourceBundle().getText(sText);
		},

		getDataService: function () {
			return this.getOwnerComponent().getDataService();
		},

		initializeViewModel: function (sName, oData) {
			this.getView().setModel(new JSONModel(oData), sName);
			this.getView().bindElement(sName + ">/");
		},

		getUserName: function () {
			return this.getOwnerComponent().getUserName();
		},

		getViewModel: function (sName) {
			return this.getView().getModel(sName);
		},

		// on Popover press
		onPopoverPress: function (oEvent) {
			if (!this.oMP) {
				this.createMessagePopover();
			}
			this.oMP.toggle(oEvent.getSource());
		},

		// Create a message popover
		createMessagePopover: function () {
			this.oMP = sap.ui.xmlfragment("stms.app.aelion19.annuaire.view.fragment.Popover", this);
			this.getView().byId("popover").addDependent(this.oMP);
		},

		// Reset messages
		_resetMessages: function () {
			var oMsg = {
				length: 0,
				Messages: []
			};

			// Réinitialisation du modèle pour message
			this.initializeViewModel("messages", oMsg);
		},

        // Back Navigation 
		navigateBack: function () {
			var oHistory = History.getInstance();
			var sPreviousHash = oHistory.getPreviousHash();
			if (sPreviousHash !== undefined) {
				window.history.go(-1);
			} else {
				this.getRouter().navTo("RouteList", null, true);
			}
		}


	});
});