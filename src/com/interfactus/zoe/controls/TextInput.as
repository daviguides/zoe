package com.interfactus.zoe.controls
{
import flash.events.FocusEvent;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;

import com.interfactus.zoe.core.UIComponent;

public class TextInput extends UIComponent
{
	private var textFormat:TextFormat;
	public var textField:TextField;
	
	public function TextInput()
	{
		super();
		this.focusRect = new Object;
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
		textField.background = true;
		textField.border = true;
		textField.borderColor = 0x5B5D5E;
		textField.height = 22;
		addChild(textField);
		addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
		addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
		
	}
	
	private var _type:uint;
	private var typeChanged:Boolean = false;
	public static const LINE:uint=0;
	public static const AREA:uint=1;
	
	public function set type(value:uint):void
	{
		_type = value;
		typeChanged = true;
		invalidateProperties();
	}
	
	private function focusInHandler(event:FocusEvent):void
	{
		textField.borderColor = 0x009DFF;
	}
	
	private function focusOutHandler(event:FocusEvent):void
	{
		textField.borderColor = 0x5B5D5E;
	}
	
	override protected function commitProperties():void
	{
		if(typeChanged){
			typeChanged = false;
			textField.wordWrap = (_type==AREA);
			textField.multiline = (_type==AREA);
		}
	}
	
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	{
		if(sizeChanged){
			sizeChanged = false;
			textField.width = unscaledWidth;
			textField.height = unscaledHeight;
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
}
}