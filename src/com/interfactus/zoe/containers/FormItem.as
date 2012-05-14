package com.interfactus.zoe.containers
{
import com.interfactus.zoe.controls.TextInput;
import com.interfactus.zoe.core.Application;
import com.interfactus.zoe.core.UIComponent;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;

public class FormItem extends UIComponent
{
	private var uiComponent:TextInput;
	private var _label:String;
	private var labelTextField:TextField;
	
	private var sizeChanged:Boolean = true;
	private var _height:Number = 21;
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
	
	public function set text(value:String):void
	{
		uiComponent.text=value;
	}
	
	public function get text():String
	{
		return uiComponent.text;
	}
	
	private var labelChanged:Boolean = false;
	public function set label(value:String):void
	{
		_label=value;
		labelChanged = true;
		invalidateProperties();
	}
	
	public function get label():String
	{
		return _label;
	}
	
	private var _editable:Boolean = true;
	public function set editable(value:Boolean):void
	{
		_editable = value;
		invalidateProperties();
	}
	
	public function FormItem(label:String)
	{
		this.uiComponent = new TextInput();
		
		labelTextField = new TextField();
		labelTextField.defaultTextFormat = resources.formItemLabel;
		labelTextField.autoSize = TextFieldAutoSize.LEFT;
		labelTextField.text = label;
		addChild(labelTextField);
		addEventListener(FocusEvent.FOCUS_IN,focusInHandler);
	}
	
	private function focusInHandler(event:FocusEvent):void
	{
		stage.focus = uiComponent;
	}
	
	override protected function createChildren():void
	{
		uiComponent.x = labelTextField.width+5;
		uiComponent.width = 220;
		if(21!=_height)uiComponent.type=TextInput.AREA;
		uiComponent.height = _height;
		addChild(uiComponent);
		uiComponent.textField.multiline = true;
		
		_width = labelTextField.width+uiComponent.width+5;
	}
	
	override protected function commitProperties():void
	{
		if(labelChanged)
		{
			labelChanged = false;
			labelTextField.text = _label;
			sizeChanged= true;
			invalidateDisplayList();
		}
		uiComponent.textField.type = (_editable)? TextFieldType.INPUT : TextFieldType.DYNAMIC;
	}
	
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	{
		if(sizeChanged){
			sizeChanged = false;
			uiComponent.x = labelTextField.width+5;
			labelTextField.y = (_height/2 - labelTextField.height/2);
			_width = labelTextField.width+uiComponent.width+5;
			uiComponent.height = _height;
		}
	}
	
	public function clean():void
	{
		uiComponent.text = '';
	}
}
}