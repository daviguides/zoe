package com.interfactus.zoe.controls
{
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;

import com.interfactus.zoe.core.UIComponent;

public class TextArea extends UIComponent
{
	private var textFormat:TextFormat;
	private var textField:TextField;
	
	public function TextArea()
	{
		super();
	}
	
	override protected function createChildren():void
	{
		textFormat = new TextFormat();
		textFormat.font = "Verdana";
		textFormat.color = 0x0b333c;
		textFormat.size = 10;
		
		textField = new TextField();
		textField.type = TextFieldType.INPUT;
		textField.defaultTextFormat = textFormat;
		textField.multiline = true;
		textField.background = true;
		textField.border = true;
		textField.borderColor = 0x5B5D5E;
		addChild(textField);
	}
	
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	{
		if(sizeChanged){
			sizeChanged = false;
			textField.width = _width;
			textField.height = _height;
		}
	}
	
	public function get text():String
	{
		return textField.text;
	}
	public function set text(value:String):void
	{
		textField.text=value;
	}
	
	private var sizeChanged:Boolean = true;
	override public function set height(value:Number):void
	{
		_height=value;
		sizeChanged = true;
		invalidateDisplayList();
	}
	
	override public function get height():Number
	{
		return _height;
	}
	
	override public function set width(value:Number):void
	{
		_width=value;
		sizeChanged = true;
		invalidateDisplayList();
	}
	
	override public function get width():Number
	{
		return _width;
	}
	
}
}