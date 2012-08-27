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

	public class VideoSimple extends Video implements IStream
	{
		public function play(url:String = null, isLive:Boolean = false, totalTime:Number = -1):void
		{
			if(!sourceChanged){
				unpause();
				return;
			} else {
				sourceChanged = false;
			}
			
			if ( netStream ) {
				netStream.close();
			}
			
			currentUrl = _source;
			
			if (initConnection()) {
				netStream.play(_source);
				setState(VideoState.LOADING);
			} else {
				setState(VideoState.CONNECTION_ERROR);
			}
			
			soundTransform = netStream.soundTransform;
			isPlaying = true;
			clearInterval(playheadUpdateInt);
			playheadUpdateInt = setInterval(updateProgress, 30);
			playing.dispatch(0);
			
			function updateProgress():void
			{
				progressHandler()
				playheadUpdate.dispatch( playheadTime );
			}
		}
		
		private function initConnection():Boolean
		{
			if (netConn && netStream) { return true; }
			
			if (!netConn) { netConn = new NetConnection(); }
			
			//var canConnect:Boolean = 
			//netConn.connect(null);
			
			netConn = new NetConnection();
			netConn.objectEncoding = ObjectEncoding.AMF0;
			netConn.connect(null);
			
			//if (!canConnect) { return false; }
			
			if (!netStream) {
				netStream = new VideoPlayerNetStream(netConn, this);
				netStream.bufferTime = 2;
				netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStreamStatus);
			}
			
			attachNetStream(netStream);
			
			return true;
		}
		
		public function pause():void
		{
			netStream.pause();
			isPlaying = false;
			setState(VideoState.PAUSED);
		}
		
		private function unpause():void
		{
			if ( isPlaying ) {
				return;
			}
			if ( netStream.time < streamLength ) {
				netStream.resume();
			} else {
				
			}
			unpaused.dispatch();
			playing.dispatch(0);
			setState(VideoState.PLAYING);
			isPlaying = true;
		}
		
		public function stop():void
		{
			ended.dispatch();
		}
		
		public function onMetaData(info:Object):void 
		{
			if (_metadata != null)
				return;
			
			_metadata = info;
			
			if (isNaN(streamLength) || streamLength <= 0)
				streamLength = info.duration;
			
			/*if (isNaN(internalVideoWidth) || internalVideoWidth <= 0)
			internalVideoWidth = info.width;
			
			if (isNaN(internalVideoHeight) || internalVideoHeight <= 0)
			internalVideoHeight = info.height;
			*/
			metadataReceived.dispatch(info);
		}
		
		private function onNetStreamStatus(infoObject:NetStatusEvent):void {
			switch (infoObject.info.code) {
				case 'NetStream.Buffer.Empty':
					setState(VideoState.BUFFERING);
					break;
				case 'NetStream.Buffer.Full':
					setState(VideoState.PLAYING);
					netStream.resume();
					break;
				case 'NetStream.Buffer.Flush':
					break;
				case 'NetStream.Play.Start':
					if (!_autoPlay) {
						pause()
						ready.dispatch();
					} else {
						//setPlayheadUpdateInterval(_playheadUpdateInterval || 250);
						setState(VideoState.PLAYING);
					}
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
					setState(VideoState.STOPPED);
					clearInterval(playheadUpdateInt);
					ended.dispatch();
					stop();
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
		public function get bytesLoaded():Number { return netStream.bytesLoaded; }
		public function get bytesTotal():Number { return netStream.bytesTotal; }
		
		public function seekPercent(value:Number):void {
			if (value < 0 || value > 100 || totalTime == undefined || totalTime <= 0) { return; }
			seek(totalTime * value / 100);
		}
		
		public function seek(seekToSeconds:Number):void {
			setState(VideoState.SEEKING);
			
			if (seekToSeconds < 0) {
				seek(0);
				_pauseAfterSeek = true;
			} else  if (seekToSeconds > totalTime) {
				seek(totalTime);
				_pauseAfterSeek = true;
			} else {
				netStream.seek(seekToSeconds);
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
		private var currentVolume:Number;
		
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
		public var bufferTime:int;
		public var autoRewind:Boolean;
		private var _metadata:Object;
		
		private var playheadUpdateInt:Number;
		private var streamer:Number;
		private var streamLength:Number;
	}
}

import com.interfactus.zoe.controls.media.VideoSimple;

import flash.net.NetConnection;
import flash.net.NetStream;

dynamic class VideoPlayerNetStream extends NetStream
{
	public function VideoPlayerNetStream(connection:NetConnection,
										 videoPlayer:VideoSimple)
	{
		super(connection);
		
		this.videoPlayer = videoPlayer;
	}
	
	private var videoPlayer:VideoSimple;
	
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