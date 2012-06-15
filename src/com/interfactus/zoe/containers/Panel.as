package com.interfactus.zoe.containers
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;

	public class Panel extends Canvas implements IClose
	{
		override protected function createChildren():void
		{
			closeButton = new resources.closeButtonSkin();
			backgroundSkin.addChild( closeButton );
			closeButton.addEventListener(MouseEvent.CLICK, 
				function():void{close.dispatch()});
			closeButton.buttonMode = true;
			
			super.createChildren();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			closeButton.y = 10;
			closeButton.x = unscaledWidth - 30;
			
			_backgroundAlpha = .8;
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		private var _close:Signal = new Signal();
		public function get close():Signal
		{
			return _close;
		}
		
		private var _showCloseButton:Boolean;

		public function get showCloseButton():Boolean
		{
			return _showCloseButton;
		}

		public function set showCloseButton(value:Boolean):void
		{
			_showCloseButton = value;
			closeButton.visible = value;
		}

		
		private var closeButton:Sprite;
	}
}