package com.interfactus.lw.controls
{
import com.interfactus.lw.containers.ApplicationControlBar;
import com.interfactus.lw.core.Application;
import com.interfactus.lw.effects.Tween;

import flash.events.Event;
import flash.filters.BlurFilter;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

public class ToolTipBar extends ApplicationControlBar
{
	public function ToolTipBar()
	{
		super();
		alpha = 0;
		showHideEffects = false;
	}
	
	override protected function createChildren():void
	{
		timeTipTxt = new TextField();
		timeTipTxt.autoSize = TextFieldAutoSize.LEFT;
		timeTipTxt.defaultTextFormat = resources.label;
		timeTipTxt.x = 2;
		timeTipTxt.y = 1;
		addChild(timeTipTxt);
		
		super.createChildren();
	}
	
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		timeTipTxt.x = 3.5 + timeTipTxt.width/2;
	}
	
	
	
	override protected function commitProperties():void
	{
		timeTipTxt.text = _text;
		
		super.commitProperties();
	}
	
	private var _text:String;
	private var timeTipTxt:TextField;
	
	public function set text(value:String):void
	{
		_text = value;
		invalidateProperties();
	}
	
	override public function get visible():Boolean
	{
		return super.visible;
	}
	
	override public function set visible(value:Boolean):void
	{
		if(value){
			super.visible = value;
			Tween.toVisible( this );
			mouseEnabled = true;
		} else {
			Tween.toInvisible( this );
			super.visible = value;
			mouseEnabled = false;
		}
	}
}
}