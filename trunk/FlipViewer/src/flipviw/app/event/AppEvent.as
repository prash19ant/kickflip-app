package flipviw.app.event
{
	import flash.events.Event;
	
	public class AppEvent extends Event
	{
		public static const CONFIG_READY:String = "seg.ConfigReady";

		public static const GLOBAL_READY:String = "seg.GlobalReady";
		
		public function AppEvent(type:String)
		{
			super(type);
		}
		
		override public function clone():Event
		{
			return new AppEvent(type);
		}
	}
}