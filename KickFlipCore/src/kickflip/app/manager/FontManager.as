package kickflip.app.manager
{
	public class FontManager
	{
		/*
		[Embed(source="../../../../../fonts/1TRAGLC_.TTF", fontName="TradeGothicLgCn", fontWeight= "normal", embedAsCFF="false")]
		public static var tradeGothicFont:Class;
		[Embed(source="../../../../../fonts/1TRAGBC_.TTF", fontName="TradeGothicLgCn", fontWeight= "bold", embedAsCFF="false")]
		public static var tradeGothicFontBold:Class;
		[Embed(source="../../../../../fonts/SketchRockwell-Bold.ttf", fontName="SketchRockwell", embedAsCFF="false")]
		public static var sketchRockwellFont:Class;
		[Embed(source="../../../../../fonts/EatpooSkinny.pfb", fontName="EatpooSkinny", embedAsCFF=false, mimeType="application/x-font-truetype")]
		public static var eatpooSkinnyFont:Class;
		*/
		
		private static var _instance:FontManager;
		public static function get instance():FontManager
		{
			if(_instance == null)
				_instance = new FontManager();
			return _instance;
		}
		
		public var TradeGothicLgCn:String = "TradeGothicLgCn";
		public var SketchRockwell:String = "SketchRockwell";
		public var EatpooSkinny:String = "EatpooSkinny";
	}
}