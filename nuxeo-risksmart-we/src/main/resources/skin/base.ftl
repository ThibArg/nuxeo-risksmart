<html>
<head>
  <title>
     <@block name="title">
     RiskSmart Application
     </@block>
  </title>
  <meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
  <link rel="stylesheet" href="${skinPath}/css/site.css" type="text/css" media="screen" charset="utf-8">
  <link rel="shortcut icon" href="${skinPath}/image/favicon.gif" />
  <script src="${skinPath}/scripts/jquery-2.1.1.js"></script>
  <script src="${skinPath}/scripts/nuxeo.js"></script>
  <@block name="stylesheets" />
  <@block name="header_scripts" />
</head>

<body style="margin:0px 0px 0px 0px;">

  <div class="header" id="risksmartHeader">
    <img src="${skinPath}/img/valamis-logo.jpg"><span style="padding-left: 20px;vertical-align: bottom;">RiskSmart Application</span>
    <div class="headerRight"><div><a href="/nuxeo/site/risksmart/logout" style="color: white;">Logout</a></div></div>
  </div

  <div>
    <@block name="content">The Content</@block>
  </div>
</body>
</html>
