package com.interfactus.zoe.events
{
import flash.events.Event;

public class SliderEvent extends Event
{
	public static const CHANGE:String = "change";
    public static const THUMB_DRAG:String = "thumbDrag";
    public static const THUMB_PRESS:String = "thumbPress";
    public static const THUMB_RELEASE:String = "thumbRelease";

    public function SliderEvent(type:String, bubbles:Boolean = false,
                                cancelable:Boolean = false,
                                thumbIndex:int = -1, value:Number = NaN,
                                triggerEvent:Event = null,
                                clickTarget:String = null, keyCode:int = -1)
    {
        super(type, bubbles, cancelable);

        this.thumbIndex = thumbIndex;
        this.value = value;
        this.triggerEvent = triggerEvent;
        this.clickTarget = clickTarget;
        this.keyCode = keyCode;
    }
    
    public var clickTarget:String;
    public var keyCode:int;
    public var thumbIndex:int;
    public var triggerEvent:Event;
    public var value:Number;
    
    override public function clone():Event
    {
        return new SliderEvent(type, bubbles, cancelable, thumbIndex,
                               value, triggerEvent, clickTarget, keyCode);
    }
	}
}