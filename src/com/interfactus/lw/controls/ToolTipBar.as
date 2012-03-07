package com.interfactus.lw.controls
{
import caurina.transitions.Tweener;

import flash.filters.BlurFilter;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import com.interfactus.lw.Assets;
import com.interfactus.lw.containers.ApplicationControlBar;

public class ToolTipBar extends ApplicationControlBar
{
	private var assets:Assets = Assets.getInstance();
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
		super.visible = value;
		
		if(value){
			Tweener.addTween( this, { alpha:1, _filter:new BlurFilter(0,0), time:0.6} );
			mouseEnabled = true;
		} else {
			Tweener.addTween( this, { alpha:0, _filter:new BlurFilter(50,0), time:0.7} );
			mouseEnabled = false;
		}
	}
	
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
		timeTipTxt.defaultTextFormat = assets.label;
		timeTipTxt.x = 2;
		timeTipTxt.y = 2;
		addChild(timeTipTxt);
	}
	
	override protected function commitProperties():void
	{
		timeTipTxt.text = _text;
	}
	
}
}