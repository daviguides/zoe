package com.interfactus.lw.containers
{
	
public class Panel extends Canvas
{
	public function set backgroundAlpha(value:Number):void
	{
		_backgroundAlpha = value;
		invalidateDisplayList();
	}
	
	public function get backgroundAlpha():Number
	{
		return _backgroundAlpha;
	}
	
	public function set backgroundColor(value:uint):void
	{
		_backgroundColor = value;
		invalidateDisplayList();
	}
	
	public function get backgroundColor():uint
	{
		return _backgroundColor;
	} 
	
	public function Panel()
	{
		super();
		backgroundAlpha = 0;
	}
}
}