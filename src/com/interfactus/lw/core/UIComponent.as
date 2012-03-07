package com.interfactus.lw.core
{
import caurina.transitions.Tweener;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.BlurFilter;

public class UIComponent extends Sprite
{
	//--------------------------------------------------------------------------
    //
    //  Variables: Invalidation
    //
    //--------------------------------------------------------------------------
    
    public var stageWidth:Number;
	public var stageHeight:Number;
    
    //private var layoutManager:LayoutManager = LayoutManager.getInstance();
    //public static var cicleTimer:Timer = new Timer(10, 0);
	
	private var _visible:Boolean = true;
	
	public var showHideEffects:Boolean = true;
	
	override public function addChild(child:DisplayObject):DisplayObject
	{
		return super.addChild(child);
	}
	
	override public function get visible():Boolean
	{
		return _visible;
	}
	
	override public function set visible(value:Boolean):void
	{
		_visible = value;
		if(showHideEffects && initialized){
			if(_visible){
				Tweener.addTween( this, { alpha:1, _filter:new BlurFilter(0,0), time:0.4, transition:"easeoutquint", onComplete:visibleEffectCompleteHandler});
				mouseEnabled = true;
			} else {
				Tweener.addTween( this, { alpha:0, _filter:new BlurFilter(20,20), time:0.4, transition:"easeoutquint", onComplete:visibleEffectCompleteHandler});
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
	//private var name:String = this.;	

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
    
	public function UIComponent()
	{
		super();
		super.tabEnabled = false;
		super.focusRect = new Object;
       
		addEventListener(Event.ADDED_TO_STAGE, initialize);
		
	}
	
	protected function initialize(event:Event):void
    {
        if (_initialized)
            return;
        
        //UICompoment.cicleTimer.start();
		//UICompoment.cicleTimer.addEventListener(TimerEvent.TIMER, validate);
		
        //dispatchEvent(new FlexEvent(FlexEvent.PREINITIALIZE));
       // createChildren();
       
		stage.addEventListener(Event.ENTER_FRAME, validate);
       if(!created)
       {
       	_created = true;
    	createChildren();
       }
    }
    
    protected function createChildren():void
    {
    	if(created)
    		return;
    	_created = true;
    	//trace('childrenCreated');
    	childrenCreated();
    }

    protected function childrenCreated():void
    {
    	//stageWidth = stage.stageWidth;
		//stageHeight = stage.stageHeight;
    	//updateDisplayList(stageWidth, stageHeight);
    	
        invalidateProperties();
        invalidateSize();
        invalidateDisplayList();
    }
    
    public function invalidateProperties():void
    {
        if (!invalidatePropertiesFlag)
        {
            invalidatePropertiesFlag = true;

          //  if (parent && UIComponentGlobals.layoutManager)
            //    UIComponentGlobals.layoutManager.invalidateProperties(this);
        }
    }

    public function invalidateSize():void
    {
        if (!invalidateSizeFlag)
        {
            invalidateSizeFlag = true;

          //  if (parent && UIComponentGlobals.layoutManager)
           //     UIComponentGlobals.layoutManager.invalidateSize(this);
        }
    }

    public function invalidateDisplayList():void
    {
        if (!invalidateDisplayListFlag)
        {
            invalidateDisplayListFlag = true;

           // if (parent && UIComponentGlobals.layoutManager)
           //     UIComponentGlobals.layoutManager.invalidateDisplayList(this);
        }
    }
	
	/*
	* FIXME Dont't used variables
	*/
    //private var lastUnscaledWidth:Number;
    //private var lastUnscaledHeight:Number;
    
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
		//trace('commitProperties');
	}
    
    protected function updateDisplayList(unscaledWidth:Number,
                                        unscaledHeight:Number):void
    {
    	//trace('updateDisplayList'+this.toString());
    }
		
}
}