sap.ui.define([
	"stms/app/aelion19/annuaire/controller/BaseController",
	"stms/app/aelion19/annuaire/model/formatter",
	"sap/ui/model/json/JSONModel",
	"sap/ui/model/Filter",
	"sap/ui/model/FilterOperator",
	'sap/ui/core/Fragment',
	'sap/viz/ui5/controls/Popover',
], function (BaseController, formatter, JSONModel, Filter, FilterOperator, Fragment, Popover) {
        "use strict";

        return BaseController.extend("stms.app.aelion19.annuaire.controller.List", {
			formatter: formatter,
            onInit: function () {
				this.getRouter().getRoute("RouteList").attachMatched(this._onRouteMatchedList, this);
				this._oModelUser = new JSONModel();
            },
			_onRouteMatchedList: function (oEvent) {
					
			},		
			// Navigation to Detail
			navigateToDetail: function (oEvent) {
				var oPersonne = oEvent.getSource().getBindingContext().getObject();

				// Navigation to detail
				this.getRouter().navTo("RouteDetail", {
					Id: oPersonne.Id
				});
			}







        });

    });
