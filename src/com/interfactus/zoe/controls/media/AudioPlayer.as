package com.interfactus.zoe.controls.media
{
	
	import flash.events.Event;
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
		public function play():void
		{
			if(!sourceChanged){
				unpause();
				return;
			}
			listSize = 1;
			sourceChanged = false;
			
			load();
			_play();
		}
		
		private function load():void
		{
			sound = new Sound();
			sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			function progressHandler( event:ProgressEvent ):void
			{
				streamer = event.bytesLoaded / event.bytesTotal;
				_streamLoading.dispatch( event.bytesLoaded,  event.bytesTotal);
			}
			
			sound.addEventListener(Event.COMPLETE, function( event:Event ):void{});
			sound.addEventListener(Event.ID3, onId3Info);
			function onId3Info( event:Event ):void
			{/*trace('#####:'+event.target.id3.toString());*/}
			
			sound.load(new URLRequest(_source));
			gotLoad = true;
			
		}
		
		private function _play(position:Number=0):void
		{
			if ( soundChannel )
				soundChannel.stop();
			
			var soundTransform:SoundTransform = new SoundTransform();
			soundTransform.volume = currentVolume;
			soundChannel = sound.play(position, 0, soundTransform);
			
			if ( soundTrans )
				soundChannel.soundTransform = soundTrans;
			else
				soundTrans = soundChannel.soundTransform;
			
			soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			playing.dispatch(position);
			isSoundComplete = false;
			isPlaying = true;
			
			clearInterval(progressInt);
			progressInt = setInterval(updateProgress, 30);
		}
		
		private function unpause():void
		{
			if (isPlaying)
				return;

			if ( soundChannel.position < sound.length && !isSoundComplete)
				_play(soundChannel.position);
			else
				_play();
			
			unpaused.dispatch();
		}
		
		public function pause():void
		{
			if ( soundChannel ) {
				soundChannel.stop();
				paused.dispatch( soundChannel.position );
				isPlaying = false;
			}
		}
		
		public function seek( percent:Number ):void
		{
			var toSeek:Number = ( listSize * 1000) * percent;
			if(!gotLoad)
				load();
			
			if(toSeek < (totalTime * streamer))
				_play(toSeek);
			else
				waitLoadBeforeSeek(toSeek);
			
		}
		
		private function waitLoadBeforeSeek(toSeek:Number)
		{
			currentToSeek = toSeek;
			var checkInt:uint = setInterval(checkCachedSeconds, 50);
			
			function checkCachedSeconds():void
			{
				var cachedSeconds:Number = (totalTime * streamer);
				if(currentToSeek <= cachedSeconds) {
					clearInterval(checkInt);
					_play(currentToSeek);
				}
			}
		}
		
		public function seekTag( seekBegin:Number, seekEnd:Number ):void
		{
			timerEnd = seekEnd;
			seek(seekBegin * 1000);
		}
		
		protected function updateProgress():void
		{
			if(isSoundComplete)
				playheadUpdate.dispatch( 0 );
			else
				playheadUpdate.dispatch( playheadTime );
			//to seekTag
			if ( timerEnd > 0 && soundChannel.position >= (timerEnd * 1000) ){
				timerEnd = 0;
				pause();
			}
		}
		
		public function onSoundComplete(event:Event):void
		{
			isSoundComplete = true;
			ended.dispatch();
			if (playlist) {
				next();
			} else {
				isPlaying = false;
			}
		}
		
		public function prev():void
		{
			progressInt = setInterval(updateProgress, 30);
			playlistIndex--;
			if ( playlistIndex < 0 ) {
				playlistIndex = playlist.length - 1;
			}
		}
		public function next():void
		{
			progressInt = setInterval(updateProgress, 30);
			playlistIndex++;
			if ( playlistIndex == playlist.length ) {
				playlistIndex = 0;
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
			}
		}
		
		public var volumeChange:Signal = new Signal(Number);
		public var panningChange:Signal = new Signal(Number);
		public var playheadUpdate:Signal = new Signal(Number);
		
		public var playing:Signal = new Signal(Number);
		public var paused:Signal = new Signal(Number);
		public var unpaused:Signal = new Signal();
		public var stoped:Signal = new Signal(Number);
		public var ended:Signal = new Signal();
		
		//
		public var isPlaying:Boolean;
		public var gotLoad:Boolean;
		public var playlist:Array;
		public var listSize:Number=1;
		public var playlistIndex:int = -1;
		public var sound:Sound;
		public var timerEnd:Number = 0;
		//
		private var soundChannel:SoundChannel;
		private var soundTrans:SoundTransform;
		private var progressInt:Number;
		private var streamer:Number;
		
		private var isSoundComplete:Boolean;
		
		private var _streamLoading:Signal = new Signal(Number, Number);
		public function get streamLoading():Signal
		{
			return _streamLoading;
		}
		
		public function get playheadTime():Number
		{
			return soundChannel.position/1000;
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
		private var currentToSeek:Number;
		
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
	}
}