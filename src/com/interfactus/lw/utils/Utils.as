package com.interfactus.lw.utils
{
	public class Utils
	{
		public static function formatTime(value:int):String
		{
			var result:String = (value % 60).toString();
			if (result.length == 1)
				result = Math.floor(value / 60).toString() + ":0" + result;
			else 
				result = Math.floor(value / 60).toString() + ":" + result;
			return result;
		}
		
		/**/
		public static function toDisplayTime(seg:Number):String
		{
			var segundosBruto:Number = seg;
			var segundos:Number = Math.floor(segundosBruto % 60);
			var minutos:Number = int(segundosBruto / 60);
			
			var segundosNormalizado:String;
			if (segundos <= 9 && segundos >= 0) {
				segundosNormalizado = "0" + String(segundos);
			} else {
				if (segundos > 59) {
					segundosNormalizado = "00";
				} else {
					segundosNormalizado = String(segundos);
				}
			}
			
			var minutosNormalizado:String;
			if (minutos <= 9 && minutos >= 0) {
				minutosNormalizado = "0" + String(minutos);
			} else {
				if (minutos > 59) {
					minutosNormalizado = "00";
				} else {
					minutosNormalizado = String(minutos);
				}
			}
			return minutosNormalizado + ":" + segundosNormalizado;
		}
	}
}