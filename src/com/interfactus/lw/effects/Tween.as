package com.interfactus.lw.effects
{
	import flash.display.DisplayObject;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Transform;
	
	import net.kawa.tween.KTJob;
	import net.kawa.tween.KTManager;
	import net.kawa.tween.KTween;
	import net.kawa.tween.easing.Linear;
	import net.kawa.tween.easing.Quint;
	import net.kawa.tween.util.KTColorTransformUtil;
	import net.kawa.tween.util.KTUtil;

	public class Tween
	{
		static public function to(target:*, to:Object, callback:Function=null, duration:Number=0.7):void
		{
			KTween.to(target, duration, to, Linear.easeOut, callback);
			//Tweener.addTween( this, { alpha:1, _filter:new BlurFilter(0,0), time:0.4, transition:"easeoutquint", onComplete:visibleEffectCompleteHandler});
		}
		
		static public function from(target:*, to:Object, callback:Function=null, duration:Number=0.7):void
		{
			KTween.from(target, duration, to, Linear.easeOut, callback);
		}
		
		static public function toVisible(target:*, callback:Function=null):void
		{
			KTween.to(target, .7, {alpha: 1}, Linear.easeOut, callback);
		}
		
		static public function toInvisible(target:*, callback:Function=null):void
		{
			//, blurX: 20, blurY: 20
			KTween.to(target, .7, {alpha: 0}, Linear.easeOut, callback);
		}
		
		static public function toTrasparent(target:*, callback:Function=null):void
		{
			//, blurX: 20, blurY: 20
			KTween.to(target, .7, {alpha: .5}, Linear.easeOut, callback);
		}
		
		static public function cancelAll():void
		{
			//KTween.manager.cancel();
		}
		
		static public function moveTo(target:*, to:Object,callback:Function=null, duration:Number=0.6):void
		{
			KTween.to(target, duration, to, Quint.easeOut, callback);
		}
		
		static public function lightness(level:Number):Object
		{
			return KTColorTransformUtil.lightness(level)
		}
		
		static public function flashEffect(target:DisplayObject):void
		{
			var tf:ColorTransform = new ColorTransform();
			
			Tween.from(target, {alpha: .3}, null, .8);
			
			var job:KTJob = KTween.from(tf, .8, KTColorTransformUtil.lightness(1));
			job.onChange = function():void {
				target.transform.colorTransform = tf;
			};
		}
		
		public static function fromOverCloud(target:DisplayObject):void
		{
			var blurFilter:BlurFilter = new BlurFilter(1,1);
			var colorTransform:ColorTransform = new ColorTransform();
			
			KTween.to(blurFilter, .8, KTUtil.resetBlurFilter())
				.onChange = function():void 
				{
					var filters:Array = new Array();
					filters.push(blurFilter);
					target.filters = filters;
				};
			
			KTween.to(colorTransform, .8, KTColorTransformUtil.darkness(0))
				.onChange = function():void
				{
					target.transform.colorTransform = colorTransform;
				};
		}
		public static function toOverCloud(target:DisplayObject):void
		{
			var blurFilter:BlurFilter = new BlurFilter(1,1);
			var colorTransform:ColorTransform = new ColorTransform();
			
			KTween.from(blurFilter, .8, KTUtil.resetBlurFilter())
				.onChange = function():void 
				{
					var filters:Array = new Array();
					filters.push(blurFilter);
					target.filters = filters;
				};
			
			KTween.to(colorTransform, .8, KTColorTransformUtil.darkness(0.3))
				.onChange = function():void
				{
					target.transform.colorTransform = colorTransform;
				};
			
			//Tweener.addTween( videoDisplay, { _filter:blur, _ColorMatrix_matrix:matrix, time:0.6, transition:"slideEasingFunction"} );
		}
		
		public static function toBlurDown(target:DisplayObject):void
		{
			var blurFilter:BlurFilter = new BlurFilter(200,0);
			var colorTransform:ColorTransform = new ColorTransform();
			
			KTween.to(blurFilter, .5, KTUtil.resetBlurFilter())
				.onChange = function():void 
				{
					var filters:Array = new Array();
					filters.push(blurFilter);
					target.filters = filters;
				};
			
			KTween.to(target, .5, {x:-1000});
		}
		
		private static function getMatrixBrightness(value:Number):Array
		{
			var matrix:Array = new Array();
			matrix = matrix.concat([value, 0, 0, 0, 0]); // red
			matrix = matrix.concat([0, value, 0, 0, 0]); // green
			matrix = matrix.concat([0, 0, value, 0, 0]); // blue
			matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
			
			return matrix;
		}
	}
}