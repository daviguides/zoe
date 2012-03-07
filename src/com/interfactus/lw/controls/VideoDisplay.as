package com.interfactus.lw.controls
{
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import mx.controls.videoClasses.VideoPlayer;
	import mx.messaging.SubscriptionInfo;
	
public class VideoDisplay extends VideoPlayer
{
	//private var metadata:Object;
	/*
	* FIXME Dont't used variables
	*/
	//private var barWidth:int;
	//private var loaded:int = 0;
	//private var loading:Boolean = false;
	
	public var _source:String;
	
	public function set source(value:String):void
	{
		sourceChanged = true;
		_source = value;
		commitProperties();
	}
	private var sourceChanged:Boolean = false;
	
	public var playing:Boolean = false;
	
    //include "videoFunctions/videoSliderFunctions.as";
	public function VideoDisplay()
	{
		super(10, 10);
		
		visible = true;
		smoothing = true;
        autoRewind = true;
        bufferTime = 5;
        volume = 0.75;

        x = 0;
        y = 0;
		
		addEventListener(Event.ADDED_TO_STAGE, createChildren);
	}
	
	private var _created:Boolean = false;
	
	protected function createChildren(event:Event):void
	{
		if(!_created){
			_created = true;
			setSize(stage.stageWidth, stage.stageHeight);
		}
	}
	
	private function onAStatus(event:AsyncErrorEvent):void
	{
		trace(event);
	}
	private function onIOStatus(event:IOErrorEvent):void
	{
		trace(event);
	}
	
	protected function commitProperties():void
	{
		
	}
	
	override public function pause():void
	{
		super.pause();
		playing = false;
	}
	
	override public function play(url:String = null, isLive:Boolean = false, totalTime:Number = -1):void {
		var s:String;
		if(sourceChanged)
		{
			sourceChanged = false;
			s = _source;
		} else {
			s = null;
		}
		playing = true;
		super.play(s);
	}
}
}