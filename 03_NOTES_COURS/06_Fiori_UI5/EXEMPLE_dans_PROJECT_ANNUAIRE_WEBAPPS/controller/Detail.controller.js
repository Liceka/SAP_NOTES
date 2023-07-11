sap.ui.define([
	"stms/app/aelion19/annuaire/controller/BaseController",
	"stms/app/aelion19/annuaire/model/formatter",
	"sap/m/MessageBox",
	"sap/ui/core/ValueState",
	"sap/ui/core/MessageType",
	"sap/m/ColumnListItem",
	"sap/ui/model/Filter",
	"sap/ui/model/FilterOperator",
], function (BaseController, formatter, MessageBox, ValueState, MessageType, ColumnListItem, Filter, FilterOperator) {
	"use strict";

	return BaseController.extend("stms.app.aelion19.annuaire.controller.Detail", {
		formatter: formatter,
		onInit() {
			// Initialisation 
			this._resetState();

			this.getRouter().getRoute("RouteDetail").attachMatched(this._onRouteMatchedDetail, this);
		},

		_onRouteMatchedDetail: function (oEvent) {

			//Récupération de l'ID de la Personne
			this._oPersonneKey = {
				Id: oEvent.getParameter("arguments").Id,
			}

			this.getView().setBusy(true);

			//Initialisation du Model "personne"
			this.initializeViewModel("personne", null);
			this.initializeViewModel("competences", null);
			this._initPersonne(this._oPersonneKey);
		},

		// Initialisation d'une personne
		_initPersonne: function (oPersonneKey) {
			var that = this;
			var oTitle = this.getView().byId("title");

			//Récupération des informations d'un bilan
			this.getDataService().getPersonneDetail(oPersonneKey).then((oResult) => {

				that.getDataService().getCompetences(oPersonneKey).then((oResult2) => {

					//Préparation du model competence
					var oModel1 = new sap.ui.model.json.JSONModel();
					var aResults = oResult2.results;
					oModel1.setData({competences: aResults});

					//Initialisation du Model "personne"
					that.initializeViewModel("personne", oResult);
					that.initializeViewModel("competences", aResults);

					var oTable = that.byId("tableCompetences");

					oTitle.setText(that.getResourceText("personne.detail") + " " + oResult.Id); - that.getView().setBusy(false);

				}).catch((oError) => {
					sap.m.MessageToast.show(that.getResourceText("error.personne.detail"));
					that.getView().setBusy(false);
					that.navigateBack();
				});
			}).catch((oError) => {
                sap.m.MessageToast.show(that.getResourceText("error.personne.detail"));
				that.getView().setBusy(false);
				that.navigateBack();
			});
		},

		// Appui sur bouton Annuler
		onCancel: function (oEvent) {
			this.navigateBack();
		},

		// Navigation page précédente
		onNavBack: function () {
			this.navigateBack();
		},

		// Reinitialisation de l'état de la vue
		_resetState: function () {
			this._resetMessages();
		}
	});
});