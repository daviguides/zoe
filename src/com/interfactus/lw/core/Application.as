package com.interfactus.lw.core
{
	import com.interfactus.lw.IResource;
	import com.interfactus.lw.containers.Container;
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class Application extends Container
	{
		public var resources:IResource;
		public static var application:Application;
		
		public static var lastTabIndex:uint = 0;
		
		public function Application()
		{
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		
		override protected function initialize(event:Event):void
		{
			Application.application = this;
			super.initialize(event);
		}
	}
}