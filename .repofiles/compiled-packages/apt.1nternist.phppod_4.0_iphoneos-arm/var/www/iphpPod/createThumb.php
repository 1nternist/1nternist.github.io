<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>iphpPod Thumbnail Creator</title>
<meta name="viewport" content="width=315; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;"/>
<style type="text/css" media="screen">
  @import "./iui/iui.css";
</style>
</head>
<body>
  <div class="toolbar">
    <h1 id="pageTitle"></h1>
    <a href="javascript:window.close();" class='button'>Close</a>
  </div>
<ul id='home' selected='true' title='ffmpeg'>
  <LI>Running 'ffmpeg'...</LI>
<?php
include('includes.inc.php');
loadPrefs();
flush();
?>


<?php
flush();

if (!empty($_GET["file"]) && $hasFFMPEG==TRUE) {
  $ffmpegCmd = $ffmpegPath.' -y -i "'.rawurldecode($_GET["file"]).'" -f mjpeg -ss 10 -vframes 1 -s 160x120 -an iphpPod_media/mp4_thumbs/'.md5(rawurldecode($_GET["file"])).'.jpg';
  $rc = exec($ffmpegCmd);

  if (file_exists('./iphpPod_media/mp4_thumbs/'.md5(rawurldecode($_GET["file"])).'.jpg')) {
    // success
    echo "<LI STYLE='font-size:12px;'>";
    echo "<IMG STYLE='float:left;margin-right:5px;' SRC='./iphpPod_media/mp4_thumbs/".md5(rawurldecode($_GET["file"])).".jpg'>Success!<p>You will need to reload iphpPod to see the thumbnail.<P STYLE='clear:both;'></LI>";
  }
  else {
    echo "<LI>Error creating thumbnail!</LI>";
  }
}
?>
</ul>

</body></html>