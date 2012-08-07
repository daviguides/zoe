package com.interfactus.zoe.controls
{
	import com.interfactus.zoe.core.UIComponent;
	import com.interfactus.zoe.effects.Tween;
	import com.interfactus.zoe.events.SliderEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import net.kawa.tween.easing.Sine;
	
	[Event(name="change", type="SliderEvent")]
	[Event(name="thumbDrag", type="SliderEvent")]
	[Event(name="thumbPress", type="SliderEvent")]
	[Event(name="thumbRelease", type="SliderEvent")]
	
	public class Slider extends UIComponent
	{
		override protected function createChildren():void
		{
			super.width = 50;
			track = new resources.SliderTrack_Skin;
			highlight = new resources.SliderHighlight_Skin;
			highlight.width = 0;
			thumb = new Button;
			thumb.styleName = 'SliderThumb2';
			
			//thumb.width =10;
			//thumb.height =100;
			thumb.x = - thumb.width/2;
			thumb.y = -1;//thumb.height;
			
			_bar = new Sprite();
			
			_barMask = new Sprite();
			_barMask.visible = true;
			_bar.addChild(DisplayObject(_barMask));
			DisplayObject(_bar).mask = DisplayObject(_barMask);
			
			disabledAlpha = new resources.SliderDisabled_Skin;
			
			addChild(track);
			addChild(_bar);
			_bar.addChild(highlight);
			addChild(disabledAlpha);
			disabledAlpha.visible = false;
			
			bound = new Sprite();
			bound.addEventListener(MouseEvent.MOUSE_DOWN, bound_onMouseDown);
			
			addChild(bound);
			addChild(thumb);
			
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			super.createChildren();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			if(valueChanged || sizeChanged)
			{
				_startX = Math.round((_startValue/_maximum)*(unscaledWidth));
				if(_value!=0){
					xTo = Math.round(((_value-_startValue)/(_maximum-_startValue))*(unscaledWidth-_startX));
				} else {
					xTo = 0;
				}
				thumb.x = _startX + xTo - thumb.width/2; 
				highlight.width = xTo;
				valueChanged = false;
			}
			
			if(sizeChanged)
			{
				highlight.height = unscaledHeight;
				track.height = unscaledHeight;
				disabledAlpha.height = unscaledHeight;
				
				if(track.width != unscaledWidth)
				{
					track.width = unscaledWidth;
					disabledAlpha.width = unscaledWidth;
				}
				
				g = bound.graphics;
				
				g.clear();
				g.beginFill(0xFFFFFF, 0);
				g.drawRect(0, 0, track.width, track.height);
				g.endFill();
				
				sizeChanged = false;
			}
			
			if(enabledChanged)
			{
				enabledChanged = false;
				//progressBar.visible = _enabled;
				//highlight.visible = _enabled;
				//track.visible = _enabled;
				thumb.visible = _enabled;
				disabledAlpha.visible = !_enabled;
			}
			
			if (_barMask)
			{
				var g:Graphics = _barMask.graphics;
				
				g.clear();
				g.beginFill(0xFFFFFF);
				g.drawRect(0, 0, unscaledWidth, unscaledHeight);
				g.endFill();
			}
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			if (enabled)
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				xOffset = event.localX;
				
				thumbIsPressed = true;
				
				e = new SliderEvent(SliderEvent.THUMB_PRESS);
				e.value = value;
				dispatchEvent(e);
			}
		}
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			if(thumbIsPressed)
			{
				e = new SliderEvent(SliderEvent.THUMB_RELEASE);
				e.value = value;
				dispatchEvent(e);
				
				e = new SliderEvent(SliderEvent.CHANGE);
				e.value = value;
				dispatchEvent(e);
				
				thumbIsPressed = false;
			}
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			var pt:Point = new Point(event.stageX, event.stageY);
			pt = globalToLocal(pt);
			
			xTo = Math.min(Math.max(pt.x - xOffset, boundMin), boundMax);
			thumb.x = xTo;
			highlight.width = xTo;
			
			e = new SliderEvent(SliderEvent.THUMB_DRAG);
			e.value = value;
			dispatchEvent(e);
			
			invalidateDisplayList();
		}
		
		private function bound_onMouseDown(event:MouseEvent):void
		{
			if (enabled)
			{
				xTo = Math.min(Math.max(event.localX, boundMin), boundMax);
				e = new SliderEvent(SliderEvent.CHANGE);
				e.value = xTo/((track.width)/100)*(maximum/100);//xTo/(this.width*maximum)
				dispatchEvent(e);
				
				Tween.moveTo( thumb, { x:xTo-thumb.width/2 },  onTweenEnd);
				Tween.moveTo( highlight, { width:xTo-_startX },  onTweenEnd);
			}
		}
		
		private function onTweenEnd():void
		{
			//if(_source!=null)
			//	source.play();
		}
		
		protected var track:Sprite;
		protected var highlight:Sprite;
		protected var disabledAlpha:Sprite;
		protected var thumb:Button;
		protected var bound:Sprite;
		
		private var g:Graphics;
		private var e:SliderEvent;
		private var xOffset:Number;
		private var thumbIsPressed:Boolean = false;
		private var indeterminatePlaying:Boolean = false;
		
		private var __minimum:Number = 0;
		private var __maximum:Number = 0;
		private var __value:Number = 0;
		
		private var _startValue:Number = 0;
		private var _startX:Number = 0;
		private var xTo:Number;
		
		protected var _bar:Sprite;
		protected var _barMask:Sprite;

		private var indeterminateMoveInterval:Number = 30;
		private var _maximum:Number = 100;
		
		public function get maximum():Number
		{
			return _maximum;
		}
		
		public function set maximum(value:Number):void
		{
			_maximum = value;
		}
		
		private var _value:Number = 0;
		
		private var valueChanged:Boolean = false;
		
		public function set value(value:Number):void
		{
			_value = value;
			
			valueChanged = true;
			invalidateDisplayList();
		}
		
		public function get value():Number
		{
			return xTo/((track.width)/100)*(maximum/100);
		}
		
		private var _enabled:Boolean = true;
		private var enabledChanged:Boolean = false;
		public function get enabled():Boolean
		{
			return _enabled;
		}
		public function set enabled(value:Boolean):void
		{
			if (value!=_enabled)
			{
				_enabled = value;
				enabledChanged = true;
				
				invalidateDisplayList();
			}
		}
		
		private function get boundMin():Number
		{
			return 0;
		}
		
		private function get boundMax():Number
		{
			return Math.max(thumb.width/2, bound.width);
		}
		
	}
}