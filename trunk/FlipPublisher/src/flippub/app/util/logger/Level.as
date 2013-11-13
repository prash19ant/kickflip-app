package flippub.app.util.logger
{
	public class Level
	{
		public static var FATAL:Number = 0; 
		public static var ERROR:Number = 1; 
		public static var WARN:Number = 2; 
		public static var INFO:Number = 3; 
		public static var DEBUG:Number = 4;
		
		public static function toString(level:Number):String
		{
			var txt:String = level.toString();
			switch(level)
			{
				case 0:
					txt = "FATAL";
					break;
				case 1:
					txt = "ERROR";
					break;
				case 2:
					txt = "WARN";
					break;
				case 3:
					txt = "INFO";
					break;
				case 4:
					txt = "DEBUG";
					break;
			}
			return txt;
		}
	}
}