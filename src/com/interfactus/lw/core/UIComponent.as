package com.interfactus.lw.core
{
	import com.interfactus.lw.effects.Tween;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	
	public class UIComponent extends Sprite
	{
		public function UIComponent()
		{
			super();
			super.tabEnabled = false;
			super.focusRect = new Object;
			
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		protected function initialize(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			if (_initialized)
				return;
			_initialized = false;
			
			dispatchEvent(new Event('configureIOC', true))
			
			if(!(this is Application))
				resources = Application.application.resources;
			
			stage.addEventListener(Event.ENTER_FRAME, validate);
			
			if(created)
				return;
			createChildren();
		}
		
		protected var resources:Object;
		
		protected function createChildren():void
		{
			if(created)
				return;
			_created = true;
			childrenCreated();
		}
		
		protected function childrenCreated():void
		{
			//stageWidth = stage.stageWidth;
			//stageHeight = stage.stageHeight;
			
			//invalidateProperties();
			//invalidateSize();
			//invalidateDisplayList();
		}
		
		public function invalidateProperties():void{invalidatePropertiesFlag = true}
		public function invalidateSize():void{invalidateSizeFlag = true}
		public function invalidateDisplayList():void{invalidateDisplayListFlag = true}
		
		private function validate(event:Event):void
		{
			if(created)
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
		
		protected function commitProperties():void
		{
		}
		
		protected function updateDisplayList(unscaledWidth:Number,
											 unscaledHeight:Number):void
		{
		}

		public var showHideEffects:Boolean = true;
		
		private var _visible:Boolean = true;
		override public function get visible():Boolean
		{
			return _visible;
		}
		
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
			if (!initialized)
				return;
			
			super.visible = value;
		}
		
		private function visibleEffectCompleteHandler():void
		{
			super.visible = _visible;
		}
		
		private var _width:Number = 200;
		private var _height:Number = 30;
		
		public var stageWidth:Number;
		public var stageHeight:Number;
		
		override public function set width(value:Number):void
		{
			_width = value;
			invalidateDisplayList();
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			invalidateDisplayList();
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		private var invalidatePropertiesFlag:Boolean = false;
		private var invalidateSizeFlag:Boolean = false;
		private var invalidateDisplayListFlag:Boolean = false;
		
		private var _initialized:Boolean = false;
		
		protected function get initialized():Boolean
		{
			return _initialized;
		}
		
		private var _created:Boolean = false;
		
		public function get created():Boolean
		{
			return _created;
		}
		
	}
}