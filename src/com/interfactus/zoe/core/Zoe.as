package com.interfactus.zoe.core
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	
	public class Zoe extends Sprite
	{
		protected function initialize():void
		{
			initialized.dispatch();
			stage.addEventListener(Event.ENTER_FRAME, validate);
		}
		
		protected function createChildren():void
		{created.dispatch();}
		
		protected function commitProperties():void{}
		
		protected function updateDisplayList(unscaledWidth:Number,
											 unscaledHeight:Number):void{}
		
		public function invalidateProperties():void{invalidatePropertiesFlag = true}
		public function invalidateSize():void{invalidateSizeFlag = true}
		public function invalidateDisplayList():void{invalidateDisplayListFlag = true}
		
		private function validate(event:Event):void
		{
			if(_created)
			{
				if (invalidatePropertiesFlag)
				{
					invalidatePropertiesFlag=false;
					commitProperties();
				}
				
				if (invalidateDisplayListFlag)
				{
					invalidateDisplayListFlag=false;
					validateDisplayList();
				}
			}
		}
		
		public function validateDisplayList():void
		{
			updateDisplayList(_width, _height);
		}
		
		public function Zoe()
		{
			super();
			super.tabEnabled = false;
			super.focusRect = new Object;
			
			var added:NativeSignal = new NativeSignal(this, Event.ADDED_TO_STAGE, Event);
			added.addOnce(function():void{initialize()});
			initialized = new Signal();
			initialized.addOnce(function():void{if(!_created)createChildren()});
			created = new Signal();
			created.addOnce(function():void{_created=true});
		}
		
		private var invalidatePropertiesFlag:Boolean = false;
		private var invalidateSizeFlag:Boolean = false;
		private var invalidateDisplayListFlag:Boolean = false;
		
		private var initialized:Signal;
		private var created:Signal;
		private var _created:Boolean = false;
		
		protected var _width:Number = 0;
		override public function set width(value:Number):void {
			_width = value;
			invalidateDisplayList();
		}
		
		override public function get width():Number
		{return _width;}
		
		protected var _height:Number = 0;
		override public function set height(value:Number):void {
			_height = value;
			invalidateDisplayList();
		}
		
		override public function get height():Number
		{return _height;}
	}
}