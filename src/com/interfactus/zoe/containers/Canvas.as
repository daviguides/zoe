package com.interfactus.zoe.containers
{
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Matrix;


public class Canvas extends Container
{
	override protected function createChildren():void
	{
		super.createChildren();
	}

	override protected function updateDisplayList(unscaledWidth:Number,
                                        unscaledHeight:Number):void
	{
		var g:Graphics = this.graphics;
		
		if(gradientCanvas)
		{
			_backgroundAlpha = 0.8;
			g.clear();
			g.lineStyle(1, 0xB1B1B1);
			
			var fillColors:Array = [0x3B3232, 0x000000];
			var fillAlphas:Array = [_backgroundAlpha, _backgroundAlpha];
			
			var rotation:Number = 90;
			var tempMatrix:Matrix = new Matrix();
			tempMatrix.createGradientBox(unscaledWidth, unscaledHeight,
				rotation * Math.PI / 180, 0, 0);
			
			g.beginGradientFill('linear', fillColors, fillAlphas, null, tempMatrix);
			g.drawRoundRect(0, 0, unscaledWidth, unscaledHeight, 15, 15);
			g.endFill();
		} else {
			g.clear();
			g.beginFill(_backgroundColor, _backgroundAlpha);
			//g.lineStyle(1, 0xB1B1B1);
			g.drawRect(0, 0, unscaledWidth, unscaledHeight);
			g.endFill();
		}
		super.updateDisplayList(unscaledWidth, unscaledHeight);
	}
	
	protected var backgroundCanvas:Sprite;
	protected var _backgroundAlpha:Number = 0.0;
	protected var _backgroundColor:uint = 0x000000;
	protected var gradientCanvas:Boolean=false;
	
}

}