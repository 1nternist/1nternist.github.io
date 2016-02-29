<?php

// showPics.php
// receives $_GET parameter pointing to directory

function setExpires($expires) {
 header(
   'Expires: '.gmdate('D, d M Y H:i:s', time()+$expires).'GMT');
}
setExpires(300);

session_start();
$getPath = stripslashes(urldecode($_GET["path"]));
$images = unserialize($_SESSION["imageList"]);

//print_r($images);
$selImages = $images[$getPath]['files'];

if (count($selImages > 0)) {
  echo <<<HTML
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>iphpPod</title>
<meta name="viewport" content="width=315; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;"/>
</head>
<body>
HTML;
ob_flush();
  $i=0;
  echo "<DIV ALIGN=CENTER><TABLE CELLPADDING=0 CELLSPACING=4>";
  foreach ($selImages as $k) {
    if ($i==0) echo "<TR>";
    $i++;
    echo "<TD><A HREF='./iphpPod_media".$getPath.$k."'><IMG SRC='./iphpPod_media".$getPath.$k."' HEIGHT=96 WIDTH=96 BORDER=0></A></TD>";
    if ($i==3) {
      echo "</TR>";
      $i=0;
    }
  }
  for ($td=$i; $td < 3; $td++) {
    echo ($td==2) ? "<TD></TD></TR>" : "<TD></TD>";
  }
  echo "</TABLE></DIV>";

  echo <<<HTML
</body></html>
HTML;
}

?>
