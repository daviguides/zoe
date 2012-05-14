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
		
		protected function invalidateProperties():void{invalidatePropertiesFlag = true}
		protected function invalidateDisplayList():void{invalidateDisplayListFlag = true}
		
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
					updateDisplayList(_width, _height);
				}
			}
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
		private var invalidateDisplayListFlag:Boolean = false;
		
		private var initialized:Signal;
		private var created:Signal;
		private var _created:Boolean = false;
		
		protected var sizeChanged:Boolean = false;
		private var _width:Number = 0;
		override final public function set width(value:Number):void 
		{
			if(_width==value)
				return;
			_width = value;
			sizeChanged = true;
			invalidateDisplayList();
		}
		override final public function get width():Number
		{return _width;}
		
		private var _height:Number = 0;
		override final public function set height(value:Number):void
		{
			if(_height==value)
				return;
			_height = value;
			sizeChanged = true;
			invalidateDisplayList();
		}
		override final public function get height():Number
		{return _height;}
	}
}