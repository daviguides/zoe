package com.interfactus.zoe.controls.media
{
	import com.interfactus.zoe.controls.media.videoClasses.VideoPlayer;
	
	public class VideoDisplay 
		extends VideoSimple 
		//extends VideoPlayer 
		implements IVideoDisplay
	{
		public function VideoDisplay()
		{
			//super(10, 10);
			
			visible = true;
			smoothing = true;
			autoRewind = true;
			bufferTime = 2;
			volume = 0.75;
			
			//addEventListener(Event.ADDED_TO_STAGE, createChildren);
		}
		
		private var _created:Boolean = false;
		
		/*protected function createChildren(event:Event):void
		{
			if(!_created){
				_created = true;
				setSize(stage.stageWidth, stage.stageHeight);
			}
		}*/
		
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
			//super.play();
			//return;
			var url1:String = null;
			if(_source!=url && url) {
				sourceChanged = true
				_source = url;
			}
			/*if(sourceChanged) {
				sourceChanged = false;
				url1 = _source
			}*/
			
			try
			{
				super.play();//url1);
			} 
			catch(error:Error) 
			{
				trace("ERROR:: não há source carregado");
			}
			
		}
		
		/*public var _source:String;
		public function set source(value:String):void
		{
			if(_source==value)
				return
			sourceChanged = true;
			_source = value;
		}
		private var sourceChanged:Boolean = false;*/
	}
}