package com.interfactus.zoe.containers
{
import flash.display.DisplayObject;
	
public class Form extends Canvas
{
	public function Form()
	{
		super();
		_height = 21;
	}
	
	private var objects:Array = new Array();
	public var verticalGap:Number = 5;
	public var horizontalGap:Number = 5;
	
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
	
	override public function addChild(child:DisplayObject):DisplayObject
	{
		objects.push(child);
		super.addChild(child);
		if(numChildren>1){
			child.y = objects[numChildren-2].y+objects[numChildren-2].height+verticalGap;
			_height = child.y+child.height;
			
		}
		if(child.width>_width){ width = 300;}
		trace(child.width);
		
		//nameFormItem.x = (width-10)-emailFormItem.width;
		//emailFormItem.x = (width-10)-emailFormItem.width;
		
		
		return child;
	}
	
	public function clean():void
	{
		for(var i:uint=0;i<objects.length;i++)
		{
			objects[i].clean();
		}
	}
	
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	{
		if(sizeChanged){
			for(var i:uint=0;i<objects.length;i++)
			{
				objects[i].x = _width-objects[i].width;
			}
		}
	}
}
}