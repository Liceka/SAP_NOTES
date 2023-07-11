sap.ui.define([
	"sap/ui/base/EventProvider",
	"sap/ui/model/Sorter",
	"sap/ui/model/Filter",
	"sap/ui/model/FilterOperator",
	"sap/ui/model/json/JSONModel",
	"sap/ui/model/BindingMode"
], function (EventProvider, Sorter, Filter, FilterOperator, JSONModel, BindingMode) {
	"use strict";

	var oCustomEvent = {
		userRetrieved: "userRetrieved"
	};

	return EventProvider.extend("stms.app.aelion19.annuaire.model.DataService", {
		constructor: function (oModel) {
			//Superclass constructor
			EventProvider.prototype.constructor.apply(this, arguments);
			this._initCustomEvent("userRetrieved");

			//Dependency Injection on main model
			this._oModel = oModel;
			this._oModelUser = new JSONModel();
			this._oModel.sDefaultUpdateMethod = "PUT";
		},
		_initCustomEvent: function (sEventName) {
			if (!this.mEventRegistry[sEventName]) {
				this.mEventRegistry[sEventName] = [];
			}
		},

		attachUserRetrieved: function (oData, fnFunction, oListener) {
			this.attachEvent(oCustomEvent.userRetrieved, oData, fnFunction, oListener);
			return this;
		},

		raiseUserRetrieved: function () {
			this.fireEvent("userRetrieved");
		},

		getModel: function () {
			return this._oModel;
		},

		getModelUser: function () {
			return this._oModelUser;
		},

		getUser: function () {
			var that = this;
			return new Promise(function (resolve, reject) {
				that._oModelUser.loadData("/services/userapi/currentUser");
				that._oModelUser.attachRequestCompleted(function onCompleted(oEvent) {
					if (oEvent.getParameter("success")) {
						this.setData({
							"json": this.getJSON(),
							"status": "Success"
						}, true);
						resolve(that.getModelUser());
					} else {
						reject();
					}
				});
			});
		},

		// Récupération d'une personne
		getPersonneDetail: function (oPersonneKey) {
			return new Promise((resolve, reject) => {
				console.log(this._oModel);
				this._oModel.metadataLoaded().then(() => {
					this._oModel.setUseBatch(false);
					var sKey = this._oModel.createKey("PersonneSet", {
						Id: oPersonneKey.Id,
					});
					console.log(this._oModel);
					this._oModel.read("/" + sKey, {
						success: (oData, oResponse) => {
							resolve(oData);
						},
						error: (oError) => {
							reject(oError);
						}
					});
				}).catch((oErr) => {
					reject(oErr);
				});
			});
		},

		// Récupération d'une personne
		getCompetences: function (oPersonneKey) {
			return new Promise((resolve, reject) => {

				this._oModel.metadataLoaded().then(() => {
					this._oModel.setUseBatch(false);
					var aFilters = [];
					var oFilter = new sap.ui.model.Filter({
						path: "PersonneId",
						operator: sap.ui.model.FilterOperator.EQ,
						value1: oPersonneKey.Id
				 	});
					aFilters.push(oFilter);					

					this._oModel.read("/CompetenceSet", {
						filters: aFilters,
						success: (oData, oResponse) => {
							resolve(oData);
						},
						error: (oError) => {
							reject(oError);
						}
					});
				}).catch((oErr) => {
					reject(oErr);
				});
			});
		}
    });
});