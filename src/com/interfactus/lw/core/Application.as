package com.interfactus.lw.core
{
	import com.interfactus.lw.containers.Container;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class Application extends Container
	{
		public static var application:Application;
		
		public static var lastTabIndex:uint = 0;
		
		public function Application()
		{
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			Application.application = this;
			
			this.contentPane.visible = false;
		}
		
		private function resizeHandler(event:Event):void
		{
			this.width = root.stage.stageWidth;
			this.height = root.stage.stageHeight;
		}
		
		override protected function initialize():void
		{
			stage.addEventListener(Event.RESIZE, resizeHandler);
			
			this.width = root.stage.stageWidth;
			this.height = root.stage.stageHeight;
			
			loading = new resources.BufferingIcon();
			loading.width = 40;
			loading.height = 40;
			loading.alpha = 1;
			loading.x = this.width/2;
			loading.y = this.height/2;
			stage.addChild(loading);
			loading.mouseEnabled = false;
			super.initialize();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			loading.visible = false;
			this.contentPane.visible = true;
		}
		
		public var loading:Sprite;
	}
}