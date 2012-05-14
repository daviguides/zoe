package com.interfactus.zoe.controls
{
	import com.interfactus.zoe.controls.videoClasses.VideoPlayer;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	public class VideoDisplay extends VideoPlayer
	{
		public function VideoDisplay()
		{
			super(10, 10);
			
			visible = true;
			smoothing = true;
			autoRewind = true;
			bufferTime = 2;
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
		
		override public function pause():void
		{
			try
			{
				super.pause();
			} 
			catch(error:Error) 
			{
				trace("ERROR:: Não há video carregado para pausar");
			}
		}
		
		override public function play(url:String = null, isLive:Boolean = false, totalTime:Number = -1):void
		{
			var url1:String = null;
			if(_source!=url && url) {
				sourceChanged = true
				_source = url;
			}
			if(sourceChanged) {
				sourceChanged = false;
				url1 = _source
			}
			
			try
			{
				super.play(url1);
			} 
			catch(error:Error) 
			{
				trace("ERROR:: não há source carregado");
			}
			
		}
		
		public var _source:String;
		public function set source(value:String):void
		{
			if(sourceChanged)
				return
			sourceChanged = true;
			_source = value;
		}
		private var sourceChanged:Boolean = false;
	}
}