package com.interfactus.zoe.controls.media
{
	
	import com.interfactus.zoe.containers.IClose;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import org.osflash.signals.Signal;
	
	public class AudioPlayer implements IStream
	{
		
		public var volumeChange:Signal = new Signal(Number);
		public var panningChange:Signal = new Signal(Number);
		public var playheadUpdate:Signal = new Signal(Number);
		
		private var _streamLoading:Signal = new Signal(Number, Number);
		public function get streamLoading():Signal
		{
			return _streamLoading;
		}

		public var playing:Signal = new Signal(Number);
		public var paused:Signal = new Signal(Number);
		public var unpaused:Signal = new Signal();
		public var stoped:Signal = new Signal(Number);
		public var ended:Signal = new Signal();
		
		//
		public var isPlaying:Boolean;
		public var playlist:Array;
		public var listSize:Number;
		public var currentUrl:String;
		public var playlistIndex:int = -1;
		public var sound:Sound;
		public var timerEnd:Number = 0;
		//
		private var soundChannel:SoundChannel;
		private var soundTrans:SoundTransform;
		private var progressInt:Number;
		private var streamer:Number;
		private var staticTimer:Number = -1;
		private var staticTimerInterval:Number;
		
		private var isSoundComplete:Boolean = false;
		
		public function onSoundComplete(event:Event):void
		{
			isSoundComplete = true;
		}
		
		public function play():void
			//url:String=null, size:Number=null ):void
		{
			if(!sourceChanged){
				unpause();
				return;
			} else {
				sourceChanged = false;
			}
			clearInterval(staticTimerInterval);
			if ( sound ) {
				soundChannel.stop();
			}
			
			isSoundComplete  = false;
			currentUrl = _source;
			listSize = 1;//size;
			sound = new Sound();
			
			sound.load(new URLRequest(_source));
			
			var soundTransform:SoundTransform = new SoundTransform();
			soundTransform.volume = currentVolume;
			soundChannel = sound.play(0, 0, soundTransform);
			//soundChannel.soundTransform.volume = currentVolume;
			soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			
			sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			sound.addEventListener(Event.COMPLETE, onLoadSong);
			sound.addEventListener(Event.ID3, onId3Info);
			
			if ( soundTrans ) {
				soundChannel.soundTransform = soundTrans;
			} else {
				soundTrans = soundChannel.soundTransform;
			}
			
			isPlaying = true;
			clearInterval(progressInt);
			clearInterval(staticTimerInterval);
			progressInt = setInterval(updateProgress, 30);
			playing.dispatch(0);
		}
		
		public function pause():void
		{
			if ( soundChannel ) {
				soundChannel.stop();
				paused.dispatch( soundChannel.position );
				isPlaying = false;
				clearInterval(staticTimerInterval);
			}
		}
		
		public function stop():void
		{
			if ( soundChannel ) {
				clearInterval(progressInt);
				soundChannel.stop();
				stoped.dispatch( soundChannel.position )
				isPlaying = false;
				if (timeStremer < 1) {
					sound.close();
				}
				sound = null;
				clearInterval(staticTimerInterval);
			}
		}
		
		private function unpause():void
		{
			if ( isPlaying ) {
				return;
			}
			if ( soundChannel.position < sound.length ) {
				soundChannel = sound.play(soundChannel.position);
				soundChannel.soundTransform = soundTrans;
			} else {
				soundChannel = sound.play();
			}
			unpaused.dispatch();
			playing.dispatch(0);
			isPlaying = true;
			clearInterval(staticTimerInterval);
			staticTimerInterval = setInterval(checkEnd, 1000);
		}
		
		public function seek( percent:Number ):void
		{
			soundChannel.stop();
			soundChannel = sound.play(( listSize * 1000) * percent);
			playing.dispatch( soundChannel.position );
			clearInterval(staticTimerInterval);
			staticTimerInterval = setInterval(checkEnd, 1000);
		}
		
		public function seekTag( seekBegin:Number, seekEnd:Number ):void
		{
			soundChannel.stop();
			soundChannel = sound.play(seekBegin * 1000);
			playing.dispatch( soundChannel.position );
			timerEnd = seekEnd;
			clearInterval(staticTimerInterval);
			staticTimerInterval = setInterval(checkEnd, 1000);
		}
		public function prev():void
		{
			progressInt = setInterval(updateProgress, 30);
			playlistIndex--;
			if ( playlistIndex < 0 ) {
				playlistIndex = playlist.length - 1;
			}
			clearInterval(staticTimerInterval);
		}
		public function next():void
		{
			progressInt = setInterval(updateProgress, 30);
			playlistIndex++;
			if ( playlistIndex == playlist.length ) {
				playlistIndex = 0;
			}
			clearInterval(staticTimerInterval);
		}
		
		public var _source:String;
		public function set source(value:String):void
		{
			if(_source==value)
				return
				sourceChanged = true;
			_source = value;
		}
		private var sourceChanged:Boolean = false;
		private var currentVolume:Number;
		
		public function get volume():Number
		{
			if ( ! soundTrans) {
				return 0;
			}
			return soundTrans.volume;
		}
		public function set_volume( n:Number ):void
		{
			if ( ! soundTrans ) {
				currentVolume = n;
				return;
			}
			currentVolume = n;
			soundTrans.volume = currentVolume;
			soundChannel.soundTransform = soundTrans;
			volumeChange.dispatch( soundTrans.volume );
		}
		public function get pan():Number
		{
			if (!soundTrans) {
				return 0;
			}
			return soundTrans.pan;
		}
		public function set_pan( n:Number ):void
		{
			if ( !soundTrans ) {
				return;
			}
			soundTrans.pan = n;
			soundChannel.soundTransform = soundTrans;
			panningChange.dispatch( soundTrans.pan );
		}
		
		public function get totalTime():Number
		{
			if(sound)
				return sound.length;
			else
				return 0;
		}
		
		public function get lenght():Number
		{
			return listSize * 1000;
		}
		public function get time():Number
		{
			return soundChannel.position;
		}
		public function get timePretty():String
		{
			var secs:Number = soundChannel.position / 1000;
			var mins:Number = Math.floor(secs / 60);
			secs = Math.floor(secs % 60);
			var zero:String = "";
			if (secs < 10) {
				zero = "0";
			}
			return mins + ":" + zero + secs;
		}
		public function get timePercent():Number
		{
			if ( ! ( listSize ) ) {
				return 0;
			}
			return soundChannel.position / listSize / 1000;
		}
		public function get timeStremer():Number
		{
			return streamer;
		}
		private function onLoadSong( event:Event ):void
		{
			staticTimerInterval = setInterval(checkEnd, 1000);
		}
		//
		private function onSongEnd( event:Event ):void
		{
			clearInterval(progressInt);
			if (playlist) {
				next();
			}
		}
		protected function onId3Info( event:Event ):void
		{
			//trace('#####:'+event.target.id3.toString());
			//dispatchEvent(new Event(Event.ID3, event.target.id3));
		}
		protected function updateProgress():void
		{
			playheadUpdate.dispatch( playheadTime );
			if ( timerEnd > 0 && soundChannel.position >= (timerEnd * 1000) ){
				timerEnd = 0;
				pause();
			}
		}
		//
		protected function checkEnd():void
		{
			if (isSoundComplete) {
				onSongEnd(new Event(Event.COMPLETE));
				clearInterval(staticTimerInterval);
				ended.dispatch();
			}
			staticTimer = soundChannel.position;
		}
		//
		protected function progressHandler( event:ProgressEvent ):void
		{
			streamer = event.bytesLoaded / event.bytesTotal;
			_streamLoading.dispatch( event.bytesLoaded,  event.bytesTotal);
		}
		
		public function get playheadTime():Number
		{
			return soundChannel.position/1000;
		}
	}
}