sap.ui.define([],
	function () {
		"use strict";

		return {
			formatName: function (sTitle, sLastname) {
				//Ex 4
			},

			formatItemsListHighlight: function (bActive) {
				if (bActive) {
						return sap.ui.core.MessageType.Success;
				}else{}
						return sap.ui.core.MessageType.Warning;	
				},

			formatErrorsListHighlight: function (sType) {
				switch (sType) {
					case 'E':
						return sap.ui.core.MessageType.Error;
					case 'X':
						return sap.ui.core.MessageType.Warning;	
					default:
						return 'None';
				}
			},
			
			formatName : function (Title, Lastname) { 
				let str1 = Title; 
				let str2 = Lastname; 
				let result = Title + " " + Lastname; return result; }

		};

	});