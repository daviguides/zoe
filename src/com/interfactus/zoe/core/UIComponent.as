package com.interfactus.zoe.core
{
	import com.interfactus.zoe.effects.Tween;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	
	public class UIComponent extends Zoe
	{
		override protected function initialize():void
		{
			if(!(this is Application))
				resources = Application.application.resources;
			
			super.initialize();
		}
		
		protected var resources:Object;
	}
}