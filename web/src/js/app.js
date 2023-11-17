"use strict";

(function(w, d)
{
    function button( name, callback, elem )
    {
        this.callback = callback;
        this.name = name;

        this.init = function()
        {
            elem.querySelector(".audio-playlist-controls button." + this.name)
                .addEventListener("click", this.callback);
        }

        this.init();
    }

    function findParentNodeByClassName( elem, className )
    {
        if ( typeof(elem.parentNode) === 'undefined' )
        {
            console.error( "No parentNode found.", elem );
            return false;
        }
        return elem.parentNode.classList.toString().indexOf(className) >= 0 ?
            elem.parentNode :
            findParentNodeByClassName( elem.parentNode, className );
    }

    function formatSecondsAsTime(secs)
    {
        var hr  = Math.floor(secs / 3600),
            min = Math.floor((secs - (hr * 3600))/60),
            sec = Math.floor(secs - (hr * 3600) -  (min * 60));

        if (min < 10)
        {
            min = "0" + min;
        }
        if (sec < 10)
        {
            sec  = "0" + sec;
        }
        return min + ':' + sec;
    }

    function playlist( elem )
    {
        this.audioElems;
        this.buttons = [];
        this.currentTrack;
        this.elem = elem;
        this.id;
        this.isPaused = 0;
        this.isPlaying = 0;
        this.isRepeat = 0;
        this.nextTrack;
        this.playButton;
        this.playlistLength;
        this.previousTrack;

        this.initCurrentDisplay = function()
        {
            this.currentTitleElem =
                elem.querySelector(".current-track-info .title");
            this.currentTimeTotalElem =
                elem.querySelector(".current-track-info .playtime .total");
            this.currentTimeElem =
                elem.querySelector(".current-track-info .playtime .current");
        }

        this.init = function( elem )
        {
            this.id = elem.dataset.playlistId;
            this.audioElems = elem.querySelectorAll("audio");
            if ( !this.audioElems.length )
            {
                return;
            }
            this.playlistLength = this.audioElems.length;
            this.resetPlaylist();

            var buttons = [
                {'name': 'play', 'callback': this.playAudio.bind(this)},
                {'name': 'pause', 'callback': this.pauseAudio.bind(this)},
                {'name': 'stop', 'callback': this.stopAudio.bind(this)},
                {'name': 'next', 'callback': this.playNext.bind(this)},
                {'name': 'previous', 'callback': this.playPrevious.bind(this)},
                {'name': 'repeat', 'callback': this.toggleRepeat.bind(this)}
            ];

            buttons.forEach( function(elem, index)
            {
                this.buttons.push(
                    new button(elem['name'], elem['callback'], this.elem)
                );
            }, this);

            var items = elem.querySelectorAll(".audio-playlist-item");

            items.forEach( function(elem, index)
            {
                elem.addEventListener("click", this.selectManual.bind(this));
            }, this);

            this.initCurrentDisplay();
        }

        this.pauseAudio = function()
        {
            if (this.isPlaying)
            {
                this.isPlaying = 0;
                this.isPaused = 1;
                this.audioElems[this.currentTrack-1].pause();
                elem.querySelector(".audio-playlist-controls button.pause")
                    .classList.add("active");
                elem.querySelector(".audio-playlist-controls button.play")
                    .classList.remove("active");
            }
            else if (this.isPaused)
            {
                this.isPlaying = 0;
                this.isPaused = 1;
                this.audioElems[this.currentTrack-1].pause();
                this.playAudio();
            }
        }

        this.playAudio = function()
        {
            if (!this.isPlaying || this.isPaused)
            {
                this.isPlaying = 1;
                this.audioElems[this.currentTrack-1].play();
                if (!this.isPaused)
                {
                    this.audioElems[this.currentTrack-1]
                        .parentNode.classList.toggle("active");
                }
                this.isPaused = 0;
                this.updateCurrentDisplay();
                this.audioElems[this.currentTrack-1].addEventListener(
                    "timeupdate", this.updateCurrentTimeDisplay.bind(this)
                );
                this.audioElems[this.currentTrack-1].addEventListener(
                    "ended", this.updateOnAudioEnded.bind(this)
                );
                elem.querySelector(".audio-playlist-controls button.play")
                    .classList.add("active");
                elem.querySelector(".audio-playlist-controls button.pause")
                    .classList.remove("active");
            }
        }

        this.playNext = function()
        {
            if (this.isPlaying || this.isPaused && this.nextTrack)
            {
                this.isPlaying = 0;
                this.isPaused = 0;
                this.audioElems[this.currentTrack-1].pause();
                this.audioElems[this.currentTrack-1].currentTime = 0;
                this.audioElems[this.currentTrack-1].removeEventListener(
                    "timeupdate", this.updateCurrentTimeDisplay.bind(this)
                );
                this.audioElems[this.currentTrack-1].removeEventListener(
                    "ended", this.updateOnAudioEnded.bind(this)
                );
                this.currentTrack = this.nextTrack;
                this.setNextTrack();
                this.setPreviousTrack();
                this.audioElems[this.previousTrack-1]
                    .parentNode.classList.remove("active");
                this.playAudio();
            }
        }

        this.playPrevious = function()
        {
            if (this.isPlaying || this.isPaused && this.previousTrack)
            {
                this.isPlaying = 0;
                this.isPaused = 0;
                this.audioElems[this.currentTrack-1].pause();
                this.audioElems[this.currentTrack-1].currentTime = 0;
                this.audioElems[this.currentTrack-1].removeEventListener(
                    "timeupdate", this.updateCurrentTimeDisplay.bind(this)
                );
                this.audioElems[this.currentTrack-1].removeEventListener(
                    "ended", this.updateOnAudioEnded.bind(this)
                );
                this.currentTrack = this.previousTrack;
                this.setNextTrack();
                this.setPreviousTrack();
                this.audioElems[this.nextTrack-1]
                    .parentNode.classList.remove("active");
                this.playAudio();
            }
        }

        this.resetPlaylist = function()
        {
            this.currentTrack = 1;
            this.setNextTrack();
            this.setPreviousTrack();
        }

        this.selectManual = function(e)
        {
            if (this.isPlaying)
            {
                this.pauseAudio();
            }
            if (this.isPaused)
            {
                this.isPaused = 0;
                this.audioElems[this.currentTrack-1].currentTime = 0;
                this.audioElems[this.currentTrack-1]
                    .parentNode.classList.remove("active");
            }

            this.currentTrack = parseInt(
                findParentNodeByClassName(
                    e.target, "audio-playlist-item"
                ).dataset.itemIndex
            );

            this.setNextTrack();
            this.setPreviousTrack();

            this.playAudio();
        }

        this.setNextTrack = function()
        {
            if ( this.playlistLength > this.currentTrack )
            {
                this.nextTrack = this.currentTrack + 1;
            }
            else
            {
                this.nextTrack = 0;
            }
        }

        this.setPreviousTrack = function ()
        {
            this.previousTrack = this.currentTrack - 1;
        }

        this.stopAudio = function()
        {
            if (this.isPlaying || this.isPaused)
            {
                this.isPlaying = 0;
                this.isPaused = 0;
                this.audioElems[this.currentTrack-1].pause();
                this.audioElems[this.currentTrack-1].currentTime = 0;
                this.audioElems[this.currentTrack-1].removeEventListener(
                    "timeupdate", this.updateCurrentTimeDisplay.bind(this)
                );
                this.audioElems[this.currentTrack-1].removeEventListener(
                    "ended", this.updateOnAudioEnded.bind(this)
                );
                this.audioElems[this.currentTrack-1]
                    .parentNode.classList.toggle("active");
                this.updateCurrentDisplay();
                this.resetPlaylist();
                elem.querySelector(".audio-playlist-controls button.play")
                    .classList.remove("active");
                elem.querySelector(".audio-playlist-controls button.pause")
                    .classList.remove("active");
            }
        }

        this.toggleRepeat = function()
        {
            this.isRepeat = this.isRepeat ^ 1;
            elem.querySelector(".audio-playlist-controls button.repeat")
                .classList.toggle("active");
        }

        this.updateCurrentDisplay = function()
        {
            if (this.isPlaying)
            {
                this.currentTitle =
                    this.audioElems[this.currentTrack-1]
                        .parentNode.querySelector(".tag-info .title")
                        .innerText;
                this.currentTimeTotal =
                    this.audioElems[this.currentTrack-1]
                        .parentNode.querySelector(".tag-info .playtime")
                        .innerText;
                if (this.currentTimeTotal.length == 2)
                {
                    this.currentTimeTotal = "00:" + this.currentTimeTotal;
                }
                if (this.currentTimeTotal.length == 4)
                {
                    this.currentTimeTotal = "0" + this.currentTimeTotal;
                }
            }
            else
            {
                this.currentTitle = '';
                this.currentTimeTotal = '00:00';
            }
            this.currentTitleElem.innerText = this.currentTitle;
            this.currentTimeTotalElem.innerText = this.currentTimeTotal;
        }

        this.updateCurrentTimeDisplay = function()
        {
            this.currentTimeElem.innerText =
                formatSecondsAsTime(
                    this.audioElems[this.currentTrack-1].currentTime
                );
        }

        this.updateOnAudioEnded = function()
        {
            if (this.nextTrack)
            {
                this.playNext();
            }
            else
            {
                this.stopAudio();
                if (this.isRepeat)
                {
                    this.playAudio();
                }
            }
        }

        this.init( elem );
    }

    var audioPlaylistElems = d.querySelectorAll(".jw-audio-playlist"),
        audioPlaylists = [];
    audioPlaylistElems.forEach( function(elem, index)
    {
        audioPlaylists.push( new playlist(elem) );
    });

    return audioPlaylists;
})(window, document);

