<@extends src="base.ftl">
<@block name="header_scripts"><script src="${skinPath}/scripts/RiskSmart_main.js"></script></@block>
<@block name="content">


<div id="welcomeSubHeader" class="statusSubHeader">
<p>Welcome ${Context.getProperty("firstLastName")}</p>
<p>${Context.getProperty("applicationStatus")}</p>
<p>${Context.getProperty("applicationStatusDetails")}</p>
</div>
<hr>
<div id="detailsApplication"  class="statusDetails">
<p>Application Summary</p>
<#if Context.getProperty("applicantFirstLastName")?has_content>
Submited by ${Context.getProperty("applicantFirstLastName")}<br/>
</#if>
Up to <span class="statusDetailValue">${Document["cra:max_people_involved"]}</span> people involved<br/>
Max. coverage requested: <span class="statusDetailValue">$${Document["cra:coverage_limit"]}</span><br/>
IT departement: <span class="statusDetailValue">${Document["cra:it_dpt_nb_people"]}</span> people, <span class="statusDetailValue">${Document["cra:it_dpt_nb_of_security_specialists"]}</span> specialist(s)<br/>
Previous insurance for the same risk: <span class="statusDetailValue">${Context.getProperty("prevInsurance")}</span><br/>
</div>
<script type="text/javascript" charset="utf-8">
	doInit(null, '${Context.getProperty("currentUser")}', false, "Status");
</script>

</@block>
</@extends>
