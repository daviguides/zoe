package com.interfactus.lw.controls
{
	import com.interfactus.lw.core.Application;
	import com.interfactus.lw.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
	[Event(name="click_alterna")]
	public class Button extends UIComponent
	{
		protected var resources:Object;
		
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
		protected var overSkin: Sprite;
		protected var downSkin: Sprite;
		protected var disabledSkin: Sprite;
		
		private var labelTextField:TextField;
		
		private var labelChanged:Boolean = false;
		private var _label:String;
		public function set label(value:String):void
		{
			_label=value;
			labelChanged = true;
			invalidateProperties();
		}
		
		public function get label():String
		{
			return _label;
		}
		
		private var sizeChanged:Boolean = false;
		private var _height:Number=0;
		override public function set height(value:Number):void
		{
			_height=value;
			sizeChanged = true;
			invalidateDisplayList();
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		private var _width:Number=0;
		override public function set width(value:Number):void
		{
			_width=value;
			sizeChanged = true;
			invalidateDisplayList();
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		public function Button()
		{
			super();
			this.focusRect = new Object;
			
		}
		
		private var _currentState:uint=UP;
		private var stateChaged:Boolean=false;
		private function set currentState(value:uint):void
		{
			_currentState = value;
			stateChaged = true;
			invalidateDisplayList();
		}
		
		private function get currentState():uint
		{
			return _currentState;
		}
		
		override protected function initialize(event:Event):void
		{
			resources = Application.application.resources;
			super.initialize(event);
		}
		
		override protected function createChildren():void
		{
			visible= true;
			if(_styleName){
				upSkin = new resources[_styleName+'_upSkin'];
				overSkin = new resources[_styleName+'_overSkin'];
				downSkin = new resources[_styleName+'_downSkin'];
				disabledSkin = new resources[_styleName+'_disabledSkin'];
			}
			addChild(upSkin);
			addChild(overSkin);
			addChild(downSkin);
			addChild(disabledSkin);
			overSkin.visible = false;
			downSkin.visible = false;
			disabledSkin.visible = false;
			upSkin.mouseEnabled = false;
			overSkin.mouseEnabled = false;
			downSkin.mouseEnabled = false;
			downSkin.mouseEnabled = false;
			
			if(_width==0)_width = upSkin.width;
			if(_height==0)_height = upSkin.height;
			
			labelTextField = new TextField();
			labelTextField.type = TextFieldType.DYNAMIC;
			labelTextField.autoSize = TextFieldAutoSize.LEFT;
			labelTextField.defaultTextFormat = resources.buttonLabel;
			labelTextField.width = _width;
			labelTextField.height = _height;
			addChild(labelTextField);
			labelTextField.mouseEnabled = false;
			var hitRect:Sprite = new Sprite();
			hitRect.width = upSkin.width;
			hitRect.height = upSkin.height;
			hitRect.mouseEnabled = true;
			
			addChild(hitRect);
			
			hitRect.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
			hitRect.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			hitRect.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			hitRect.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
			hitRect.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			hitRect.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			hitRect.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			hitRect.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			event.stopPropagation();
		}
		
		private const UP:uint = 0;
		private const OVER:uint = 1;
		private const DOWN:uint = 2;
		private const DISABLED:uint = 3;
		
		private function buttonPressed():void
		{
			currentState=DOWN;
			
		}
		private function buttonReleased():void
		{
			// Remove the handlers that were added in mouseDownHandler().
			stage.removeEventListener(
				MouseEvent.MOUSE_UP, systemManager_mouseUpHandler, true);
			stage.removeEventListener(
				Event.MOUSE_LEAVE, stage_mouseLeaveHandler);
			removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		private function keyDownHandler(event:KeyboardEvent):void
		{
			if (!_enabled)
				return;
			
			if (event.keyCode == Keyboard.SPACE)
				buttonPressed();
		}
		
		private function keyUpHandler(event:KeyboardEvent):void
		{
			if (!_enabled)
				return;
			
			if (event.keyCode == Keyboard.SPACE)
			{
				buttonReleased();
				
				if (currentState == DOWN)
					dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				currentState = UP;
			}
		}
		
		private function focusInHandler(event:FocusEvent):void{if(_enabled)currentState=OVER}
		private function focusOutHandler(event:FocusEvent):void
		{
			if(!_enabled)
				return;
			
			if ( currentState != UP){
				currentState=UP;
			}
		}
		private function rollOverHandler(event:MouseEvent):void
		{
			if(!_enabled)
				return;
			
			if ( currentState == UP){
				if (event.buttonDown)
					return;
				currentState=OVER;
				event.updateAfterEvent();
			} else if ( currentState == OVER) {
				currentState=DOWN;
				event.updateAfterEvent();
			}
			
		}
		private function rollOutHandler(event:MouseEvent):void
		{
			if(!_enabled)
				return;
			if(currentState==OVER){
				currentState=UP;
			} else if(currentState==DOWN) {
				currentState=OVER;
			}
		}
		private function downHandler(event:MouseEvent):void
		{
			if (!_enabled)
				return;
			addEventListener(MouseEvent.MOUSE_UP, upHandler);
			stage.addEventListener( MouseEvent.MOUSE_UP, systemManager_mouseUpHandler, true);
			stage.addEventListener( Event.MOUSE_LEAVE, stage_mouseLeaveHandler);
			currentState=DOWN;
		}
		private function upHandler(event:MouseEvent):void
		{
			if (!_enabled)
				return;
			//addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			currentState=OVER;
			buttonReleased();
		}
		
		private function systemManager_mouseUpHandler(event:MouseEvent):void
		{
			if (contains(DisplayObject(event.target)))
				return;
			
			currentState=UP;
		}
		
		private function stage_mouseLeaveHandler(event:Event):void
		{
			currentState=UP;
		}
		
		private function setSkin(skin:Sprite):void
		{
			upSkin.visible = false;
			overSkin.visible = false;
			downSkin.visible = false;
			disabledSkin.visible = false;
			
			skin.visible = true;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if(styleChanged){
				upSkin = new resources[_styleName+'_upSkin'];
				overSkin = new resources[_styleName+'_overSkin'];
				downSkin = new resources[_styleName+'_downSkin'];
				disabledSkin = new resources[_styleName+'_disabledSkin'];
				
				if(_width==0)_width = upSkin.width;
				if(_height==0)_height = upSkin.height;
				
				upSkin.mouseEnabled = false;
				overSkin.mouseEnabled = false;
				downSkin.mouseEnabled = false;
				downSkin.mouseEnabled = false;
			}
			if(sizeChanged){
				sizeChanged = false;
				upSkin.width = _width;
				overSkin.width = _width;
				downSkin.width = _width;
				disabledSkin.width = _width;
				labelTextField.width = _width;
			}
			if(stateChaged){
				stateChaged=false;
				switch (_currentState)
				{
					case 1: 
						setSkin(overSkin);break;
					case 2: 
						setSkin(downSkin);break;
					case 3: 
						setSkin(disabledSkin);break;
					case 0: 
					default:
						setSkin(upSkin);break;
				}
			}
			
			labelTextField.x = (_width/2 - labelTextField.width/2);
			labelTextField.y = (_height/2 - labelTextField.height/2);
		}
		
		override protected function commitProperties():void
		{
			if(labelChanged)
			{
				labelChanged = false;
				labelTextField.text = _label;
			}
		}
		
		private var _enabled:Boolean = true;
		public function set enabled(value: Boolean):void 
		{
			//super.enabled = value;
			_enabled = value;
			
			this.mouseEnabled = value;
			currentState= (value) ? UP : DISABLED;
		}	
		
	}
}