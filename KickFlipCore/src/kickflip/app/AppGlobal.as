package kickflip.app
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import kickflip.app.control.Alert;
	import kickflip.app.setting.event.ReaderEvent;
	import kickflip.app.util.logger.Log;
	
	import org.osflash.signals.Signal;

	public class AppGlobal extends EventDispatcher
	{
		public static const PATH_CONFIG:String = "config.xml";
		public static const VERSION:String = "0.0.2";

		public static const MEDIA_SERVER_RMTP:String = "rtmp://localhost:1935/VideoRecording/";
		public static const DEFAULT_STREAM_NAME:String = "medialive";
		
		public static var defaultWidth:uint = 700;
		public static var defaultHeight:uint = 400;
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