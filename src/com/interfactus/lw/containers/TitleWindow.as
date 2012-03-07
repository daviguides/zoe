package com.interfactus.lw.containers
{
	
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;

import com.interfactus.lw.Assets;
import com.interfactus.lw.controls.Button;
import com.interfactus.lw.events.CloseEvent;

	
[Event(name="close", type="com.interfactus.lw.events.CloseEvent")]
public class TitleWindow extends Panel
{
	private var assets:Assets = Assets.getInstance();
	public var _showCloseButton:Boolean = true;
	
	public function set showCloseButton(value:Boolean):void
	{
		closeButton.visible = value;
	}
	
	private var closeButton:Button;
	private var _title:String;
	private var titleTxt:TextField;
	
	public function set title(value:String):void
	{
		_title = value;
		invalidateProperties();
	}
	
	public function TitleWindow()
	{
		super();
	}
	
	override protected function createChildren():void
    {
    	super.createChildren();
		closeButton = new Button();
		closeButton.styleName = 'CloseButton';
		addChild(closeButton);
		closeButton.visible = _showCloseButton;
		closeButton.addEventListener(MouseEvent.CLICK, 
							function(event:MouseEvent):void
							{dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
							});
							
		titleTxt = new TextField();
		titleTxt.autoSize = TextFieldAutoSize.LEFT;
		titleTxt.type = TextFieldType.DYNAMIC;
		titleTxt.defaultTextFormat = assets.h3;
		titleTxt.x = 5;
		titleTxt.y = 3;
		titleTxt.width = 100;	
		titleTxt.multiline = true;
		 
		titleTxt.filters = [new DropShadowFilter(1,45,0x444444)];
		addChild(titleTxt);
	}
	
	override protected function commitProperties():void
	{
		titleTxt.text = _title;
	}
	
	override protected function updateDisplayList(unscaledWidth:Number,
                                        	unscaledHeight:Number):void
    {
    	super.updateDisplayList(unscaledWidth, unscaledHeight);
    	closeButton.y = 5;
    	closeButton.x = width-25;
    }
		
}
}