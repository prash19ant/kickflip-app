package flipviw.app.event
{
	import flash.events.Event;
	
	public class ConfigReaderEvent extends Event
	{
		public static const EVENT_XML_PARSED:String = "EVENT_XML_PARSED";
		
		public var configData:Object;
		
		public function ConfigReaderEvent(type:String, cfg:Object)
		{
			configData = cfg;
			super(type);
		}
		
		override public function clone():Event
		{
			return new ConfigReaderEvent(type, configData);
		}
	}
}