package com.interfactus.lw.core
{
	import com.interfactus.lw.effects.Tween;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	
	public class UIComponent extends Sprite
	{
		protected function initialize():void
		{
			if(!(this is Application))
				resources = Application.application.resources;
			
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
		
		public function UIComponent()
		{
			super();
			super.tabEnabled = false;
			super.focusRect = new Object;
			
			var added:NativeSignal = new NativeSignal(this, Event.ADDED_TO_STAGE, Event);
			added.addOnce(function():void{initialize()});
			initialized.addOnce(function():void{createChildren()});
			created.addOnce(function():void{_created=true});
		}

		public var showHideEffects:Boolean = true;
		
		private var _visible:Boolean = true;
		
		override public function get visible():Boolean
		{return _visible;}
		
		override public function set visible(value:Boolean):void
		{
			_visible = value;
			if(showHideEffects && initialized){
				if(_visible){
					Tween.toVisible(this, visibleEffectCompleteHandler); 
					mouseEnabled = true;
				} else {
					Tween.toInvisible(this, visibleEffectCompleteHandler); 
					mouseEnabled = false;
				}
			} else {
				super.visible = value;
			}
		}
		
		public function setVisible(value:Boolean):void 
		{
			_visible = value;
			super.visible = value;
		}
		
		private function visibleEffectCompleteHandler():void
		{super.visible = _visible;}
		
		private var _width:Number = 200;
		private var _height:Number = 30;
		
		override public function set width(value:Number):void {
			_width = value;
			invalidateDisplayList();
		}
		
		override public function get width():Number
		{return _width;}
		
		override public function set height(value:Number):void {
			_height = value;
			invalidateDisplayList();
		}
		
		override public function get height():Number
		{return _height;}
		
		private var invalidatePropertiesFlag:Boolean = false;
		private var invalidateSizeFlag:Boolean = false;
		private var invalidateDisplayListFlag:Boolean = false;
		
		protected var resources:Object;
		
		private var initialized:Signal;
		private var created:Signal;
		private var _created:Boolean = false;
	}
}