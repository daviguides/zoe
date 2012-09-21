package com.interfactus.zoe.controls.media
{
	
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import org.osflash.signals.Signal;

	public class VideoDisplay extends Video implements IStream, IVideoDisplay
	{
		public function VideoDisplay() {smoothing = true;}
		public function play(url:String=null):void
		{
			if(!_source && !url) {
				trace("ERROR:: não há source carregado");
				return;
			} else if (url) {
				source = url;
			}
			
			if(!sourceChanged){
				unpause();
				return;
			} else {
				sourceChanged = false;
			}
			
			currentUrl = _source;
			trace("Trying to load: "+ currentUrl);
			
			if (initConnection()) {
				setState(VideoState.LOADING);
				setState(VideoState.BUFFERING);
				netStream.play(_source);
			} else {
				setState(VideoState.CONNECTION_ERROR);
				return;
			}
			clearInterval(playheadUpdateInt);
			
			soundTransform = netStream.soundTransform;
			
			soundTransform.volume = currentVolume;
			netStream.soundTransform = soundTransform;
			isPlaying = true;
			playheadUpdateInt = setInterval(updateProgress, 30);
			playing.dispatch(0);
		}
		
		private function updateProgress():void
		{
			progressHandler()
			playheadUpdate.dispatch( playheadTime );
		}
		
		private function initConnection():Boolean
		{
			if (netConn && netStream) { 
				netConn.close();
				netStream.close();
			}
			
			if (!netConn) { 
				netConn = new NetConnection(); 
				netConn.objectEncoding = ObjectEncoding.AMF0;
			}
			
			var canConnect:Boolean = netConn.connect(null);
			//if (!canConnect) { return false; }
			
			netStream = new VideoPlayerNetStream(netConn, this);
			netStream.bufferTime = bufferTime;
			netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStreamStatus);
			
			attachNetStream(netStream);
			
			return true;
		}
		
		public function pause():void
		{
			if(!_source || !netStream) {
				trace("ERROR:: Não há video carregado para pausar");
				return;
			}
			
			netStream.pause();
			isPlaying = false;
			setState(VideoState.PAUSED);
		}
		
		private function unpause():void
		{
			if ( isPlaying ) {
				return;
			}
			if ( Math.round(netStream.time) < Math.round(streamLength) ) {
				netStream.resume();
				playing.dispatch(netStream.time);
			} else {
				clearInterval(playheadUpdateInt)
				netStream.seek(0);
				playheadUpdateInt = setInterval(updateProgress, 30);
				playing.dispatch(0);
			}
			unpaused.dispatch();
			setState(VideoState.PLAYING);
			isPlaying = true;
		}
		
		public function stop():void
		{
			isPlaying = false;
			ended.dispatch();
		}
		
		public function onMetaData(info:Object):void 
		{
			_metadata = info;
			
			streamLength = info.duration;
			
			/*if (isNaN(internalVideoWidth) || internalVideoWidth <= 0)
			internalVideoWidth = info.width;
			
			if (isNaN(internalVideoHeight) || internalVideoHeight <= 0)
			internalVideoHeight = info.height;
			*/
			metadataReceived.dispatch(info);
		}
		
		private function onNetStreamStatus(infoObject:NetStatusEvent):void {
			trace(infoObject.info.code);
			trace(infoObject.info.level);
			switch (infoObject.info.code) {
				case 'NetStream.Buffer.Empty':
					if(isPlaying)
						setState(VideoState.BUFFERING);
					break;
				case 'NetStream.Buffer.Full':
					setState(VideoState.BUFFER_FULL);
					netStream.resume();
					break;
				case 'NetStream.Buffer.Flush':
					setState(VideoState.BUFFER_FULL);
					break;
				case 'NetStream.Play.Start':
					if (!_autoPlay) {
						pause()
						ready.dispatch();
					} else {
						//setPlayheadUpdateInterval(_playheadUpdateInterval || 250);
						setState(VideoState.BUFFERING);
					}
					break;
				case 'NetStream.SeekStart.Notify':
				case 'NetStream.Seek.Notify':
					if(bufferAfterSeek) {
						setState(VideoState.BUFFERING);
						bufferAfterSeek = false;
					}
					
					if(isPlaying)
						netStream.resume();
					break;
				case 'NetStream.Seek.Complete':
				case 'NetStream.Unpause.Notify':
					if (!_autoPlay) {
						pause()
						ready.dispatch();
					} else {
						var cachedSeconds:Number = ((totalTime) * (bytesLoaded/bytesTotal));
						//setPlayheadUpdateInterval(_playheadUpdateInterval || 250);
						if (netStream.time > cachedSeconds || bufferAfterSeek){
							setState(VideoState.BUFFERING);
							bufferAfterSeek = false;
						} else {
							setState(VideoState.PLAYING);
						}
					}
					break;
				case 'NetStream.Pause.Notify':
					var a:int = 0;
					break;
				case 'NetStream.Play.StreamNotFound':
					setState(VideoState.CONNECTION_ERROR);
					//ticker.removeEventListener('tick', loadingDelegate);
					break;
				case 'NetStream.Seek.InvalidTime':
				case 'NetStream.Seek.Notify':
					notify.dispatch(infoObject);
					if (state == VideoState.STOPPED || _pauseAfterSeek) {
						netStream.pause();
					} else {
						//netStream.pause();
					}
					break;
				case 'NetStream.Play.Stop':
					isPlaying = false;
					setState(VideoState.STOPPED);
					if(!isPlaying)
						clearInterval(playheadUpdateInt);
					ended.dispatch();
					playheadUpdate.dispatch( 0 );
					break;
				default:
			}
		}
		
		private function setState(state:String):void {
			_state = state;
			stateChanged.dispatch(_state);
			
			switch (state) {
				case VideoState.CONNECTION_ERROR:
				case VideoState.DISCONNECTED:
					//removePlayheadUpdateInt();
					//ticker.removeEventListener('tick', loadingDelegate);
					break;
				default:
			}
		}
		
		public var playing:Signal = new Signal(Number);
		public var paused:Signal = new Signal(Number);
		public var unpaused:Signal = new Signal();
		public var stoped:Signal = new Signal(Number);
		public var stateChanged:Signal = new Signal(String);
		public var ended:Signal = new Signal();
		public var ready:Signal = new Signal();
		public var notify:Signal = new Signal(Object);
		public var metadataReceived:Signal = new Signal(Object);
		
		public var volumeChange:Signal = new Signal(Number);
		public var playheadUpdate:Signal = new Signal(Number);
		
		private var _streamLoading:Signal = new Signal(Number, Number);
		public function get streamLoading():Signal
		{
			return _streamLoading;
		}
		
		protected function progressHandler():void
		{
			streamer = this.bytesLoaded / this.bytesTotal;
			_streamLoading.dispatch( this.bytesLoaded,  this.bytesTotal);
		}
		
		//
		public var isPlaying:Boolean;
		public var playlist:Array;
		public var listSize:Number;
		public var currentUrl:String;
		public var playlistIndex:int = -1;
		private var soundTransform:SoundTransform;
		
		private var _autoPlay:Boolean=true;
		private var _totalTime:Number;
		private var _state:String;
		
		public function get state():String 
		{
			return _state;
		}
		private var _videoScaleMode:String;
		private var _videoAlign:String;
		private var netConn:NetConnection;
		private var netStream:VideoPlayerNetStream;
		private var _pauseAfterSeek:Boolean;
		
		//public function get state():String { return _state; }
		public function get bytesLoaded():Number { return (netStream)?netStream.bytesLoaded:0; }
		public function get bytesTotal():Number { return (netStream)?netStream.bytesTotal:0; }
		
		public function waitLoadBeforeSeek(toSeek:Number):void 
		{
			isPlaying = false;
			netStream.pause();
			setState(VideoState.BUFFERING);
			
			var cachedSeconds:Number = ((totalTime) * (bytesLoaded/bytesTotal));
			
			currentToSeek = toSeek;
			var checkInt:uint = setInterval(checkCachedSeconds, 50);
			
			function checkCachedSeconds():void
			{
				var cachedSeconds:Number = ((totalTime) * (bytesLoaded/bytesTotal));
				if(currentToSeek <= cachedSeconds) {
					clearInterval(checkInt);
					netStream.seek(currentToSeek);
					unpause();
				}
			}
		}
		
		public function seek(seekToSeconds:Number):void
		{
			setState(VideoState.SEEKING);
			var cachedSeconds:Number = ((totalTime) * (bytesLoaded/bytesTotal));
			
			if (seekToSeconds < 0) {
				seek(0);
				_pauseAfterSeek = true;
			} else  if (seekToSeconds > totalTime) {
				seek(totalTime);
				_pauseAfterSeek = true;
			} else  if (seekToSeconds > cachedSeconds-(bufferTime+5)) {
				bufferAfterSeek = true;
				netStream.seek(seekToSeconds);
			} else {
				if(!isPlaying) {
					clearInterval(playheadUpdateInt)
					playheadUpdateInt = setInterval(updateProgress, 30);
					netStream.seek(seekToSeconds);
					isPlaying = true;
					setState(VideoState.PLAYING);
				} else {
					netStream.seek(seekToSeconds);
				}
			}
		}
		
		public function set playheadTime(value:Number):void
		{
			seek(value);
		}
		
		public function get playheadTime():Number
		{
			return netStream.time;
		}
		
		public function get totalTime():Number
		{
			return streamLength;
		}
		
		public var _source:String;
		public function set source(value:String):void
		{
			if(_source==value)
				return
				sourceChanged = true;
			_source = value;
		}
		protected var sourceChanged:Boolean = false;
		private var currentVolume:Number=0.75;
		
		public function get volume():Number
		{
			if ( ! soundTransform) {
				return 0;
			}
			return soundTransform.volume;
		}
		public function set volume( n:Number ):void
		{
			if ( ! soundTransform ) {
				currentVolume = n;
				return;
			}
			currentVolume = n;
			soundTransform.volume = currentVolume;
			netStream.soundTransform = soundTransform;
			volumeChange.dispatch( soundTransform.volume );
		}
		
		public function get metadata():Object 
		{ 
			return _metadata; 
		}    
		
		//public var state:String;
		public var bufferTime:int=2;
		public var autoRewind:Boolean=true;
		private var _metadata:Object;
		
		private var playheadUpdateInt:Number;
		private var streamer:Number;
		private var streamLength:Number=0;
		private var bufferAfterSeek:Boolean;
		private var currentToSeek:Number;
	}
}

import com.interfactus.zoe.controls.media.VideoDisplay;

import flash.net.NetConnection;
import flash.net.NetStream;

dynamic class VideoPlayerNetStream extends NetStream
{
	public function VideoPlayerNetStream(connection:NetConnection,
										 videoPlayer:VideoDisplay)
	{
		super(connection);
		
		this.videoPlayer = videoPlayer;
	}
	
	private var videoPlayer:VideoDisplay;
	
	/**
	 *  @private
	 *  Called by the server.
	 */
	public function onMetaData(info:Object, ... rest):void
	{
		videoPlayer.onMetaData(info);
	}
	
	/**
	 *  @private
	 *  Called by the server.
	 */
	public function onCuePoint(info:Object, ... rest):void
	{
		//videoPlayer.onCuePoint(info);
	}
	
	/**
	 *  @private
	 */
	public function onPlayStatus(... rest):void
	{
	}   
}

dynamic class VideoScaleMode
{
	public static var MAINTAIN_ASPECT_RATIO:String = "maintainAspectRatio";
	public static var NO_SCALE:String = "noScale";
	public static var EXACT_FIT:String = "exactFit";
}

dynamic class VideoAlign
{
	public static var CENTER:String = "center";
	public static var TOP:String = "top";
	public static var LEFT:String= "left";
	public static var BOTTOM:String = "bottom";
	public static var RIGHT:String  = "right";
	public static var TOP_LEFT:String = "topLeft";
	public static var TOP_RIGHT:String = "topRight";
	public static var BOTTOM_LEFT:String = "bottomLeft";
	public static var BOTTOM_RIGHT:String  = "bottomRight";
}