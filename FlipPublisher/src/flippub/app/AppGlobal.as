package flippub.app
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flippub.app.control.Alert;
	import flippub.app.event.AppEvent;
	import flippub.app.setting.event.ReaderEvent;
	import flippub.app.util.logger.Log;
	
	import org.osflash.signals.Signal;

	public class AppGlobal extends EventDispatcher
	{
		public static var AdminDebug:Boolean = true;
		public static var PathConfig:String = "CesviQuizClient.config.xml";
		public static const VERSION:String = "1.1.4";
		private static var DEFAULT_URL_SERVER:String = "http://localhost/QuizService/";
		public static var URL_SERVER:String = null;
		public static var DataServiceEndPoint:String = "";
		public static var LoginEndPoint:String = "{SERVER}/Authenticate.aspx";
		public static var ImageEndPoint:String = "{SERVER}/ImageFile.aspx";
		public static var backgroundImagePath:String = "images/background.jpg";
		public static var HOME_SERVER:String = "index.html";
		
		public static const DEFAULT_WIDTH:uint = 1024;
		public static const DEFAULT_HEIGHT:uint = 640;
		public static const FONT_TYPE:String = "Arial";
		public static const PROMPT_FONT_SIZE:uint = 36;
		public static const ANSWER_FONT_SIZE:uint = 26;
		public static const ANSWER_SMALL_FONT_SIZE:uint = 22;
		public static const CATEGORY_ID1:uint = 1;
		public static const CATEGORY_ID2:uint = 2;
		public var onReady:Signal = new Signal();

		public function init(stage:Stage, loadConfig:Boolean = true):void
		{
			Log.Info("Global.version > " + VERSION);
			if(stage != null)
				stage.stageFocusRect = false;
			Alert.init(stage);
			initAppConfig();
		}
		
		private function initAppConfig():void
		{
			var config:AppConfig = new AppConfig();
			config.addEventListener(AppEvent.CONFIG_READY, appConfigReady);
			config.init();
		}
		
		private function appConfigReady(evt:Event):void
		{
			(evt.target as AppConfig).removeEventListener(AppEvent.CONFIG_READY, appConfigReady);

			var currentServer:String = URL_SERVER != null ? URL_SERVER : DEFAULT_URL_SERVER;
			DataServiceEndPoint = currentServer;
			LoginEndPoint = LoginEndPoint.replace("{SERVER}", currentServer);
			ImageEndPoint = ImageEndPoint.replace("{SERVER}", currentServer);

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