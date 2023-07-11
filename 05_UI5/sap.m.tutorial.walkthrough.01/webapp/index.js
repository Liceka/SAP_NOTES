

sap.ui.define([
    "sap/ui/core/ComponentContainer"
], function (ComponentContainer) {
    "use strict";

    ComponentContainer.create({
		name: "sap.ui.demo.walkthrough",
		settings : {
				id : "walkthrough"
		},
		async: true
	}).placeAt("content");

	});
