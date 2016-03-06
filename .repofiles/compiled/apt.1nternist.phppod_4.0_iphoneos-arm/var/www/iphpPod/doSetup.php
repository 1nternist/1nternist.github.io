<?php
session_start();
$mediaDir = trim($_POST['mediaDir']);
$doRecursive = strtolower(trim($_POST['doRecursive']))=='true' ? 'yes' : 'no';
$ffmpegPath = $_SESSION["ffmpegPath"];
$hasFFMPEG = ($ffmpegPath != "Not installed!" && isset($_SESSION['ffmpegPath'])) ? TRUE : FALSE;
$_SESSION["mediaDir"]=$mediaDir;
//------------------------------------------------------------------------------
// check if media directory exists
if (file_exists($mediaDir) && $mediaDir != '/') {
  if (file_exists("./iphpPod_media")) {
    unlink("./iphpPod_media");
  }
  $doneLink = @symlink($mediaDir,'./iphpPod_media');
  @chmod('./iphpPod_media',0755);
  if ($doneLink == FALSE) {
    echo "redir=firstUse.php?failedLink=1#_home\n";
    exit();
  }
} else {
  echo "redir=firstUse.php?failedLink=1#_home\n";
  exit();
}

//------------------------------------------------------------------------------
// check if thumbnail directory exists
if (!file_exists("./iphpPod_media/mp4_thumbs")) {
  @mkdir("./iphpPod_media/mp4_thumbs");
  @chmod("./iphpPod_media/mp4_thumbs",0755);
}
if (file_exists("./iphpPod_media/mp4_thumbs")) {
  $thumbsDir = TRUE;
  @chmod("./iphpPod_media/mp4_thumbs",0755);
} else {
  $thumbsDir = FALSE;
}

//------------------------------------------------------------------------------
// save prefs
$prefsFile = './ipp_prefs.bin';
$prefsArray = array('mediaDir'=>$mediaDir,
                    'doRecursive'=>$doRecursive,
                    'thumbsDir'=>$thumbsDir,
                    'hasFFMPEG'=>$hasFFMPEG,
                    'ffmpegPath'=>$ffmpegPath);
$prefsSaved = file_put_contents($prefsFile,serialize($prefsArray));
@chmod($prefsFile,0755);
if ($prefsSaved == FALSE) {
  // unable to write prefs file
  echo "redir=firstUse.php?failedPrefs=1\n";
  exit();
} else {
  // success !
  echo "redir=index.php?reload=1\n";
  exit();
}

?>