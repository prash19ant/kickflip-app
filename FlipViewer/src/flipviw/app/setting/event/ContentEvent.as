package flipviw.app.setting.event
{
	import flash.events.Event;
	
	import icbc.nav.entity.Content;
	
	public class ContentEvent extends Event
	{
		public static const READER_READY:String = "content.reader.ready";
		public static const ERROR:String = "content.reader.error";

		public var data:Content;

		public function ContentEvent(type:String, data:Content)
		{
			this.data = data;
			super(type);
		}

		override public function clone():Event
		{
			return new ContentEvent(type, data);
		}
	}
}