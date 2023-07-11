/* global QUnit */
QUnit.config.autostart = false;

sap.ui.getCore().attachInit(function () {
	"use strict";

	sap.ui.require([
		"stmsappaelion19/annuaire/test/unit/AllTests"
	], function () {
		QUnit.start();
	});
});
