<?php

// search.php
include('includes.inc.php');

$searchTerm = strtoupper($_POST["search"]);
$media = loadDB();
$n = 0;
$results = array();

$audio_items = $artists;

unset($artists);

// audio
echo "<ul title='Search Results'>";
$rCount = 0;
$aCount = 0;
$vCount = 0;
foreach ($audio_items as $alpha=>$artists) {
  foreach ($artists as $artist=>$albums) {
    foreach ($albums as $album=>$tracks) {
      foreach ($tracks as $track=>$subtrack) {
        foreach ($subtrack as $audio_media) {
          $stringToSearch = $artist." ".$album." ".$audio_media['title'] . " " . end(explode('/',rawurldecode($audio_media['filepath'])));
          if (strpos(strtoupper($stringToSearch),$searchTerm)!==FALSE) {
            $aCount++;
            echo ($aCount==1) ? "<li class='group'>Music</li>" : '';
            echo "<li><a href='#track_".md5($audio_media['filepath'])."'>".$audio_media['title']."</a></li>";
            $rCount++;
          }
        }
      }
    }
  }
}
// video
foreach ($video_items as $k=>$v) {
  $videos[strtoupper(trim(rawurldecode($v['filename'])))][strtoupper(trim(rawurldecode($v['filepath'])))] = $v;
}
ksort($videos);

foreach ($videos as $name=>$filepath) {
  foreach ($filepath as $k=>$v) {
    $stringToSearch = $v['tags']['id3']['title'][0] ." ". $v['filename'];
    if (strpos(strtoupper($stringToSearch),$searchTerm)!==FALSE) {
      $vCount++;
      echo ($vCount==1) ? "<li class='group'>Video</li>" : '';
      $title = (isset($v['tags']['id3']['title'][0]) && strlen($v['tags']['id3']['title'][0]) > 0) ? $v['tags']['id3']['title'][0] : $v['filename'];
      echo "<li class='video'><a href='#video".md5($k)."'>".$title."</a></li>\n";
      $rCount++;
    }
  }
}

echo ($rCount==0) ? "<li>No results found.</li>" : '';
echo "</ul>";
?>