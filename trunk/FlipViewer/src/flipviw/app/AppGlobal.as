package flipviw.app
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flipviw.app.control.Alert;
	import flipviw.app.setting.event.ReaderEvent;
	import flipviw.app.util.logger.Log;
	
	import org.osflash.signals.Signal;

	public class AppGlobal extends EventDispatcher
	{
		public static var AdminDebug:Boolean = true;
		public static var PathConfig:String = "config.xml";
		public static const VERSION:String = "0.0.1";
		private static var DEFAULT_URL_SERVER:String = "http://localhost/QuizService/";
		public static var URL_SERVER:String = null;
		public static var DataServiceEndPoint:String = "";
		public static var backgroundImagePath:String = "images/background.jpg";
		public static var MEDIA_SERVER_RMTP:String = "rtmp://localhost:2037/MediaTriggerService/";
		public static var DEFAULT_STREAM_NAME:String = "medialive";
		
		public static const DEFAULT_WIDTH:uint = 700;
		public static const DEFAULT_HEIGHT:uint = 400;
		public static const FONT_TYPE:String = "Arial";

		public var onReady:Signal = new Signal();
		public var skipConfig:Boolean = true;

		public function init(stage:Stage, loadConfig:Boolean = true):void
		{
			Log.Info("Global.version > " + VERSION);
			if(stage != null)
				stage.stageFocusRect = false;
			Alert.init(stage);
			if(skipConfig)
				appConfigReady();
			else
				initAppConfig();
		}
		
		private function initAppConfig():void
		{
			var config:AppConfig = new AppConfig();
			config.onReady.add(appConfigReady);
			config.init();
		}
		
		private function appConfigReady():void
		{
			var currentServer:String = URL_SERVER != null ? URL_SERVER : DEFAULT_URL_SERVER;
			DataServiceEndPoint = currentServer;

			onReady.dispatch();
		}

		public static function startWait():void
		{

		}
		
		public static function endWait():void
		{

		}
	}
}