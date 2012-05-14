package com.interfactus.zoe.containers
{
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	public class ApplicationControlBar extends Panel
	{
		public function ApplicationControlBar()
		{
			super();
			backgroundAlpha = 0.8;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			var g:Graphics = this.graphics;
			g.clear();
			g.lineStyle(1, 0xB1B1B1);
			
			var fillColors:Array = [0x3B3232, 0x000000];
			var fillAlphas:Array = [backgroundAlpha, backgroundAlpha];
			
			var rotation:Number = 90;
			var tempMatrix:Matrix = new Matrix();
			tempMatrix.createGradientBox(unscaledWidth, unscaledHeight,
				rotation * Math.PI / 180, 0, 0);
			
			g.beginGradientFill('linear', fillColors, fillAlphas, null, tempMatrix);
			g.drawRoundRect(0, 0, unscaledWidth, unscaledHeight, 15, 15);
			g.endFill();
			
			//super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
	}
}