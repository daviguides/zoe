package com.interfactus.lw.events
{

import flash.events.Event;

public class MetadataEvent extends Event 
{
    
    public static const METADATA_RECEIVED:String = "metadataReceived";

    public static const CUE_POINT:String = "cuePoint";

	public static const NAVIGATION:String = "navigation";

	public static const EVENT:String = "event";

    public static const ACTION_SCRIPT:String = "actionscript";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    public function MetadataEvent(type:String, bubbles:Boolean = false,
                                  cancelable:Boolean = false,
                                  info:Object = null) 
    {
        super(type, bubbles, cancelable);

        this.info = info;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    public var info:Object;

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: Event
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */     
    override public function clone():Event 
    {
        return new MetadataEvent(type, bubbles, cancelable, info);
    }
}

}
