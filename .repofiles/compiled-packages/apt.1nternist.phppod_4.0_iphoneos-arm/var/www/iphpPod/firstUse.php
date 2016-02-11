<?php
// iphpPod v0.3 (c) 2008 Chris Jones
// iphpPod@gmail.com
// http://iphppod.googlepages.com

// firstUse.php
session_start();
$pathSearch = array("/private/var/mobile/Media/Downloads",
                    "/private/var/mobile/Downloads",
                    "/private/var/root/Media/Downloads",
                    "/private/var/root/Downloads");

if (file_exists("./iphpPod_media") && is_link("./iphpPod_media")) {
  $mediaDir = @readlink("./iphpPod_media");
} else {
  foreach ($pathSearch as $v) {
    if (file_exists($v) && !isset($mediaDir)) {
      $mediaDir = $v;
    }
  }
}
if (!isset($mediaDir)) {
  header("Location: noMediaDir.php");
  exit();
}

$prefsArray=array('mediaDir'=>$mediaDir,
                  'doRecursive'=>'yes');
$rsToggle = ($prefsArray['doRecursive']=='yes') ? 'true' : 'false';

$ffmpegPath = @shell_exec('find / -name ffmpeg | head -1');
if (trim($ffmpegPath)>'') {
  $hasFFMPEG = TRUE;
  $prefsArray['ffmpegPath'] = trim($ffmpegPath);
  $_SESSION["ffmpegPath"] = trim($ffmpegPath);
} else {
  $hasFFMPEG = FALSE;
  $_SESSION["ffmpegPath"] = "Not installed!";
}

if ($_GET["failedLink"]==1) {
  $failedStyle = 'STYLE="color:#FF0000;"';
  $prefsArray['mediaDir']=$_SESSION["mediaDir"];
}
?>

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

<form id='home' title="iphpPod Setup" class='panel' action='doSetup.php' method='POST' name='prefs' selected="true">
<h2>Settings</h2>
<fieldset>
  <div class="row">
    <label>Recursive Search</label>
       <div class="toggle" toggled="<?php echo $rsToggle;?>" togglename="doRecursive"><span class="thumb"></span><span class="toggleOn">ON</span><span class="toggleOff">OFF</span></div>
  </div>
</fieldset>
<h2 style="margin-bottom:-5px;">Media Location</h2>
<span style="font-size:10px;margin-left:14px;">Directory must exist and have 0777 permissions</span>
<fieldset>
  <div class="row">
    <input type="text" name="mediaDir" class="file" <?php echo $failedStyle;?> value="<?php echo $prefsArray['mediaDir'];?>">
  </div>
</fieldset>
<h2 style="margin-bottom:2px;">ffmpeg Location</h2>
<span style="font-size:14px;margin-left:14px;"><?php echo $_SESSION["ffmpegPath"];?></span>

<div align="center" style="padding-top:25px;"><input type="submit" class='custom' value="Save"/></div>
</form>

</body>
</html>
