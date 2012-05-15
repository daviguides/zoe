package com.interfactus.zoe.events
{

import flash.events.Event;

public class VideoDisplayEvent extends Event 
{
    
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
	
	public static const BUFFERING:String = "buffering";
	public static const CLOSE:String = "close";
    public static const COMPLETE:String = "complete"; 
    public static const CONNECTION_ERROR:String = "connectionError";
	public static const DISCONNECTED:String = "disconnected";
    public static const EXEC_QUEUED_CMD:String = "execQueuedCmd";
    public static const LOADING:String = "loading";
    public static const PAUSED:String = "paused";
    public static const PLAYHEAD_UPDATE:String = "playheadUpdate"; 
    public static const PLAYING:String = "playing";
    public static const READY:String = "ready";
    public static const RESIZING:String = "resizing";
    public static const REWIND:String = "rewind";
    public static const REWINDING:String = "rewinding";
    public static const SEEKING:String = "seeking";	
    public static const STATE_CHANGE:String = "stateChange";
    public static const STOPPED:String = "stopped";
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
	public function VideoDisplayEvent(type:String, bubbles:Boolean = false,
							   cancelable:Boolean = false,
							   state:String = null, playheadTime:Number = NaN) 
	{
		super(type, bubbles, cancelable);

		this.state = state;
		this.playheadTime = playheadTime;
	}
	
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

	//----------------------------------
    //  playheadTime
    //----------------------------------
    public var playheadTime:Number;

	//----------------------------------
    //  state
    //----------------------------------
	public var state:String;

	//----------------------------------
    //  stateResponsive
    //----------------------------------
	public function get stateResponsive():Boolean
	{
		switch (state) 
		{
			case DISCONNECTED:
			case STOPPED:
			case PLAYING:
			case PAUSED:
			case BUFFERING:
			{
				return true;
			}

			default:
			{
				return false;
			}
		}
	}

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
		return new VideoDisplayEvent(type, bubbles, cancelable,
							  state, playheadTime);
	}
}

}
