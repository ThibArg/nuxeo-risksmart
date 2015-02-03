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
<div id="Task162e" class="noDisplay node">
	<p class="statusHeader">Welcome ${Context.getProperty("firstLastName")}</p>
	<p><span class="infoText">The broker is requesting the following informations</span></p>
	<p><i>(...to be done, work in progress...)</i></p>
</div>

<!-- Broker Review application for completeness -->
<div id="Task1ff3" class="noDisplay node statusSubHeader">
	<p class="statusSubHeader">Welcome ${Context.getProperty("firstLastName")}</p>
	<p><span class="statusSubHeader">${Context.getProperty("applicantFirstLastName")} submitted a Cyber Risk Application (${Document["dc:title"]}) with the following details:</span></p>
	Up to <span class="statusDetailValue">${Document["cra:max_people_involved"]}</span> people involved<br/>
Max. coverage requested: <span class="statusDetailValue">$${Document["cra:coverage_limit"]}</span><br/>
IT department: <span class="statusDetailValue">${Document["cra:it_dpt_nb_people"]}</span> people, <span class="statusDetailValue">${Document["cra:it_dpt_nb_of_security_specialists"]}</span> specialist(s)<br/>
Previous insurance for the same risk: <span class="statusDetailValue">${Context.getProperty("prevInsurance")}</span><br/>
<p></p>
<p>Insurer Comment: <span class="statusDetailValue"><#if Document["cra:insurer_comment"]?has_content>${Document["cra:insurer_comment"]}<#else>(none)</#if></span></p>
<p>Comment:<input type="text" class="infoField smaller status" style="width:800px" name="broker_comment" value="${Document['cra:broker_comment']}" /></p>

<div id="nextButtonDiv" class="screenButtons">
	<button id="b_backToCustomer" type="submit" onclick="gSubmitButton=this.id" name="backToCustomer" class="screenButton">Need More Detais</button>
	<button id="b_moveToInsurer" type="submit" onclick="gSubmitButton=this.id" name="moveToInsurer" class="screenButton">Move to Insurer</button>
</div>

</div>

<!-- Insurer review -->
<div id="Task282c" class="noDisplay node statusSubHeader">
	<p class="statusSubHeader">Welcome ${Context.getProperty("firstLastName")}</p>
	<p><span class="statusSubHeader">${Context.getProperty("applicantFirstLastName")} submitted a Cyber Risk Application (${Document["dc:title"]}) with the following details:</span></p>
	Up to <span class="statusDetailValue">${Document["cra:max_people_involved"]}</span> people involved<br/>
Max. coverage requested: <span class="statusDetailValue">$${Document["cra:coverage_limit"]}</span><br/>
IT department: <span class="statusDetailValue">${Document["cra:it_dpt_nb_people"]}</span> people, <span class="statusDetailValue">${Document["cra:it_dpt_nb_of_security_specialists"]}</span> specialist(s)<br/>
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

<!-- Insurer Prepare Offer -->
<div id="Task39b6" class="noDisplay node statusSubHeader">
	<div style="line-height:0.6em">
		<p>${Context.getProperty("firstLastName")}: Offer for Cyber Risk Application ${Document["dc:title"]}</p>
	</div>
	<hr>
	<div id="detailsApplication"  class="statusSmallDetails" >
		<p>Application<#if Context.getProperty("applicantFirstLastName")?has_content>
		Submited by ${Context.getProperty("applicantFirstLastName")}</#if></p>
		Up to <span class="statusDetailValue">${Document["cra:max_people_involved"]}</span> people involved, Max. coverage requested: <span class="statusDetailValue">$${Document["cra:coverage_limit"]}</span>,<br/>IT department: <span class="statusDetailValue">${Document["cra:it_dpt_nb_people"]}</span> people, <span class="statusDetailValue">${Document["cra:it_dpt_nb_of_security_specialists"]}</span> specialist(s), Previous insurance for the same risk: <span class="statusDetailValue">${Context.getProperty("prevInsurance")}</span>
	</div>
	<hr>
	<div class="build_offer">
		<p><b>Policy Period</b>&nbsp;&nbsp;&nbsp;from &nbsp;<input type="text" class="infoFieldOffer infoFieldOfferDate" name="o_inception_date" value="${Context.getProperty("offerStartDate")}" placeHolder="yyyy-mm-dd" required /> to <input type="text" class="infoFieldOffer infoFieldOfferDate" name="o_expiration_date" value="${Context.getProperty("offerEndDate")}" placeHolder="yyyy-mm-dd" required /></p>
		<p><b>Company</b>&nbsp;&nbsp;&nbsp; email: <input type="text" class="infoFieldOffer infoFieldOfferMail" name="o_email" value="${Context.getProperty("companyEmail")}" required />, FAX: <input type="text" class="infoFieldOffer infoFieldOfferTel" name="o_fax" value="${Document['offer:fax']}" /><br/><div style="display:inline-block;width:200px" >&nbsp;</div>street: <input type="text" class="infoFieldOffer infoFieldOfferMail" name="o_address_street" value="${Document['offer:address_street']}" required />, City-State-Zip: <input type="text" class="infoFieldOffer infoFieldOfferMail" name="o_address_city_state_zip" value="${Document['offer:address_city_state_zip']}" required /><br /></p>
		<p><b>Coverage</b>&nbsp;&nbsp;&nbsp;for <i>Private Company Directors and Officers Liability</i></p>
		<p>Limit of liability: <input type="text" class="infoFieldOffer" name="o_liability_limit" value="${Document['cra:coverage_limit']}" required /><br/>Supplemental Personal Indemnification Coverage: <input type="text" class="infoFieldOffer" style="width:100px" name="o_supplemental_personal_indeminification" placeHolder="yes/no" />, with Limit: <input type="text" class="infoFieldOffer" name="o_supplemental_personal_indeminification_limit" /><br/>Additional Defense Coverage: <input type="text" class="infoFieldOffer" style="width:100px" name="o_additional_def_coverage" placeHolder="yes/no" />, with Limit: <input type="text" class="infoFieldOffer" name="o_additional_def_coverage_limit" />
		</p>
	</div>

	<div id="nextButtonDiv" class="screenButtons">
		<button id="b_toBrokerReviewOffer" type="submit" onclick="gSubmitButton=this.id" name="brokerReviewOffer" class="screenButton" style="font-size:smaller">Send to broker for review</button>
	</div>
</div>

<!-- Last Check by Broker -->
<div id="Task3c0b" class="noDisplay node statusSubHeader">
	<div style="line-height:0.6em">
		<p>Review Offer for Cyber Risk Application ${Document["dc:title"]}</p>
	</div>
	<hr>
	<div id="detailsApplication"  class="statusSmallDetails" >
		<p>Application<#if Context.getProperty("applicantFirstLastName")?has_content>
		Submited by ${Context.getProperty("applicantFirstLastName")}</#if></p>
		Up to <span class="statusDetailValue">${Document["cra:max_people_involved"]}</span> people involved, Max. coverage requested: <span class="statusDetailValue">$${Document["cra:coverage_limit"]}</span>,<br/>IT department: <span class="statusDetailValue">${Document["cra:it_dpt_nb_people"]}</span> people, <span class="statusDetailValue">${Document["cra:it_dpt_nb_of_security_specialists"]}</span> specialist(s), Previous insurance for the same risk: <span class="statusDetailValue">${Context.getProperty("prevInsurance")}</span>
	</div>
	<hr>
	<div id="detailsOffer"  class="statusSmallDetails" >
		<p>Offer Details</p>
		<p><b>Policy Period</b> from <span class="statusDetailValue">${Document["offer:inception_date"]}</span> to <span class="statusDetailValue">${Document["offer:expiration_date"]}</span><br/>
		<b>Company</b> email: <span class="statusDetailValue">${Document["offer:email"]}</span>, fax: <span class="statusDetailValue">${Document["offer:fax"]}</span><br/><span class="statusDetailValue">${Document["offer:address_street"]}</span> - <span class="statusDetailValue">${Document["offer:address_city_state_zip"]}</span><br/>
		<b>Coverage</b>&nbsp;&nbsp;&nbsp;for <i>Private Company Directors and Officers Liability</i>
		Limit of liability: <span class="statusDetailValue">${Document["offer:liability_limit"]}</span><br/>
		Supplemental Personal Indemnification Coverage: <span class="statusDetailValue">${Context.getProperty("supPersCovStr")}</span>, limit $<span class="statusDetailValue">${Document["offer:supplemental_personal_indeminification_limit"]}</span><br/>
		Additional Defense Coverage: <span class="statusDetailValue">${Context.getProperty("additionalDefCovStr")}</span>, limit $<span class="statusDetailValue">${Document["offer:additional_def_coverage_limit"]}</span>
		</p>
	</div>

	<div id="nextButtonDiv" class="screenButtons">
		<button id="b_brokerValidateOfferReview" type="submit" onclick="gSubmitButton=this.id" name="brokerValidateOfferReview" class="screenButton" style="font-size:smaller">Send to customer</button>
	</div>

</div>



<#else> <!-- check the "workflowIsRunning" property at the beginning of this file -->
<div>(... Work in progress... Should not be there</div>
</#if>
