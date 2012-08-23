package com.interfactus.zoe.controls.button
{
	import com.interfactus.zoe.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
	public class SimpleButton extends UIComponent
	{
		private var _styleName:String='Button';
		
		private var styleChanged:Boolean = false;
		public function set styleName(value:String):void
		{
			if(styleChanged)
				return
				
				_styleName = value;
			styleChanged = true;
			
			invalidateDisplayList();
		}
		
		protected var upSkin: Sprite;

		public function SimpleButton()
		{
			super();
			this.focusRect = new Object;
		}
		
		override protected function createChildren():void
		{
			//visible= true;
			if(_styleName){
				upSkin = new resources[_styleName+'_upSkin'];
			}
			addChild(upSkin);
			//up.visible = false;
			upSkin.mouseEnabled = false;
			
			if(width==0)width = upSkin.width;
			if(height==0)height = upSkin.height;
			
			hitRect = new Sprite();
			addChild(hitRect);
			
			hitRect.mouseEnabled = true;
			
			hitRect.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			hitRect.addEventListener(MouseEvent.CLICK, clickHandler);
			
			super.createChildren();
		}
		
		private var hitRect:Sprite;
		protected function clickHandler(event:MouseEvent):void
		{
			event.stopPropagation();
		}
		
		//private var pressioned:Boolean = false;
		private function downHandler(event:MouseEvent):void
		{
			if (!_enabled)
				return;
			
			dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var g:Graphics = hitRect.graphics;
			
			g.clear();
			g.beginFill(0xFFFFFF, 0);
			g.drawRect(-3, -3, upSkin.width+6, upSkin.height+10);
			g.endFill();
			
			if(sizeChanged){
				sizeChanged = false;
				upSkin.width = unscaledWidth;
			}
		}
		
		private var _enabled:Boolean = true;
		public function set enabled(value: Boolean):void 
		{
			_enabled = value;
			
			this.mouseEnabled = value;
		}	
		
	}
}