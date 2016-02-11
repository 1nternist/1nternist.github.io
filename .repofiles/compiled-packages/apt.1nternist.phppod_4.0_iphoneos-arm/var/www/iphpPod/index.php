<?php

$version = 'v0.4';

session_start();
require_once('includes.inc.php');

loadPrefs();

if ($_GET["reload"]==1 || !file_exists('./ippdb.bin')) {
  refreshDB();
  header("Location: index.php"); // redirect so reload=1 url parameter discarded
} else
if (file_exists('./ippdb.bin')) {
  loadDB();
}

setExpires(300);

htmlHeader();
flush();

echo <<<BODY
<body>
  <div class="toolbar">
    <h1 id="pageTitle"></h1>
    <a id="backButton" class="button" href="#"></a>
    <a class='button' href='#searchForm'>Search</a>
  </div>
BODY;

// Home page
echo '<ul id="home" title="iphpPod" selected="true">';
if (($tracks['count']*1)>0) {
  echo '<li><a href="#artists">Music ('.($tracks['count']*1).')</a></li>';
} else {
  echo '<li>Music (0)</li>';
}

if ($vCount > 0) {
  echo '<li><a href="#video">Video ('.$vCount.')</a></li>';
} else{
  echo '<li>Video (0)</li>';
}

if ($iCount > 0) {
  echo '<li><a href="#image">Images ('.$iCount.')</a></li>';
} else {
 echo '<li>Images (0)</li>';
}

if ($oCount > 0) {
  echo  '<li><a href="#other">Other ('.$oCount.')</a></li>';
} else {
  echo '<li>Other (0)</li>';
}
echo "\n";
echo <<<HTML
        <li class='group'> </li>
        <li><a href="#prefs">Settings</a></li>
        <li><a href="#about">About</a></li>
        <li><a href='index.php?reload=1' target='_reload'>Refresh Media</a></li>
        <li class='group'> </li>
HTML;

//----------------------------------------------------------------------------------------------------
$spaceCheck = diskSpace();
if ($spaceCheck != FALSE) {
  echo "<li><i>Free Space</i><BR/>";
  echo "<LABEL CLASS='l1'>System</LABEL>".$spaceCheck['system']."<BR/>";
  echo "<LABEL CLASS='l1'>Media</LABEL>".$spaceCheck['media']."</LI>";
}
echo "</ul>\n";

//----------------------------------------------------------------------------------------------------
// list of artists
echo "<ul id='artists' title='Artists'>\n";
foreach ($artists as $a=>$artistPrefix) {
  $aOut = ($a=='' ? "No tags..." : $a);
  echo "<li class='group'>".htmlsafe($aOut)."</li>\n";
  foreach ($artistPrefix as $b=>$artist) {
    $artistid = md5($b);
    echo "<li class='audio'><a href='#artists".$artistid."'>".$b." (".$tracks[$a][$b]['count'].")</a></li>\n";
  }
}
echo "</ul>\n";

//----------------------------------------------------------------------------------------------------
// list of albums for artist
foreach ($artists as $a=>$artistPrefix) {
  foreach ($artistPrefix as $b=>$artist) {
    $artistid = md5($b);
    echo "<ul id='artists".$artistid."' title='".$b."'>\n";
    foreach ($artist as $c=>$album) {
      $albumid = md5($b.$c);
      echo "<li class='audio'><a href='#albums".$albumid."'>".$c." (".$tracks[$a][$b][$c]['count'].")</a></li>\n";
    }
    echo "</ul>\n";
  }
}

//----------------------------------------------------------------------------------------------------
// list of tracks for each album
// If >1 track, create 'Play All' button
foreach ($artists as $a=>$artistPrefix) {
  foreach ($artistPrefix as $b=>$artist) {
    foreach ($artist as $c=>$album) {
      echo "<ul id='albums".md5($b.$c)."' title='".$c."'>\n";
      if (($tracks[$a][$b][$c]['count']*1)>1) {
        echo "<li class='audio'>Play All <div style='position:relative;left:90px;top:-32px;margin-bottom:-24px;'>";
        foreach ($album as $d=>$subtrack) {
          foreach ($subtrack as $t=>$track) {
            $trackid = md5($track['filepath']);
            $path = $track['filepath'];

            if ($n==0) {
              echo "<EMBED AUTOPLAY='false' SRC=".'"'.$path.'"'." height='12' width='50' ";
            } else {
              echo 'QTNEXT'.$n.'="<' . end(explode('/',$path)).'> T<myself>" ';
            }
            $n++;
          }
        }
        echo ">\n</div></li>\n";
      }
      foreach ($album as $d=>$subtrack) {
        foreach ($subtrack as $t=>$track) {
          $trackid = md5($track['filepath']);
          echo "<li class='audio'><a href='#track_".trim($trackid)."'>".$track['title']."</a></li>\n";
        }
      }
      echo "</ul>\n";
    }
  }
}

//----------------------------------------------------------------------------------------------------
// play single track - show details: artist / album / title / bitrate / duration
foreach ($artists as $a=>$artistPrefix) {
  foreach ($artistPrefix as $b=>$artist) {
    foreach ($artist as $c=>$album) {
      foreach ($album as $d=>$subtrack) {
        foreach ($subtrack as $t=>$track) {
          $trackid = md5($track['filepath']);
          echo "<div id='track_".$trackid."' style='padding:5px 5px 5px 5px;' title='".htmlsafe($track['title'])."'>\n";

          $path = $track['filepath'];
          $mimeType = $track['tags']['mimetype'];

          echo "<TABLE CLASS='table' CELLSPACING=0 CELLPADDING=2>\n";

          echo "  <TR><TD CLASS='td1'>Artist</TD><TD CLASS='td2'>".$b."</TD>";
          echo "  <TD ROWSPAN=5 CLASS='embed'>";
          
          echo "  <OBJECT><embed src='{$path}' type='{$mimeType}' height='80' width='80'/></object>";
          echo "  </td></tr>\n";
          echo "  <TR><TD CLASS='td1'>Album</TD><TD CLASS='td2'>".$c."</TD></TR>\n";
          echo "  <TR><TD CLASS='td1'>Title</TD><TD CLASS='td2'>".$track['title']."</TD></TR>\n";
          echo "  <TR><TD CLASS='td1'>Length</TD><TD CLASS='td2'>".$track['duration']."</TD></TR>\n";
          echo "  <TR><TD CLASS='td1'>Bitrate (kbps)</TD><TD CLASS='td2'>".$track['bitrate']."</TD></TR>\n";
          if ($nativeBrowser==TRUE) {
            echo "  <TR><TD CLASS='td1'>Filename</TD><TD COLSPAN=2 CLASS='td2'>".rawurldecode($path)."</TD></TR>\n";
          } else {
            echo "  <TR><TD CLASS='td1'>Filename</TD><TD COLSPAN=2 CLASS='td2'><A HREF='{$path}'>".rawurldecode($path)."</a></TD></TR>\n";
          }
          echo "</TABLE>\n";
          echo "</div>";
        }
      }
    }
  }
}

//----------------------------------------------------------------------------------------------------
// videos
if ($vCount > 0) {
  $videos = array();
  echo "<ul id='video' title='Video'>\n";
  foreach ($video_items as $k=>$v) {
    $videos[strtoupper(trim(rawurldecode($v['filename'])))][strtoupper(trim(rawurldecode($v['filepath'])))] = $v;
  }
  ksort($videos);

  foreach ($videos as $name=>$filepath) {
    foreach ($filepath as $k=>$v) {
      $title = (isset($v['tags']['id3']['title'][0]) && strlen($v['tags']['id3']['title'][0]) > 0) ? $v['tags']['id3']['title'][0] : $v['filename'];
      echo "<li class='video'><a href='#video".md5($k)."'>".$title."</a></li>\n";
    }
  }
  echo "</ul>\n";

//----------------------------------------------------------------------------------------------------
// play video - show thumbnail or option to create one...
  foreach ($videos as $name=>$filepath) {
    foreach ($filepath as $k=>$v) {
      echo "\n<div style='padding:5px 5px 5px 5px;' id='video".md5($k)."' title='Play'>\n";
      $mimeType = $v['tags']['mimetype'];
      $img = './iphpPod_media/mp4_thumbs/'.md5(rawurldecode($v['filepath'])).'.jpg';
      if ($nativeBrowser == TRUE || $_GET["debug"]==1) {
        $relList = explode('/',$v['filepath']);
        array_shift($relList); // remove .
        array_shift($relList); // remove iphpPod_media
        $relPath = '../'.implode('/',$relList);
        echo "<object>\n<embed autoplay='false' href='{$relPath}' src='{$img}' type='{$mimeType}' target='myself' height='120' width='160'/>\n</object><br/>\n";
        if ($thumbCreate == TRUE && !file_exists($img)) {
          echo "<a style='float:left;position:relative;left:20px;' href='createThumb.php?file=".urlencode($v['filepath'])."' target='_thumb".md5($v['filepath'])."' class='button'>Create Thumbnail</a>\n";
        }
        echo "<p style='clear:left;margin-top:50px;'><h3 style='font-size:12px;'>Location:<BR/>".rawurldecode($v['filepath'])."</h3>\n";
      } else {
        echo "<object>\n<embed autoplay='true' src='{$v['filepath']}' type='{$mimeType}' controller='true' />\n</object><br/>\n";
        if ($thumbCreate == TRUE && !file_exists($img)) {
          echo "<a style='float:left;position:relative;left:20px;' href='createThumb.php?file=".urlencode($v['filepath'])."' target='_thumb".md5($v['filepath'])."' class='button'>Create Thumbnail</a>\n";
        }
        echo "\n<p><h3 style='font-size:12px;'>Location:<BR/><A HREF='".$v['filepath']."' target='_video'>".rawurldecode($v['filepath'])."</a></h3>\n";
      }
      echo "</DIV>\n";
    }
  }
} // if vCount > 0
//----------------------------------------------------------------------------------------------------
// images
if ($iCount > 0) {
  echo "<ul id='image' title='Images'>\n";
  foreach ($images as $k=>$image) {
    $path = explode('/',$k);
    array_pop($path);
    unset($path[0]);
    $path[1] = 'Media' ;
    $desc = implode(' &gt; ',$path);
    echo "<li><a href='showImages.php?path=".urlencode($k)."' target='_new'>".$desc." (".$image['count'].")</A></li>";
  }
  echo "</ul>\n";
}

//----------------------------------------------------------------------------------------------------
// other items, e.g. xls doc pdf...
echo "<ul id='other' title='Other'>\n";
if ($oCount > 0) {
  ksort($other_items);
  foreach ($other_items as $k=>$other_type) {
    ksort($other_type);
    echo "<li class='group'>".strtoupper($k)."</li>";
    foreach ($other_type as $q=>$other) {
      unset($fs);
      if ($other['filesize']>= (1024 * 1024)) {
        $fs = trim(sprintf("%8.1f",($other['filesize']/1024/1024)))."mb";
      } else
      if ($other['filesize']>= 1024) {
        $fs = trim(sprintf("%8.0f",($other['filesize']/1024)))."kb";
      } else {
        $fs = trim(sprintf("%8.0f",$other['filesize']))." bytes";
      }
      
      if (($other['filesize'] <= (10 * 1024 * 1024) && $nativeBrowser==TRUE) || $nativeBrowser==FALSE) {
        echo "<li><a href='".$other['filepath']."' target='_other'>".htmlentities(rawurldecode($other['filename']),ENT_QUOTES,'UTF-8')." <SPAN STYLE='font-size:12px;color:green;'>".$fs."</SPAN></A></li>\n";
      } else {
        echo "<li>".htmlentities(rawurldecode($other['filename']),ENT_QUOTES,'UTF-8')." <SPAN STYLE='font-size:12px;color:red;'>".$fs."</SPAN></li>\n";
      }
    }
  }
}
echo "</ul>\n";

include('settings.htm');
include('about.htm');
?>
<form id='searchForm' class='dialog' action='search.php' method='POST'>
  <fieldset>
    <h1>Search</h1>
    <label>Enter search term</label><br/>
      <a class="button leftButton" type="cancel">Cancel</a>
      <a class="button blueButton" type="submit">Search</a>
      <input type="text" class='fw' name="search"/>
  </fieldset>
</form>

</body>
</html>
