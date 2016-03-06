<?php

// noMediaDir.php
echo <<<HEAD
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>iphpPod - Setup</title>
<meta name="viewport" content="width=315; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;"/>
<style type="text/css" media="screen">
  @import "./iui/iui.css";
</style>
<script type="application/x-javascript" src="./iui/iui.js"></script>
</head>
<body>

    <div class="toolbar">
        <h1 id="pageTitle"></h1>
    </div>
HEAD;

if (file_exists('/private/var/mobile')) {
  echo <<<HTML
<div id="home" selected="true" title="Setup Error!" style="font-size:14px;margin:5px 5px 5px 5px">
<div align=center><h2>Downloaded Media directory not found!</h2></div>
<p>Please create one of the following<br/>directories via SSH:</p>
<p><b>
/private/var/mobile/Downloads<br/>
/private/var/mobile/Media/Downloads<br/>
/private/var/root/Downloads<br/>
/private/var/root/Media/Downloads<br/></b>
</p>
<p style="color:red;">Remember to set permissions on the directory <br/>to <b>0777</b>!</p>
<div align=center><input type='button' class='custom' onclick='top.document.location.href="firstUse.php";' value="Try again"/></div>
</div>
</body></html>
HTML;
}
else
if (file_exists('/private/var/root')) {
  echo <<<HTML
<div id="home" selected="true" title="Setup Error!" style="margin:5px 5px 5px 5px">
<h2>Downloaded Media directory not found!</h2>
<p>Please create one of the following directories via SSH:</p>
<p><b>
/private/var/root/Downloads<br/>
/private/var/root/Media/Downloads<br/></b>
</p>
<p style="color:red;">Remember to set permissions on<br/>the directory to 0777!</p>
<div align=center><input type='button' class='custom' onclick='top.document.location.href="firstUse.php";' value="Try again"/></div>
</div>
</body></html>
HTML;
}

?>