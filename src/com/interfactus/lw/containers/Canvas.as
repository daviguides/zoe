package com.interfactus.lw.containers
{
import flash.display.Graphics;


public class Canvas extends Container
{
	public function Canvas()
	{
		super();
	}
	
	protected var _backgroundAlpha:Number = 0.0;
	protected var _backgroundColor:uint = 0xFFFFFF;
	
	override protected function updateDisplayList(unscaledWidth:Number,
                                        unscaledHeight:Number):void
	{
		var g:Graphics = this.graphics;
		g.clear();
		g.beginFill(_backgroundColor, _backgroundAlpha);
		g.lineStyle(1, 0xB1B1B1);
	    g.drawRoundRect(0, 0, unscaledWidth, unscaledHeight, 15, 15);
	    g.endFill();
	}
	
}

}