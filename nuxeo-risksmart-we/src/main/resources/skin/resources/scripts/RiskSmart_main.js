/* This single .js handles all the app and the different pages
 * for this POC. More strict developments would have separate parts.

 */
// ==============================
var kDEBUG = false;
// ==============================
var CYBERRISKAPP_PREXIF = "cra", KIND_NODE = "Node", KIND_NEW_APP = "NewApp", KIND_STATUS = "Status";

var gMainDocId = "", gCurrentUser = "", gWeHaveARunningWorkflow, gCurrentTaskId, gAllDivs, gMainKind, gSubmitButton;

// This is called when the page loads.
// Depending on the current page, some values may be undefined
function doInit(docId, inUser, inWorkflowIsRunning, inKind) {
	gMainDocId = docId;
	gCurrentUser = inUser;
	gWeHaveARunningWorkflow = inWorkflowIsRunning;

	gMainKind = inKind;
}

jQuery(document).ready( function() {

	var nxClient, allDivs, oneDiv, i, max;

	if (kDEBUG) {
		console.log("Kind: " + gMainKind);
		console.log("Doc ID: " + gMainDocId);
		console.log("Current user: " + gCurrentUser);
		console.log("A workflow is running: "
				+ gWeHaveARunningWorkflow);
	}

	// Get all the divs to use, as jQuery objects
	// Build a quick access à la hashmap
	allDivs = jQuery(".node");
	gAllDivs = [];
	max = allDivs.length
	for (i = 0; i < max; i++) {
		oneDiv = allDivs[i];
		gAllDivs[oneDiv.id] = jQuery(oneDiv);
	}

	// We don't do much in term of browser/nuxeo exchanges for a
	// new application
	if (gMainKind != KIND_NODE) {
		return;
	}

	// We must get the divs, the tasks, etc. only if a workflow
	// is running
	// Else, we already are in the "lastStep" where the user can
	// only
	// download the pdf
	if (gWeHaveARunningWorkflow) {

		// Request Nuxeo to get the current task, and handle
		// this task (basically, show it and remove the others)
		// No credentials needed: If we are in this page, the
		// user is authenticated
		nxClient = new nuxeo.Client({
			timeout : 10000
		});
		// We just call our REST_getCurrentTaskId Automation
		// Chain, passing it the
		// doc id. The chain returns the current task id.
		nxClient
				.operation("REST_getCurrentTaskId")
				.context({
					"applicantDataDocId" : gMainDocId
				})
				.execute(
						function(inErr, inData) {
							if (inErr) {
								displayRestError(
										"Get the current task",
										inErr);
							} else {
								gCurrentTaskId = JSON
										.parse(inData).taskId;
								gAllDivs[gCurrentTaskId]
										.removeClass("noDisplay");
								// And delete all the other
								// ones, so submiting the form
								// => no complain
								// about non focusable, non
								// entered fields, etc.)
								Object
										.keys(gAllDivs)
										.forEach(
												function(oneKey) {
													if (oneKey != gCurrentTaskId) {
														gAllDivs[oneKey]
																.remove();
														delete gAllDivs[oneKey];
													}
												});
								if (kDEBUG) {
									var debugSpan = jQuery("#debugSpan");
									if (debugSpan == null
											|| debugSpan.length < 1) {
										jQuery(
												"#risksmartHeader")
												.append(
														"<span id='debugSpan' style='padding-left: 20px;vertical-align: super; color: yellow;'>Current task: "
																+ gCurrentTaskId
																+ "</span>");
									} else {
										debugSpan
												.text("Current task: "
														+ gCurrentTaskId);
									}
								}
							}
						});
	} else { // if(gWeHaveARunningWorkflow)
		jQuery("#nextStepButton").remove();
		jQuery("#lastStep").removeClass("noDisplay");
	}
});

function completeTask(inWFVariables, submitButton) {
	var nxClient, contextData;

	contextData = {
		"applicantDataDocId" : gMainDocId,
		"taskId" : gCurrentTaskId,
		"wfValues" : inWFVariables
	};

	// Be careful to use the transition as defined in the workflow for a node
	// (case sensitive)
	// Default transition
	contextData.transition = "validate";
	if (submitButton == "b_backToCustomer") {
		contextData.transition = "reject";
	} else if(submitButton == "b_backToBroker") {
		contextData.transition = "needInfo";
	} else if(submitButton == "b_reject") {
		contextData.transition = "reject";
	}

	nxClient = new nuxeo.Client({
		timeout : 10000
	});
	nxClient.operation("REST_completeTask").context(contextData).execute(
			function(inErr, inData) {
				var result;
				if (inErr) {
					displayRestError("Complete the current task", inErr);
				} else {
					window.location.reload(true);
				}
			});
}

function displayRestError(inContextLabel, inTheErr) {
	var html = "";

	// Delete all divs
	Object.keys(gAllDivs).forEach(function(oneKey) {
		gAllDivs[oneKey].remove();
		delete gAllDivs[oneKey];
	});
	// Fill in the error div
	html += "<p>An error occured while requesting the server</p>" + "<p>\""
			+ inContextLabel + "\"</p>" + "<p>" + JSON.stringify(inTheErr)
			+ "</p>";
	jQuery("#restError").html(html);
	jQuery("#restError").removeClass("noDisplay");
	// Remove the submit button
	jQuery("#nextStepButton").remove();
	// Should add something to let the user relod or test something else...
}

/*
 * Handle submission of the form. At this step, validation of required field has
 * been performed by the browser. We get the values to send to a chain which
 * will complete the task Also, we return false, as this function is called for
 * the "onsubmit" action of the form, so the browser does not try to submit the
 * form
 * 
 * Also we have to handle special cases: -> Boolean values -> Photo upload
 */
function SubmitNodeForm() {
	var val, inputs, wfVarAssign, nxClient, boolStrFields = [];

	// Get all inputs for the dive
	inputs = jQuery("form#mainForm div#" + gCurrentTaskId + " :input");

	wfVarAssign = {};
	inputs.each(function() {
		var input = $(this), fieldName = input.attr("name").replace("ad:", "");
		wfVarAssign[fieldName] = input.val();
	});

	// Handle specific cases (convert bool-striongs to real booleans)
	boolStrFields.forEach(function(inField) {
		if (inField in wfVarAssign) {
			val = wfVarAssign[inField];
			wfVarAssign[inField] = (val.toLowerCase() === "yes" || val
					.toLowerCase() == "y");
		}
	});

	var submitButton = gSubmitButton;
	gSubmitButton = "";
	completeTask(wfVarAssign, submitButton);
	/*
	 * nxClient = new nuxeo.Client({timeout: 10000});
	 * nxClient.operation("REST_completeTask") .context({ "applicantDataDocId":
	 * gMainDocId, "taskId": gCurrentTaskId, "wfValues": wfVarAssign})
	 * .execute(function(inErr, inData) { if(inErr) { displayRestError("Complete
	 * the current task", inErr); } else { window.location.reload(true); } }); }
	 */

	return false;
}

/* ******************************************** */
/* Handling the "start new application" page(s) */
/* ******************************************** */
function wantToBuyInsurance() {
	jQuery("#b_startNewApplication").fadeOut(function() {
		jQuery("#buyInsurance_choice").fadeIn();
	});
}

function buyOne(whichOne) {
	if (whichOne.id == "b_buyCyberRisk") {
		startCyberRisk();
	} else {
		alert("Only \"Cyber Risk\" has been implemented in this POC");
	}
}

function startCyberRisk() {

	jQuery("#buyInsurance_choice").fadeOut(function() {
		jQuery("#welcomeSubHeader").hide(function() {
			jQuery("#form_cyberRisk").fadeIn();
		});
	});
}

function SubmitNewCyberRisk() {

	var val, inputs, formVars, nxClient;

	// Get all inputs for the dive
	inputs = jQuery("form#newCyberRisk :input");

	formVars = {};
	inputs.each(function() {
		var input = $(this), fieldName = input.attr("name");// .replace("ad:",
															// "");
		formVars[fieldName] = input.val();
	});

	// Send request to nuxeo, to create the CyberRiskApp and start the workflow
	var nxClient;

	nxClient = new nuxeo.Client({
		timeout : 10000
	});
	nxClient
			.operation("REST_createCyberRiskAppAndStartWF")
			.context(formVars)
			.execute(
					function(inErr, inData) {
						var result;
						if (inErr) {
							displayRestError(
									"Submit the Cyber Risk Application", inErr);
						} else {
							window.location.reload(true);
						}
					});

	return false;
}
