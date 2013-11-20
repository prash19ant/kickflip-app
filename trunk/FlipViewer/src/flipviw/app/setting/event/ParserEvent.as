package flipviw.app.setting.event
{
	import flash.events.Event;
	
	public class ParserEvent extends Event
	{
		public static const PARSER_READY:String = "parser.ready";
		
		public function ParserEvent(type:String)
		{
			super(type);
		}

		override public function clone():Event
		{
			return new ParserEvent(type);
		}
	}
}