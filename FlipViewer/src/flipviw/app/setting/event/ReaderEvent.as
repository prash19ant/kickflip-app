package flipviw.app.setting.event
{
	import flash.events.Event;
	
	public class ReaderEvent extends Event
	{
		public static const READER_READY:String = "reader.ready";

		public function ReaderEvent(type:String)
		{
			super(type);
		}

		override public function clone():Event
		{
			return new ReaderEvent(type);
		}
	}
}