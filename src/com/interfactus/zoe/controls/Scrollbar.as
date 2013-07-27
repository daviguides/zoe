/**
 * WRITEME
 */
package com.interfactus.zoe.controls{
	
	import com.interfactus.zoe.effects.Tween;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.flash_proxy;
	
	/**
	 * WRITEME
	 */
	public class Scrollbar extends MovieClip {
		
		public var Objet:Object = new Object();
		//private's
		private var target:MovieClip;
		private var top:Number;
		private var bottom:Number;
		private var dragBot:Number;
		private var range:Number;
		private var ctrl:Number;//This is to adapt to the target's position
		private var trans:Object;
		private var timing:Number;
		private var isUp:Boolean;
		private var isDown:Boolean;
		private var isArrow:Boolean;
		private var arrowMove:Number;
		private var upArrowHt:Number;
		private var downArrowHt:Number;
		private var sBuffer:Number;
		private var mascara:Boolean = true;
		private var mask_y:Number;
		private var mask_h:Number;
		private var calibre:Number = 5;
		private var sRect:Rectangle;
		
		public function Scrollbar(O:Object, palco:Object):void {
			Objet = O;
			Objet.scroller.addEventListener(MouseEvent.MOUSE_DOWN, dragScroll);
			palco.stage.addEventListener(MouseEvent.MOUSE_UP, stopScroll);
			visible = false;
		}
		//
		public function init(t:MovieClip, tr:Object, tt:Number, sa:Boolean, b:Number, fake:Object="", cal:Number=5):void {
			target = t;
			trans = tr;
			timing = tt;
			isArrow = sa;
			sBuffer = b;
			calibre = cal;
			if (target.height <= Objet.track.height) {
				target.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
				Objet.visible = false;
				if (fake != "") {
					fake.visible = true;
				}
			} else {
				target.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
				Objet.visible = true;
				if (fake != "") {
					fake.visible = false;
				}
			}
			
			//
			target.y = Objet.y;
			
			if (isArrow) {
				upArrowHt = Objet.upArrow.height;
				downArrowHt = Objet.downArrow.height;
				top = Objet.scroller.y;
				dragBot = (Objet.scroller.y + Objet.track.height) - Objet.scroller.height;
				bottom = Objet.track.height - (Objet.scroller.height/sBuffer);
				
			} else {
				top = Objet.scroller.y;
				dragBot = (Objet.scroller.y + Objet.track.height) - Objet.scroller.height;
				bottom = Objet.track.height - (Objet.scroller.height/sBuffer);
				
				upArrowHt = 0;
				downArrowHt = 0;
				//Objet.upArrow.visible = false;
				//Objet.downArrow.visible = false;
			}
			range = bottom - top;
			sRect = new Rectangle(0, top, 0, dragBot);
			ctrl = target.y;
			//set Mask
			isUp = false;
			isDown = false;
			arrowMove = 8;
			
			if (isArrow) {
				Objet.upArrow.addEventListener(Event.ENTER_FRAME, upArrowHandler);
				Objet.upArrow.addEventListener(MouseEvent.MOUSE_DOWN, upScroll);
				Objet.upArrow.addEventListener(MouseEvent.MOUSE_UP, stopScroll);
				//
				Objet.downArrow.addEventListener(Event.ENTER_FRAME, downArrowHandler);
				Objet.downArrow.addEventListener(MouseEvent.MOUSE_DOWN, downScroll);
				Objet.downArrow.addEventListener(MouseEvent.MOUSE_UP, stopScroll);
			}
			if (mascara) {
				var square:Sprite = new Sprite();
				square.graphics.beginFill(0xFF0000);
				square.graphics.drawRect(target.x, target.y, target.width+5, Objet.track.height);
				target.parent.addChild(square);
				target.mask = square;
				mascara = false;
				mask_y = target.y;
				mask_h = Objet.track.height;
			} else {
				Objet.scroller.y = Objet.track.y;
				target.y = Objet.y;
			}
		}
		//
		private function upScroll(event:MouseEvent):void {
			isUp = true;
		}
		//
		private function downScroll(event:MouseEvent):void {
			isDown = true;
		}
		//
		private function upArrowHandler(event:Event):void {
			if (isUp) {
				if (Objet.scroller.y > top) {
					Objet.scroller.y -= arrowMove;
					if (Objet.scroller.y < top) {
						Objet.scroller.y = top;
					}
					startScroll();
				}
			}
		}
		//
		private function downArrowHandler(event:Event):void {
			if (isDown) {
				if (Objet.scroller.y < dragBot) {
					Objet.scroller.y += arrowMove;
					if (Objet.scroller.y > dragBot) {
						Objet.scroller.y = dragBot;
					}
					startScroll();
				}
			}
		}
		//
		private function dragScroll(event:MouseEvent):void {
			Objet.scroller.startDrag(false, sRect);
			Objet.addEventListener(Event.ENTER_FRAME, moveScroll);
		}
		//
		private function mouseWheelHandler(event:MouseEvent):void {
			if (event.delta < 0) {
				if (Objet.scroller.y < dragBot) {
					Objet.scroller.y-=(event.delta*2);
					if (Objet.scroller.y > dragBot) {
						Objet.scroller.y = dragBot;
					}
					startScroll();
				}
			} else {
				if (Objet.scroller.y > top) {
					Objet.scroller.y-=(event.delta*2);
					if (Objet.scroller.y < top) {
						Objet.scroller.y = top;
					}
					startScroll();
				}
			}
		}
		//
		private function stopScroll(event:MouseEvent):void {
			isUp = false;
			isDown = false;
			Objet.scroller.stopDrag();
			Objet.removeEventListener(Event.ENTER_FRAME, moveScroll);
		}
		//
		private function moveScroll(event:Event):void {
			startScroll();
		}
		private function startScroll():void {
			var ty:Number = (Objet.scroller.y * 100) / (Objet.track.height - Objet.scroller.height);
			Tween.to(target, { y: -Math.round(((((target.height+calibre) - mask_h) * ty) / 100) - mask_y)}, null, timing);
		}
	}
}