package flippub.app.setting.reader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import flippub.app.control.Alert;
	import flippub.app.setting.event.ContentEvent;
	import flippub.app.setting.event.ReaderEvent;
	import flippub.app.setting.parser.ContentParser;
	import flippub.app.setting.parser.MenuParser;
	import flippub.app.util.logger.Log;
	import icbc.nav.Session;
	import icbc.nav.entity.Content;
	
	public class ContentReader extends EventDispatcher
	{
		private var path:String = "";

		public function ContentReader(path:String)
		{
			this.path = path;
		}
		
		public function init():void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loadError);
			loader.load(new URLRequest(path));
		}
		
		private function loadComplete(event:Event) : void
		{
			var loader:URLLoader = event.target as URLLoader;
			loader.removeEventListener(Event.COMPLETE, loadComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
			parse(URLLoader(event.target).data);
		}
		
		private function loadError(evt:IOErrorEvent) : void
		{
			Log.Error("ConfigReader.reader.GameSettingReader.Error : "+ evt.text);
			Alert.show("ConfigReader.Error: "+ evt.text);
		}
		
		private function parse(data:String):void
		{
			var xmlData:XML = new XML(data);
			XML.ignoreWhitespace = true;
			var parser:ContentParser = new ContentParser(xmlData);
			ready(parser.content);
		}
		
		private function ready(data:Content):void
		{
			dispatchEvent(new ContentEvent(ContentEvent.READER_READY, data));
		}
	}
}