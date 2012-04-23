package com.interfactus.lw.core
{
	import mx.logging.ILogger;
	import mx.logging.Log;

	public class AbstractLoggedObject
	{
		protected var log:ILogger = Log.getLogger("com.interfactus.lw.core");
		
		public function AbstractPM(className:String="AbstractLoggedObject")
		{
			this.log = Log.getLogger("com.interfactus.lw.core."+className);
		}
	}
}