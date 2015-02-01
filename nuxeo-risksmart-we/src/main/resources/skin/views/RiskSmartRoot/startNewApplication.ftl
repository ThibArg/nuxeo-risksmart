<@extends src="base.ftl">
<@block name="header_scripts"><script src="${skinPath}/scripts/RiskSmart_main.js"></script></@block>
<@block name="content">

<!-- We start with the error div, displayed when a REST request fails -->
<div id="restError" class="noDisplay restError">
<!-- content is filled dynamically by the JavaScript -->
</div>

<div id="welcomeSubHeader" class="screenTextAndFields">
<p>Welcome ${Context.getProperty("firstLastName")}</p>
</div>
<div id="startNewApplication" class="screenButtons node">
	<button id="b_startNewApplication" type="submit" name="startNewApp" class="screenButton" onclick="wantToBuyInsurance();">Buy Insurance</button>
</div>

<div id="buyInsurance_choice" class="noDisplay node">
	<div id="buyCyberRisk" class="screenButtons">
		<button id="b_buyCyberRisk" type="submit" name="buyCyberRisk" class="screenButton buyInsurance" onclick="buyOne(this);">Cyber Risk</button>
	</div>
	<div id="buyDirectorsOfficers" class="screenButtons">
		<button id="b_buyDirectorsOfficers" type="submit" name="buyDirectorsOfficers" class="screenButton buyInsurance" onclick="buyOne(this);"">Directors and Officers Insurance</button>
	</div>
	<div id="buyTerrorism" class="screenButtons">
		<button id="b_buyTerrorism" type="submit" name="buyTerrorism" class="screenButton buyInsurance" onclick="buyOne(this);"">Terrorism Insurance</button>
	</div>
	<div id="buyBusinessInterruption" class="screenButtons">
		<button id="b_nuyBusinessInterruption" type="submit" name="buyBusinessInterruption" class="screenButton buyInsurance" onclick="buyOne(this);">Business Interruption Insurance</button>
	</div>
</div>

<div id="form_cyberRisk" class="noDisplay node">
	<form id="newCyberRisk" onsubmit="return SubmitNewCyberRisk();">
		<div id="newCyberRiskData" class="screenTextAndFields">
			<p class="infoHeader smaller startNewCyberRisk">Starting the process for your Cyber Risk Insurance</p>
			<p class="startNewCyberRisk"><span class="infoText smaller">Up to </span><input type="number" class="infoField infoFieldForNumber smaller" style="width:200px" name="maxPeople" title="Number of people whose personal data can be compromised by a a hacker" required /><span class="infoText smaller"> people can be victim of cyber attack.</span></p>
			<p class="startNewCyberRisk"><span class="infoText smaller">The max. coverage I need is $</span><input type="number" class="infoField smaller" style="width:300px" name="maxCoverage" min="250000" title="Min. $250,000" required /></p>
			<p class="startNewCyberRisk"><span class="infoText smaller">There are </span><input type="number" class="infoField infoFieldForNumber smaller" name="itPeople" required /><span class="infoText smaller"> people in the IT department,</span><br/><span class="infoText smaller">and </span><input type="number" class="infoField infoFieldForNumber smaller" name="securitySpecialists" required /><span class="infoText smaller"> are security specialists</span></p>
			<p class="startNewCyberRisk"><span class="infoText smaller">My previous insurance company is </span><input type="text" class="infoField smaller" name="prevInsurance" placeHolder="(If any)" /></p>
		</div>
		<div id="startNewCyberRisk" class="screenButtons">
			<button id="b_startNewCyberRisk" type="submit" name="startNewCyberRisk" class="screenButton">Next</button>
		</div>
	</form>
</div>

<script type="text/javascript" charset="utf-8">
	doInit(null, '${Context.getProperty("currentUser")}', false, "NewApp");
</script>

</@block>
</@extends>
