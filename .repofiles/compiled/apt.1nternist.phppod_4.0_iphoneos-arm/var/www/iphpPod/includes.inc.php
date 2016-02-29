<?php

/// includes.inc.php

//----------------------------------------------------------------------------------------------------
// initialize arrays
$audio_items = array();
$video_items = array();
$image_items = array();
$other_items = array();
$artists = array();

//----------------------------------------------------------------------------------------------------
$nativeBrowser = (strpos(strtoupper($_SERVER["HTTP_USER_AGENT"]),'IPOD')>0) ? TRUE : FALSE;

//----------------------------------------------------------------------------------------------------
require_once('getid3/getid3/getid3.php');

//----------------------------------------------------------------------------------------------------
function processMedia() {
  global $audio_items,$video_items,$image_items,$other_items;
  global $artists,$tracks,$images;
  
  foreach ($audio_items as $k=>$item) {
    $artist = checkEmpty($item['tags']['id3']['artist'][0]);
    $album  = checkEmpty($item['tags']['id3']['album'][0]);
    $title  = checkEmpty($item['tags']['id3']['title'][0]);
    $track  = $item['tags']['id3']['track'][0];
    $artist_prefix = strtoupper(substr(trim($item['tags']['id3']['artist'][0]),0,1));
    $artists[$artist_prefix][$artist][$album][$track][] = array('filepath'=>$item['filepath'],
                                                                'title'=>$title,
                                                                'duration'=>$item['tags']['duration'],
                                                                'bitrate'=>$item['tags']['bitrate']);
  }

  ksort($artists);
  foreach ($artists as $a=>$artistPrefix) {
    ksort($artistPrefix);
    foreach ($artistPrefix as $b=>$artist) {
      ksort($artist);
      foreach ($artist as $c=>$album) {
        ksort($album);
        foreach ($album as $d=>$track) {
          ksort($track);
          $tracks[$a][$b][$c]['count']++;
          $tracks[$a][$b]['count']++;
          $tracks[$a]['count']++;
          $tracks['count']++;
        }
      }
    }
  }

  if (count($image_items) > 0) {
    foreach ($image_items as $k=>$image) {
      $pathItems = explode('/',$image['filepath']);
      $filename = array_pop($pathItems);
      $imageCount = count($pathItems);
      $currentPath = '/';
      for ($i=2; $i<$imageCount; $i++) {
        $currentPath.= $pathItems[$i].'/';
      }
      if (strpos($currentPath,"'")==FALSE && strpos($currentPath,'"')==FALSE) {
        $images[$currentPath]['files'][] = $filename;
        $images[$currentPath]['count']++;
        $images['_count_']++;
      }
    }
  }
  $oCount = 0;
  foreach ($other_items as $t=>$other_type) {
    foreach ($other_type as $other_file) {
      $oCount++;
    }
  }
  $other_items['_count_'] = $oCount;
  
  return array('audio'=>$artists,
               'video'=>$video_items,
               'image'=>$images,
               'other'=>$other_items,
               'tracks'=>$tracks);
}

//----------------------------------------------------------------------------------------------------
function loadDB() {
  global $artists,$video_items,$images,$other_items,$tracks,$oCount,$vCount,$iCount;
  $mediaDB = unserialize(file_get_contents('./ippdb.bin'));
  
  $artists     = $mediaDB['audio'];
  $video_items = $mediaDB['video'];
  $images      = $mediaDB['image'];
  $other_items = $mediaDB['other'];
  $tracks      = $mediaDB['tracks'];

  $vCount = count($video_items);
  $_SESSION["imageList"]=serialize($images);
  $iCount = $images['_count_'];
  unset($images['_count_']);
  $oCount = $other_items['_count_'];
  unset($other_items['_count_']);
  
  return $mediaDB;
}

//----------------------------------------------------------------------------------------------------
function refreshDB() {
  global $recursive;
  directoryToArray('./iphpPod_media',$recursive);

  $mediaDB = processMedia();

  file_put_contents('./ippdb.bin',serialize($mediaDB));
  @chmod('./ippdb.bin',0777);
}

//----------------------------------------------------------------------------------------------------
function loadPrefs() {
  global $prefsArray, $recursive, $doThumbs, $mediaDir, $rsToggle, $hasFFMPEG, $ffmpegPath, $thumbCreate;
  if (!file_exists('./ipp_prefs.bin') || !file_exists('./iphpPod_media')) {
    header("Location: firstUse.php");
    exit();
  } else
  if (file_exists('./ipp_prefs.bin')) {
    $prefsArray=unserialize(file_get_contents('./ipp_prefs.bin'));
    $recursive = ($prefsArray['doRecursive']=='yes') ? TRUE : FALSE;
    $mediaDir = $prefsArray['mediaDir'];
    $doThumbs = $prefsArray['doThumbs'];
    $rsToggle = ($recursive==TRUE) ? "true" : "false";
    
    if (!isset($prefsArray['ffmpegPath']) || ($prefsArray['ffmpegPath']=="Not installed!" && !isset($_SESSION["ffmpegCheck"]))) {
      $ffmpegPath = @shell_exec('find / -name ffmpeg | head -1');
      $_SESSION["ffmpegCheck"]=TRUE;
      if (trim($ffmpegPath)>'') {
        $hasFFMPEG = TRUE;
        $prefsArray['ffmpegPath'] = trim($ffmpegPath);
        $prefsArray['hasFFMPEG']=TRUE;
        $_SESSION["ffmpegPath"]=$ffmpegPath;
        file_put_contents('./ipp_prefs.bin',serialize($prefsArray));
      } else {
        $ffmpegPath = "Not installed!";
        $_SESSION["ffmpegPath"]=$ffmpegPath;
        $hasFFMPEG = FALSE;
      }
    } else {
      $ffmpegPath = $prefsArray['ffmpegPath'];
      $hasFFMPEG = $prefsArray['hasFFMPEG'];
      $_SESSION["ffmpegPath"]=$ffmpegPath;
    }
    $thumbCreate = (file_exists("./iphpPod_media/mp4_thumbs") && $hasFFMPEG==TRUE) ? TRUE : FALSE;
  }
}

//----------------------------------------------------------------------------------------------------
function htmlHeader() {
  echo <<<HEAD
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>iphpPod</title>
<meta name="viewport" content="width=315; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;"/>
<link rel="apple-touch-icon" href="iphppod.png"/>
<style type="text/css" media="screen">
  @import "./iui/iui.css";
</style>
<style type="text/css" media="screen">
  LABEL.l1 { float:left;width:100px; }
  .table {font-size:10px; border:1px solid #888;width:310px;}
  .td1 {border:1px solid #888;background-color:#AAA;color:#FFF;font-weight:bold;}
  .td2 {border:1px solid #888;background-color:#FAFAFA;color:#000;}
  .embed {text-align:center; vertical-align:center;}
</style>
<script type="application/x-javascript" src="./iui/iui.js"></script>
<script src="./iui/AC_QuickTime.js" language="JavaScript" type="text/javascript"></script>
<script language="javascript">
  function addToPlaylist(title,filepath) {
    document.getElementById('plistWrapper').style.display='block';
  }
</script>
HEAD;
  echo pluginAlert();
  echo "</head>\n";
}

//----------------------------------------------------------------------------------------------------
function checkEmpty($var) {
  if (!empty($var)) {
    return trim($var);
  } else {
    return "Unknown";
  }
}

//----------------------------------------------------------------------------------------------------
function toggleDownloadPlugin($val=NULL) {
  if (file_exists('/System/Library/Internet Plug-Ins/File Download Plugin.webplugin/Info.plist')) {
    $plist = '/System/Library/Internet Plug-Ins/File Download Plugin.webplugin/Info.plist';
    $contents = file_get_contents($plist);
    if ($val==TRUE) {
      $newcontents = str_replace('<false/>','<true/>',$contents);
      echo "<SCRIPT LANGUAGE='javascript'>window.alert('Enabling Safari Download plug-in...');</SCRIPT>";
    } else
    if ($val==FALSE) {
      $newcontents = str_replace('<true/>','<false/>',$contents);
      echo "<SCRIPT LANGUAGE='javascript'>window.alert('Disabling Safari Download plug-in...');</SCRIPT>";
    }
    file_put_contents($plist,$newcontents);
  }
}

//----------------------------------------------------------------------------------------------------
function pluginAlert() {
  if (file_exists('/System/Library/Internet Plug-Ins/File Download Plugin.webplugin/Info.plist') &&
      $_SERVER['SERVER_ADDR'] == $_SERVER['SERVER_NAME'] &&
      $_SESSION["sdp_warn"]!=TRUE) {
    $_SESSION["sdp_warn"]=TRUE;
    return "<SCRIPT LANGUAGE='javascript'>window.alert('Please disable the Safari Download plugin in NetServices');</SCRIPT>";
  }
}

//----------------------------------------------------------------------------------------------------
function id3($filename){
  // Initialize getID3 engine
  $getID3 = new getID3;

  // Analyze file and store returned data in $ThisFileInfo
  $ThisFileInfo = $getID3->analyze($filename);

  // Optional: copies data from all subarrays of [tags] into [comments] so
  // metadata is all available in one location for all tag formats
  // metainformation is always available under [tags] even if this is not called
  getid3_lib::CopyTagsToComments($ThisFileInfo);

  /*$mimeSplit = explode('/',$ThisFileInfo['mime_type']);
  $mimeSplit[count($mimeSplit)-1] = 'x-'.$ThisFileInfo['fileformat'];
  $ThisFileInfo['mime_type']=implode('/',$mimeSplit);*/

  $myTags = array('fileformat'=>$ThisFileInfo['fileformat'],
                  'mimetype'=>$ThisFileInfo['mime_type'],
                  'duration'=>$ThisFileInfo['playtime_string'],
                  'bitrate'=>sprintf("%4d",($ThisFileInfo['bitrate']/1000)),
                  'id3'=>$ThisFileInfo['comments_html']);
  return $myTags;
}

//----------------------------------------------------------------------------------------------------
// function to show available disk space on System and Media partitions
function diskSpace() {
  $df = @exec('df > ./df.txt');
  if (@file_exists('./df.txt')) {
    $fh = fopen('./df.txt','r');
    while ($txt = fgets($fh,80)) {
      $items = sscanf($txt,"%s %s %s %s %s %s");
      if ($items[0]=='/dev/disk0s1') {
        $sysPercent = sprintf("%3.1f",($items[3]*100/$items[1]))."%";
        if (($items[3]*100/$items[1]) < 10) {
          $sysPercent = "<SPAN STYLE='color:red;'>".$sysPercent."</SPAN>";
        }
        $freeSystem = sprintf("%3.2f",(($items[3]*512)/(1024*1024)))."Mb / ".$sysPercent;
      } else
      if ($items[0]=='/dev/disk0s2') {
        $freeMedia = sprintf("%3.2f",(($items[3]*512)/(1024*1024)))."Mb / ".sprintf("%3.1f",($items[3]*100/$items[1]))."%";
      }
    }
    @unlink('./df.txt');
  }
  if (isset($freeSystem) && isset($freeMedia)) {
    return array('system'=>$freeSystem,'media'=>$freeMedia);
  } else {
    return FALSE;
  }
}

//----------------------------------------------------------------------------------------------------
// directory parse function
function directoryToArray($directory, $recursive,$debug=FALSE) {
  $video_ext = array('quicktime','mp4','mov','asf','3gpp','3gpp2','mpg','mpeg');
  $audio_ext = array('mp3','m4a','aac','wav');
  $image_ext = array('bmp','gif','jpg','png');
  $other_ext = array('doc','xls','pdf','htm','html');

  global $audio_items,$video_items,$image_items,$other_items;

  if ($handle = opendir($directory)) {
    while (false !== ($file = readdir($handle))) {
      if ($file != "." && $file != "..") {
        if (is_dir($directory. "/" . $file) && $recursive) {
          directoryToArray($directory. "/" . $file, $recursive);
        }
        else {
          $file = preg_replace("/\/\//si", "/" , $directory."/".$file);
          $ext = strtolower(end(explode('.',$file)));
          $filename = end(explode('/',$file));

          $encFilename = rawurlencode($filename);
          $path = explode('/',$file);
          if ($path[0]=='.') {unset($path[0]);}
          array_pop($path);
          array_push($path,$encFilename);
          $filepath = './'.implode('/',$path);

          if (!in_array($ext,$other_ext)) {
            $id3Data = id3($file);
            if ($debug==TRUE) {
              echo $file." ".$id3Data['fileformat']."<BR/>";
            }
            if (in_array(strtolower($id3Data['fileformat']),$audio_ext)) {
              $audio_items[] = array('filepath'=>$filepath,'filename'=>$encFilename,'tags'=>$id3Data) ;
            }
            else
            if (in_array(strtolower($id3Data['fileformat']),$video_ext)) {
              $video_items[] = array('filepath'=>$filepath,'filename'=>$encFilename,'tags'=>$id3Data) ;
            }
            else
            if (in_array(strtolower($id3Data['fileformat']),$image_ext) && strpos($file,'mp4_thumbs')==FALSE) {
              $image_items[] = array('filepath'=>$filepath,'filename'=>$encFilename) ;
            }
          }
          else
          if (in_array($ext,$other_ext)) {
            $other_items[$ext][] = array('filepath'=>$filepath,'filename'=>$encFilename,'filesize'=>filesize($file)) ;
          }
        } // else
      } // not . or ..
    }  // while
    closedir($handle);
  } // valid handle
}

//----------------------------------------------------------------------------------------------------
function htmlsafe($s=NULL) {
  return htmlentities(trim($s),ENT_QUOTES,'UTF-8');
}

//----------------------------------------------------------------------------------------------------
function setExpires($expires) {
 header(
   'Expires: '.gmdate('D, d M Y H:i:s', time()+$expires).'GMT');
}

function natksort($array) {
  // Like ksort but uses natural sort instead
  $keys = array_keys($array);
  natsort($keys);

  foreach ($keys as $k)
    $new_array[$k] = $array[$k];

  return $new_array;
}
?>