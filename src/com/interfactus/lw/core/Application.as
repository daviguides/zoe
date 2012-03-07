package com.interfactus.lw.core
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import com.interfactus.lw.containers.Container;
	
	public class Application extends Container
	{
		public static var lastTabIndex:uint = 0;
		
		public function Application()
		{
			super();
			parent.stage.scaleMode = StageScaleMode.NO_SCALE;
			parent.stage.align = StageAlign.TOP_LEFT;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
	}
}