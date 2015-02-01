<!--
Each div **must** use the "noDisplay" and the "node" class. This is required
In this context, we have the Document instance avilable so we can use any field
to prefill values
-->
<!-- We start with the error div, displayed when a REST request fails -->
<div id="restError" class="noDisplay restError">
<!-- content is filled dynamically by the JavaScript -->
</div>

<!-- Prepare all the stuff only if the workflow is running -->
<#if Context.getProperty("workflowIsRunning")>

<!-- Insured Fill out broker application -->
<div id="Task1c6c" class="noDisplay node">
	<p class="statusHeader">Welcome ${Context.getProperty("firstLastName")}</p>
	<p><span class="infoText">The broker is requesting the following informations</span></p>
	<p><i>(...to be done, work in progress...)</i></p>
</div>

<!-- Broker Review application for completeness -->
<div id="Task1e4a" class="noDisplay node statusSubHeader">
	<p class="statusSubHeader">Welcome ${Context.getProperty("firstLastName")}</p>
	<p><span class="statusSubHeader">${Context.getProperty("applicantFirstLastName")} submitted a Cyber Risk Application (${Document["dc:title"]}) with the following details:</span></p>
	Up to <span class="statusDetailValue">${Document["cra:max_people_involved"]}</span> people involved<br/>
Max. coverage requested: <span class="statusDetailValue">$${Document["cra:coverage_limit"]}</span><br/>
IT departement: <span class="statusDetailValue">${Document["cra:it_dpt_nb_people"]}</span> people, <span class="statusDetailValue">${Document["cra:it_dpt_nb_of_security_specialists"]}</span> specialist(s)<br/>
Previous insurance for the same risk: <span class="statusDetailValue">${Context.getProperty("prevInsurance")}</span><br/>
<p></p>
<p>Insurer Comment: <span class="statusDetailValue"><#if Document["cra:insurer_comment"]?has_content>${Document["cra:insurer_comment"]}<#else>(none)</#if></span></p>
<p>Comment:<input type="text" class="infoField smaller status" style="width:800px" name="broker_comment" value="${Document['cra:broker_comment']}" /></p>

<div id="nextButtonDiv" class="screenButtons">
	<button id="b_backToCustomer" type="submit" onclick="gSubmitButton=this.id" name="backToCustomer" class="screenButton">Need More Detais</button>
	<button id="b_moveToInsurer" type="submit" onclick="gSubmitButton=this.id" name="moveToInsurer" class="screenButton">Move to Insurer</button>
</div>

</div>

<!-- Insurer denies coverage / makes offer -->
<div id="Task2100" class="noDisplay node statusSubHeader">
	<p class="statusSubHeader">Welcome ${Context.getProperty("firstLastName")}</p>
	<p><span class="statusSubHeader">${Context.getProperty("applicantFirstLastName")} submitted a Cyber Risk Application (${Document["dc:title"]}) with the following details:</span></p>
	Up to <span class="statusDetailValue">${Document["cra:max_people_involved"]}</span> people involved<br/>
Max. coverage requested: <span class="statusDetailValue">$${Document["cra:coverage_limit"]}</span><br/>
IT departement: <span class="statusDetailValue">${Document["cra:it_dpt_nb_people"]}</span> people, <span class="statusDetailValue">${Document["cra:it_dpt_nb_of_security_specialists"]}</span> specialist(s)<br/>
Previous insurance for the same risk: <span class="statusDetailValue">${Context.getProperty("prevInsurance")}</span><br/>
<p></p>
<p>Broker Comment: <span class="statusDetailValue"><#if Document["cra:broker_comment"]?has_content>${Document["cra:broker_comment"]}<#else>(none)</#if></span></p>
<p>Comment:<input type="text" class="infoField smaller status" style="width:800px" name="insurer_comment" value="${Document['cra:insurer_comment']}" /></p>

<div id="nextButtonDiv" class="screenButtons">
	<button id="b_backToBroker" type="submit" onclick="gSubmitButton=this.id" name="backToBroker" class="screenButton">Need More Detais</button>
	<button id="b_reject" type="submit" onclick="gSubmitButton=this.id" name="reject" class="screenButton">Reject</button>
	<button id="b_offer" type="submit" onclick="gSubmitButton=this.id" name="offer" class="screenButton">Move to Offer</button>
</div>
</div>

<!-- Attachments -->
<#else> <!-- check the "workflowIsRunning" property at the beginning of this file -->
<div>(... Work in progress... Should not be there</div>
</#if>
