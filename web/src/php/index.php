<?php
    require_once("./audio.php");
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Toggle – Lovers Unite!</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="css/style.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <div class="logo">
            <img src="img/logo.png">
        </div>
        <h1>Toggle</h1>
        <h2>Lovers Unite!</h2>
        <div class="jw-audio-playlist" data-playlist-id="{data.uid}">
            <div class="bodytext">
                <p>A music collection made by spider with gfx by Shine.</p>
                <p>A birthday present to one of our favorite SID musicians: TOGGLE \o/</p>
                <p><a href="https://trans.jansalleine.com/recs/sid/tgl/Toggle_-_Lovers_Unite_(FLAC).zip">Download the Album as FLAC here!</a></p>
                <p>Or watch <a href="https://www.youtube.com/watch?v=_iXXLFXJ5VU" target="_blank">the recording on YouTube</a>.</p>
                <p>Or download the <a href="toggle_lovers_unite_myd.d64">D64 C64 image</a>.</p>
            </div>
            <div class="audio-playlist">
                <div class="audio-playlist-controls">
                    <button class="play"><span>Play</span></button>
                    <button class="pause"><span>Pause</span></button>
                    <button class="stop"><span>Stop</span></button>
                    <button class="previous"><span>Previous</span></button>
                    <button class="next"><span>Next</span></button>
                    <button class="repeat"><span>Repeat</span></button>
                </div>
                <div class="current-track-info">
                    <div class="title"></div>
                    <div class="playtime"><span class="current">00:00</span>/<span class="total">00:00</span></div>
                </div>
                <div class="audio-playlist-items">
                    <?php
                        $i = 1;

                        foreach ($audioFiles as $audioFile)
                        { ?>
                            <div class="audio-playlist-item" data-item-index="<?php echo $i; ?>">
                                <div class="tag-info">
                                    <span class="title"><?php echo $audioFile['title']; ?></span>
                                    <span class="artist">Toggle</span>
                                    <span class="playtime"><?php echo $audioFile['playtime']; ?></span>
                                </div>
                                <audio>
                                    <source src="<?php echo $audioFile['link']; ?>">
                                </audio>
                            </div>
                        <?php
                            $i++;
                        }
                    ?>
                </div>
            </div>
        </div>
    </div>
    <script src="js/app.min.js"></script>
</body>
</html>
