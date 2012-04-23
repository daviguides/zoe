package com.interfactus.lw.controls
{
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import mx.controls.videoClasses.VideoPlayer;
	import mx.messaging.SubscriptionInfo;
	
	public class VideoDisplay extends VideoPlayer
	{
		public function VideoDisplay()
		{
			super(10, 10);
			
			visible = true;
			smoothing = true;
			autoRewind = true;
			bufferTime = 5;
			volume = 0.75;
			
			addEventListener(Event.ADDED_TO_STAGE, createChildren);
		}
		
		private var _created:Boolean = false;
		
		protected function createChildren(event:Event):void
		{
			if(!_created){
				_created = true;
				setSize(stage.stageWidth, stage.stageHeight);
			}
		}
		
		private function onAStatus(event:AsyncErrorEvent):void
		{
			trace(event);
		}
		private function onIOStatus(event:IOErrorEvent):void
		{
			trace(event);
		}
		
		public var playing:Boolean = false;
		
		override public function pause():void
		{
			super.pause();
			playing = false;
		}
		
		override public function play(url:String = null, isLive:Boolean = false, totalTime:Number = -1):void
		{
			var s:String;
			if(sourceChanged)
			{
				sourceChanged = false;
				s = _source;
			} else {
				s = null;
			}
			playing = true;
			super.play(s);
		}
		
		public var _source:String;
		public function set source(value:String):void
		{
			sourceChanged = true;
			_source = value;
		}
		private var sourceChanged:Boolean = false;
	}
}