package kickflip.app.model
{
	import flash.display.Sprite;
	import flash.filters.BevelFilter;
	import flash.filters.GlowFilter;

	public class ButtonStyle
	{
		public var base:ButtonStyleParameter;
		public var over:ButtonStyleParameter;
		public var disabled:ButtonStyleParameter;
		public var press:ButtonStyleParameter;
		
		public var width:uint = 0;
		public var height:uint = 0;
		public var fontSize:uint = 38;
		public var round:uint = 38;

		public function ButtonStyle():void
		{
			base = new ButtonStyleParameter();
			base.textColor = 0xffffff;
			base.colors = [0x51877b, 0x51877b];
			base.alphas = [1, 1];
			base.ratios = [0x00, 0xFF];
			
			over = new ButtonStyleParameter();
			over.textColor = 0x1f416c;
			over.colors = [0x7fb2ea, 0x7fb2ea];
			over.alphas = [0.5, 0.5];
			over.ratios = [0x00, 0xFF];
			over.drawAction = function(item:Sprite):void
			{
				var filterB:BevelFilter = new BevelFilter(1, 45, 0xffffff, 1, 0x5c5c5c, .8, 2, 2, 2, 3, "inner", false);
				var filterG2:GlowFilter = new GlowFilter(0xffffff, 1, 6, 6, 1, 3, false, false);
				item.filters = [filterG2];
			}
			
			disabled = new ButtonStyleParameter();
			disabled.textColor = 0x777777;
			disabled.colors = [0xAAAAAA, 0x999999];
			disabled.alphas = [0.7, 0.7];
			disabled.lineStyleColor = 0x999999;
			
			press = new ButtonStyleParameter();
			press.textColor = 0xDCDCDC;
			press.colors = [0xA8A8AA, 0x616061, 0x282928];
			press.alphas = [0.5, 0.5, 0.5];
			press.lineStyleColor = 0x188CF8;
			press.lineStyleAlpha = 0.5;
			press.drawAction = function(item:Sprite):void
			{
				var filterB:BevelFilter = new BevelFilter(1, 45, 0xffffff, 1, 0x5c5c5c, 1, 2, 2, 2, 3, "inner", false);
				var filterG1:GlowFilter = new GlowFilter(0x188CF8, 1, 2, 2, 1, 3, false, false);
				var filterG2:GlowFilter = new GlowFilter(0xffffff, 1, 5, 5, 1, 3, false, false);
				item.filters = [filterG1,filterG2];
			}
		}
	}
}