package flippub.app.util.logger
{
	public class Log
	{
		public static var TRON:Boolean = true;
		
		public static function Info(txt:String):void
		{
			write(txt,Level.INFO);
		}
		
		public static function Debug(txt:String):void
		{
			write(txt,Level.DEBUG);
		}
		
		public static function Warm(txt:String):void
		{
			write(txt,Level.WARN);
		}
		
		private static function wl(txt:String,level:Number):void
		{
			write(txt,level);
		}
		
		public static function Error(txt:String):void
		{
			write(txt, Level.ERROR);
		}
		
		private static function write(txt:String,level:Number):void
		{
			if(!Log.TRON){ return; }
			var msg:String = "[{level}][{time}] {msg}";
			msg = msg.split("{level}").join(Level.toString(level));
			msg = msg.split("{msg}").join(txt);
			msg = msg.split("{time}").join(timeToLogString(new Date()));
			trace(msg);
		}
		
		private static function timeToLogString(date:Date):String
		{
			var strHours:String = (date.getHours()<10)?"0"+date.getHours():date.getHours().toString();
			var strMinutes:String = (date.getMinutes()<10)?"0"+date.getMinutes():date.getMinutes().toString();
			var strSeconds:String = (date.getSeconds()<10)?"0"+date.getSeconds():date.getSeconds().toString();
			var strMilliseconds:String = (date.getMilliseconds()<100)? (date.getMilliseconds()<10)?"00"+date.getMilliseconds():"0"+date.getMilliseconds():date.getMilliseconds().toString();
			return strHours +":"+ strMinutes +":"+ strSeconds +"."+ strMilliseconds;			
		}
	}
}