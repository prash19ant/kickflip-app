package flippub.app
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flippub.app.event.AppEvent;
	import flippub.app.event.ConfigReaderEvent;
	import flippub.app.setting.reader.ConfigReader;
	import flippub.app.util.logger.Log;

	public class AppConfig extends EventDispatcher
	{
		public function AppConfig()
		{
			super();
		}

		public function init():void
		{
			var configReader:ConfigReader = new ConfigReader(AppGlobal.PathConfig);
			configReader.addEventListener(ConfigReaderEvent.EVENT_XML_PARSED, setConfigData);
			configReader.init();
		}

		private function setConfigData(evt:ConfigReaderEvent):void
		{
			var configReader:ConfigReader = evt.target as ConfigReader;
			configReader.removeEventListener(ConfigReaderEvent.EVENT_XML_PARSED, setConfigData);

			var configData:Object = evt.configData;
			for (var key:String in configData)
			{
				Log.Info("setConfigData["+ key +"]:"+ configData[key]);
				if(Object(AppGlobal).hasOwnProperty(key))
					AppGlobal[key] = configData[key];
			}
			dispatchEvent(new Event(AppEvent.CONFIG_READY));
		}
	}
}