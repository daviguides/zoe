package com.interfactus.lw.controls
{
import caurina.transitions.Tweener;

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.ProgressEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

import com.interfactus.lw.Assets;
import com.interfactus.lw.core.UIComponent;
import com.interfactus.lw.events.SliderEvent;

[Event(name="change", type="com.interfactus.lw.events.SliderEvent")]
[Event(name="thumbDrag", type="com.interfactus.lw.events.SliderEvent")]
[Event(name="thumbPress", type="com.interfactus.lw.events.SliderEvent")]
[Event(name="thumbRelease", type="com.interfactus.lw.events.SliderEvent")]

public class ProgressSlider extends UIComponent
{
	private var assets:Assets = Assets.getInstance();
	
    protected var track:MovieClip;
    protected var progressBar:MovieClip;
    protected var highlight:MovieClip;
    protected var disabledAlpha:MovieClip;
    protected var thumb:Button;
    protected var indeterminateBar:MovieClip;
    protected var bound:Sprite;
    
    protected var _bar:Sprite;
	protected var _barMask:Sprite;    
    
    private var g:Graphics;
    private var e:SliderEvent;
    private var xOffset:Number;
    public var thumbIsPressed:Boolean = false;
    private var sizeChanged:Boolean = false;
    private var indeterminatePlaying:Boolean = false;
    
    private var pollTimer:Timer;
    private var interval:Number = 30;
    
    private var __minimum:Number = 0;
    private var __maximum:Number = 0;
    private var __value:Number = 0;
    
    public var selected:Boolean = false;
    
    private var _width:Number = 50;
    private var indeterminateMoveInterval:Number = 26;
    override public function set width(value:Number):void
    {
    	_width = value;
    	
    	sizeChanged = true;
    	invalidateDisplayList();
    }
    
    override public function get width():Number
    {
    	return _width;
    }
    
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
		return (thumb.x - thumb.width/2)/((track.width - thumb.width)/100)*(maximum/100);
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
	
	private function get boundMin():Number
	{
		return 0;
	}
	
	private function get boundMax():Number
	{
		return Math.max(thumb.width/2, bound.width - thumb.width/1.5);
	}
	
	public function ProgressSlider()
	{
		super();
		pollTimer = new Timer(interval);
		addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
		createChildren();
	}
	
	override protected function createChildren():void
	{
		super.createChildren();
		if (!_bar)
        {
            _bar = new Sprite();
            addChild(_bar);
        }

        if (!_barMask)
        {
			_barMask = new Sprite();

            _barMask.visible = true;
            _bar.addChild(DisplayObject(_barMask));
            DisplayObject(_bar).mask = DisplayObject(_barMask);
        }        
		
		track = new assets.SliderTrack_Skin;
		progressBar = new assets.ProgressBar_Skin;
		progressBar.x = 0.7;
		progressBar.y = 0.7;
		progressBar.width = 4;
		highlight = new assets.SliderHighlight_Skin;
		highlight.x = 0.7;
		highlight.y = 0.7;
		thumb = new Button;
		thumb.styleName = 'SliderThumb';
		thumb.y = -1.2;
		indeterminateBar = new assets.ProgressIndeterminateSkin;
		indeterminateBar.width = width+indeterminateMoveInterval;
		indeterminateBar.x = 0.7;
		indeterminateBar.y = 0.7;
		disabledAlpha = new assets.SliderDisabled_Skin;
		_bar.addChild(track);
		_bar.addChild(indeterminateBar);
		_bar.addChild(progressBar);
		_bar.addChild(highlight);
		_bar.addChild(disabledAlpha);
		disabledAlpha.visible = false;
		
		bound = new Sprite();
		addChild(bound);
		addChild(thumb);
		
		bound.addEventListener(MouseEvent.MOUSE_DOWN, bound_onMouseDown);
		
		thumb.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		//root.addEventListener(MouseEvent.MOUSE_UP, onMouseDown, true);
		
		pollTimer.addEventListener(TimerEvent.TIMER, updateIndeterminateHandler, false, 0, true);
		pollTimer.start();
		
		invalidateDisplayList();
	}
	
	private function addedToStageListener (e:Event):void {
      // Register for "global" mouse move and mouse up events
      stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
    }

    // Executed whenever this object is removed from the display list
    private function removedFromStageListener (e:Event):void {
      // Unregister for "global" mouse move and mouse up events
      stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
    }
	
	override protected function commitProperties():void
	{
		super.commitProperties();
	}
	
	override protected function updateDisplayList(stageWidth:Number,
                                        stageHeight:Number):void
	{
		super.updateDisplayList(stageWidth, stageHeight);
		if (sourceChanged)
        {
        	sourceChanged = false;
        	_source.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_source.addEventListener(Event.COMPLETE, completeHandler);
			
        }
        
        if(enabledChanged)
        {
        	enabledChanged = false;
        	thumb.visible = _enabled;
        	//thumb = new SliderThumb_disabledSkin;//(!_enabled)?thumbEnabled:thumbDisabled;
        	disabledAlpha.visible = !_enabled;
        }
        
        if(enabledSliderChanged)
        {
        	enabledSliderChanged = false;
        	thumb.visible = _enabledSlider;
        	bound.removeEventListener(MouseEvent.MOUSE_DOWN, bound_onMouseDown);
			thumb.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        }
		
		if(track.width != _width)
		{
			track.width = _width;
			disabledAlpha.width = _width;
			sizeChanged = false;
			indeterminateBar.width = width;
			g = bound.graphics;
        
		    g.clear();
		    g.beginFill(0xFFFFFF, 0);
		    g.drawRect(0, 0, track.width, track.height);
		}
		
		if(valueChanged)
        {
        	if(_value!=0){
        		thumb.x = thumb.width/2 + Math.round((_value/_maximum)*(track.width - thumb.width));
        	} else {thumb.x =0};
        	valueChanged = false;
        }
        
        highlight.width = thumb.x;
        
        if (_barMask)
        {
            //_barMask.move(0,0);
            
            var g:Graphics = _barMask.graphics;
            g.clear();
            g.beginFill(0xFFFF00);
            g.drawRect(1, 1, track.width - 2, track.height - 2);
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
        
        var w:Number = Math.max(0, track.width * percentComplete / 100);
            progressBar.setActualSize(w, track.height);
		
	}
	
	private function progressHandler(event:ProgressEvent):void
    {
        setProgress(event.bytesLoaded, event.bytesTotal);
         var w:Number = Math.max(0, track.width * (event.bytesLoaded/event.bytesTotal));
    	//trace(w);
            progressBar.width = w;
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
/*
            // Dipatch an Event of type "change".
            dispatchEvent(new Event(Event.CHANGE));

            // Dispatch a Progress
            var progressEvent:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
            progressEvent.bytesLoaded = value;
            progressEvent.bytesTotal = maximum;
            dispatchEvent(progressEvent);

            if (_indeterminate)
                startPlayingIndeterminate();

            if (value == maximum && value > 0)
            {
                if (_indeterminate)
                    stopPlayingIndeterminate();

                if (mode != ProgressBarMode.EVENT) // We get our own complete event when in event mode
                    dispatchEvent(new Event(Event.COMPLETE));
            }
*/
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
			
		thumb.x = Math.min(Math.max(pt.x - xOffset, boundMin), boundMax);
		
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
			var xTo:Number = Math.min(Math.max(event.localX, boundMin), boundMax);
			e = new SliderEvent(SliderEvent.CHANGE);
        	e.value = (xTo - thumb.width/2)/((width - thumb.width)/100)*(maximum/100);
        	dispatchEvent(e);
			//thumb.x = xTo;
			//highlight.width = xTo;
			Tweener.addTween( thumb, { x:xTo, time:0.6, transition:"slideEasingFunction", onComplete:onTweenEnd} );
			Tweener.addTween( highlight, { width:xTo, time:0.6, transition:"slideEasingFunction"} );
		}
	}
	
	private function onTweenEnd():void
	{
		if(_source!=null)
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
            indeterminateBar.x += 1;
        else
            indeterminateBar.x = - (indeterminateMoveInterval - 2);
    }
	
}
}