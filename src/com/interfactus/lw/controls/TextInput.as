package com.interfactus.lw.controls
{
import flash.events.FocusEvent;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;

import com.interfactus.lw.core.UIComponent;

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
	private var _height:Number = 22;
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
	
	private var _width:Number = 100;
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