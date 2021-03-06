package com.interfactus.zoe.controls
{
	import com.interfactus.zoe.controls.button.Button;
	import com.interfactus.zoe.controls.media.IStream;
	import com.interfactus.zoe.controls.media.IVideoDisplay;
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
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	[Event(name="change", type="SliderEvent")]
	[Event(name="thumbDrag", type="SliderEvent")]
	[Event(name="thumbPress", type="SliderEvent")]
	[Event(name="thumbRelease", type="SliderEvent")]
	
	public class ProgressSlider extends UIComponent
	{
		override protected function createChildren():void
		{
			super.width = 50;
			track = new resources.SliderTrack_Skin;
			progressBar = new Sprite();//new resources.ProgressBar_Skin;
			progressBar.width = 10;
			highlightColor = resources.highlightColor;
			highlight = new Sprite();//new resources.SliderHighlight_Skin;
			highlight.width = 0;
			thumb = new Button;
			thumb.styleName = 'SliderThumb';
			//thumb.width =10;
			//thumb.height =100;
			thumb.x = - thumb.width/2;
			thumb.y = -3;//thumb.height;
			
			_bar = new Sprite();
			layer = new Sprite();
			
			_barMask = new Sprite();
			_barMask.visible = true;
			_bar.addChild(DisplayObject(_barMask));
			DisplayObject(_bar).mask = DisplayObject(_barMask);
			
			indeterminateBar = new resources.ProgressIndeterminateSkin;
			indeterminateBar.width = this.width+indeterminateMoveInterval;
			disabledAlpha = new resources.SliderDisabled_Skin;
			
			addChild(track);
			addChild(_bar);
			addChild(layer);
			_bar.addChild(indeterminateBar);
			_bar.addChild(progressBar);
			_bar.addChild(highlight);
			addChild(disabledAlpha);
			disabledAlpha.visible = false;
			
			bound = new Sprite();
			bound.addEventListener(MouseEvent.MOUSE_DOWN, bound_onMouseDown);
			
			addChild(bound);
			addChild(thumb);
			
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			pollTimer = new Timer(interval);
			pollTimer.addEventListener(TimerEvent.TIMER, updateIndeterminateHandler, false, 0, true);
			pollTimer.start();
			
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			super.createChildren();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			if (sourceChanged)
			{
				sourceChanged = false;
				if(_source is IStream){
					(_source as IStream).streamLoading.add( setProgress );
				} else {
					_source.addEventListener(ProgressEvent.PROGRESS, progressHandler);
					_source.addEventListener(Event.COMPLETE, completeHandler);
				}
			}
			
			if(enabledChanged)
			{
				enabledChanged = false;
				//progressBar.visible = _enabled;
				//highlight.visible = _enabled;
				indeterminateBar.visible = _enabled;
				//track.visible = _enabled;
				thumb.visible = _enabled;
				disabledAlpha.visible = !_enabled;
			}
			
			if(bufferingChanged)
			{
				bufferingChanged = false;
				progressBar.visible = !_buffering;
				//highlight.visible = !_buffering;
				indeterminateBar.visible = _buffering;
				disabledAlpha.visible = _buffering;
			}
			
			if(enabledSliderChanged)
			{
				enabledSliderChanged = false;
				thumb.visible = _enabledSlider;
				bound.removeEventListener(MouseEvent.MOUSE_DOWN, bound_onMouseDown);
				thumb.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
			
			if (_barMask)
			{
				var g:Graphics = _barMask.graphics;
				
				g.clear();
				g.beginFill(0xFFFFFF);
				g.drawRect(0, 0, unscaledWidth, unscaledHeight);
				g.endFill();
			}
			
			if (indeterminateChanged)
			{
				indeterminateChanged = false;
				
				indeterminateBar.visible = _indeterminate;
				
				if (_indeterminate && visible){
					startPlayingIndeterminate();
					indeterminateBar.visible = true;
				}else{
					stopPlayingIndeterminate();
					indeterminateBar.visible = false;
				}
			}
			
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
				progressBar.x = highlight.x = _startX;
				valueChanged = false;
			}
			
			if(sizeChanged)
			{
				highlight.height = unscaledHeight;
				track.height = unscaledHeight;
				disabledAlpha.height = unscaledHeight;
				progressBar.height = unscaledHeight;
				
				if(track.width != unscaledWidth)
				{
					track.width = unscaledWidth;
					disabledAlpha.width = unscaledWidth;
					indeterminateBar.width = unscaledWidth+indeterminateMoveInterval;
				}
				
				g = bound.graphics;
				
				g.clear();
				g.beginFill(0xFFFFFF, 0);
				g.drawRect(0, 0, track.width, track.height);
				g.endFill();
				
				g = highlight.graphics;
				
				g.clear();
				g.beginFill(highlightColor);
				g.drawRect(0, 0, track.width, track.height);
				g.endFill();
				
				g = progressBar.graphics;
				
				g.clear();
				g.beginFill(highlightColor);
				g.drawRect(0, 0, track.width, track.height);
				g.endFill();
				
				function lightness(level:Number):ColorTransform {
					var w:Number = level * 255;
					var m:Number = 1 - level;
					var tf:ColorTransform = new ColorTransform();
					tf.redMultiplier = m
					tf.greenMultiplier = m
					tf.blueMultiplier = m
					tf.redOffset = w
					tf.greenOffset = w
					tf.blueOffset = w
					tf.alphaMultiplier = 1.0
					tf.alphaOffset = 0.0
					return tf;
				}
				
				progressBar.transform.colorTransform = lightness(0.4);
				
				sizeChanged = false;
			}
			
			progressBar.width = Math.max(0, (track.width-_startX) * percentComplete / 100);
		}
		
		public function addLayer(layer:DisplayObject):void
		{
			this.layer.addChild(layer);
		}
		
		private function progressHandler(event:ProgressEvent):void
		{
			setProgress(event.bytesLoaded, event.bytesTotal);
		}
		
		public function get percentComplete():Number
		{
			if (__value < __minimum || __maximum < __minimum)
				return 0;
			
			// Avoid divide by zero fault.
			if ((__maximum - __minimum) == 0)
				return 0;
			
			var perc:Number = 100 * (__value - __minimum) / (__maximum - __minimum);
			
			if (isNaN(perc) || perc < 0)
				return 0;
			else if (perc > 100)
				return 100;
			else
				return perc;
		}
		
		public function setProgress(value:Number, maximum:Number):void
		{
			if (!isNaN(value) && !isNaN(maximum))
			{
				__value = value;
				__maximum = maximum;
				invalidateDisplayList();
			}
		}
		
		private function completeHandler(event:Event):void
		{
			dispatchEvent(event);
			invalidateDisplayList();
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			if (enabled)
			{
				selected = true;
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
			selected = false;
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
			
			e = new SliderEvent(SliderEvent.THUMB_DRAG);
			e.value = value;
			dispatchEvent(e);
			
			invalidateDisplayList();
		}
		
		private function bound_onMouseDown(event:MouseEvent):void
		{
			if (enabled)
			{
				if(_source!=null)
					_source.pause();
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
			if(_source!=null && _source as IVideoDisplay)
				source.play();
		}
		
		private function startPlayingIndeterminate():void
		{
			if (!indeterminatePlaying)
			{
				indeterminatePlaying = true;
				
				pollTimer.addEventListener(TimerEvent.TIMER, updateIndeterminateHandler, false, 0, true);
				pollTimer.start();
			}
		}
		
		private function stopPlayingIndeterminate():void
		{
			if (indeterminatePlaying)
			{
				indeterminatePlaying = false;
				
				pollTimer.removeEventListener(TimerEvent.TIMER, updateIndeterminateHandler);
				
				pollTimer.reset();
			}
		}
		
		private function updateIndeterminateHandler(event:Event):void
		{
			if (indeterminateBar.x < 1)
				indeterminateBar.x += 1.5;
			else
				indeterminateBar.x = - indeterminateMoveInterval;
		}
		
		protected var track:Sprite;
		protected var progressBar:Sprite;
		protected var highlight:Sprite;
		protected var disabledAlpha:Sprite;
		protected var thumb:Button;
		protected var indeterminateBar:Sprite;
		protected var bound:Sprite;
		
		private var g:Graphics;
		private var e:SliderEvent;
		private var xOffset:Number;
		private var thumbIsPressed:Boolean = false;
		private var indeterminatePlaying:Boolean = false;
		
		private var pollTimer:Timer;
		private var interval:Number = 30;
		
		private var __minimum:Number = 0;
		private var __maximum:Number = 0;
		private var __value:Number = 0;
		
		private var _startValue:Number = 0;
		private var _startX:Number = 0;
		private var xTo:Number;
		
		protected var _bar:Sprite;
		protected var _barMask:Sprite;

		public function get startValue():Number
		{
			return _startValue;
		}

		public function set startValue(value:Number):void
		{
			_startValue = value;
			if(_startValue!=0)
				_startX = Math.round((_startValue/_maximum)*(this.width));
			else
				_startX = 0;
		}

		
		public var selected:Boolean = false;
		
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
		
		private var valueChanged:Boolean = true;
		
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
		
		private var _indeterminate:Boolean = false;
		
		private var indeterminateChanged:Boolean = true;
		
		public function get indeterminate():Boolean
		{
			return _indeterminate;
		}
		
		public function set indeterminate(value:Boolean):void
		{
			_indeterminate = value;
			indeterminateChanged = true;
		}
		
		private var _source:Object;
		private var sourceChanged:Boolean = false;
		public function get source():Object
		{
			return _source;
		}
		
		public function set source(value:Object):void
		{
			if (value)
			{
				_source = value;
				sourceChanged = true;
			} else if(_source){
				if( _source as EventDispatcher) {
					_source.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
					_source.removeEventListener(Event.COMPLETE, completeHandler);
				}
			}
			invalidateDisplayList();
		}
		
		private var _enabledSlider:Boolean = true;
		private var enabledSliderChanged:Boolean = false;
		public function get enabledSlider():Boolean
		{
			return _enabledSlider;
		}
		public function set enabledSlider(value:Boolean):void
		{
			if (value!=_enabledSlider)
			{
				_enabledSlider = value;
				enabledSliderChanged = true;
				
				invalidateDisplayList();
			}
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
		
		private var _buffering:Boolean = true;
		private var bufferingChanged:Boolean = false;
		private var layer:Sprite;
		private var highlightColor:int;
		public function get buffering():Boolean
		{return _buffering;}
		
		public function set buffering(value:Boolean):void
		{
			if (value!=_buffering)
			{
				_buffering = value;
				bufferingChanged = true;
				
				invalidateProperties();
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