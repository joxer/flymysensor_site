<html>
<head>
<title>OpenPicus dev board</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
<script src="/javascripts/picus.js"></script>

<link media="all" href="/css/picus.css" rel="stylesheet" type="text/css">

<link media="all" href="/css/css_1.css" rel="stylesheet" type="text/css">
<link media="all" href="/css/css_2.css" rel="stylesheet" type="text/css">
<link media="all" href="/css/css_3.css" rel="stylesheet" type="text/css">
<link media="all" href="/css/css_4.css" rel="stylesheet" type="text/css">
</head>
<body class="html not-front logged-in no-sidebars page-node page-node- page-node-25 node-type-static-pages i18n-en">
  <div id="skip-link">
    <div id="page-internal-header">
      <div id="page-footer">
	<div id="page">
	  <div id="header">
	    <a href="http://www.openpicus.com"><img border="0" width="200px" src="/images/logo.png"></a>
	    <div class="region region-header">
	      <div class="block block-menu" id="block-menu-menu-logout-menu">
		<div class="content">
		  <!--    <ul class="menu"><li class="first leaf"><a title="" href="/user">My account</a></li>
			  <li class="leaf"><a title="" href="http://www.openpicus.com/user/register">Edit account</a></li>
		    <li class="last leaf"><a title="" href="/user/logout">Logout</a></li>
		  </ul>-->
		</div>
	      </div>
	    </div>
	    <div class="navigation" id="main-menu">
              <h2 class="element-invisible">Main menu</h2><ul class="links clearfix" id="main-menu-links">
		<li class="menu-1065 "><a href="/index.php/default/help">Help</a></li>
		<? if(isset($_SESSION) && $_SESSION['logged'] == "logged"){?>
		<li class="menu-418 active-trail"><a href="/index.php/default/flyports_projects_all">Account</a></li>
		<li class="menu-1065"><a href="/index.php/default/logout">Logout</a></li>

		<? }else{ ?>
		<li class="menu-416 first"><a href="/index.php/default/index">Login</a></li>
		<? }?>
	      </ul>     
	    </div>
	  </div>
	</div>
      </div>
    </div>
  </div>
  <div id="main" style="width:935px; padding-top:40px;margin:0;margin-left:auto;margin-right:auto;">

  <div id="error"><?= isset($error)?$error:"" ?></div>
  <div id="notice"><?= isset($notice)?$notice:"" ?></div>
