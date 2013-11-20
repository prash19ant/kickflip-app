package flipviw.app.setting.reader
{
	import flipviw.app.event.ConfigReaderEvent;
	import flipviw.app.util.Util;
	import flipviw.app.util.logger.Log;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class ConfigReader extends EventDispatcher
	{
		private var configData:Object;
		private var configUrl:String = "";
		
		public function ConfigReader(configUrl:String)
		{
			this.configUrl = configUrl;
		}
		
		public function init():void
		{
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, loadXML);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, loadError);
			xmlLoader.load(new URLRequest(configUrl));
		}
		
		private function loadXML(event:Event) : void
		{
			var xmlLoader:URLLoader = event.target as URLLoader;
			xmlLoader.removeEventListener(Event.COMPLETE, loadXML);
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
			parseConfig(URLLoader(event.target).data);
		}
		
		private function loadError(event:IOErrorEvent) : void
		{
			Log.Error("application.util.ConfigReader.Error : "+ event.text);
		}
		
		private function parseConfig(data:String):void
		{
			configData = {};
			var xmlData:XML = new XML(data);
			XML.ignoreWhitespace = true;
			var nodes:XMLList = xmlData.parameter;
			for each(var nodo:XML in nodes)
			{
				configData[nodo.attribute("name")] = evalData(nodo, nodo.attribute("type"));
			}
			dispatchEvent(new ConfigReaderEvent(ConfigReaderEvent.EVENT_XML_PARSED, configData));
		}
		
		private function evalData(value:Object, type:String):Object
		{
			type = type.toLowerCase();
			if(type=="boolean"){
				if(value=="true") return true; else return false;
			}
			if(type=="number"){
				return Number(value);
			}
			if(type=="uint"){
				return uint(value);
			}
			if(type=="string"){
				return value;
			}
			if(type=="date"){
				return Util.stringToDate(value.toString());
			}
			if(type=="array"){
				return String(value).split(",");
			}
			return value;
		}
	}
}