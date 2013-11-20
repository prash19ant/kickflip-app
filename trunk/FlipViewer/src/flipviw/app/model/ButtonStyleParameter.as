package flipviw.app.model
{
	import flash.display.Sprite;

	public class ButtonStyleParameter
	{
		public var textColor:uint = 0xffffff;
		public var colors:Array = [0xffffff, 0xa9b8c3];
		public var alphas:Array = [1, 1];
		public var ratios:Array = [0x00, 0xFF];
		public var drawAction:Function = function(item:Sprite):void {};
		public var lineStyleThickness:uint = 0;
		public var lineStyleColor:uint = 0xD8DAD6;
		public var lineStyleAlpha:uint = 0;
	}
}