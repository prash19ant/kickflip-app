package kickflip.app.manager
{
	import kickflip.app.AppText;
	import kickflip.app.control.Button;
	import kickflip.app.model.ButtonStyle;
	
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;

	public class ButtonStyleManager
	{
		private static var _instance:ButtonStyleManager = null;

		public function ButtonStyleManager(enforcer:SingletonEnforcer)
		{
			if (_instance != null){ throw new Error(AppText.ERROR_SINGLETON_INSTANCE); }
			initialize();
		}
		
		public static function get instance():ButtonStyleManager
		{
			if(_instance == null){ _instance = new ButtonStyleManager(new SingletonEnforcer()); }
			return _instance;
		}
		
		public var defaultStyle:ButtonStyle;
		public var loginStyle:ButtonStyle;
		public var registerStyle:ButtonStyle;
		public var conditionStyle:ButtonStyle;
		public var blueStyle:ButtonStyle;
		public var violetStyle:ButtonStyle;
		
		private function initialize():void
		{
			defaultStyle = new ButtonStyle();
			loginStyle = new ButtonStyle();
			loginStyle.base.colors = [0x51877b, 0x51877b];
			loginStyle.base.alphas = [1, 1];
			loginStyle.base.drawAction = function(base:Sprite):void
			{
				var shape:Shape = base.getChildByName(Button.SHAPE_NAME) as Shape;
				shape.blendMode = BlendMode.MULTIPLY;

				var filterD:DropShadowFilter = new DropShadowFilter(1, 80, 0xffffff, 1, 6, 6, 2, 3, false, true);
				var filter:Shape = base.getChildByName(Button.FILTER_NAME) as Shape;
				filter.filters = [filterD];
			}
			loginStyle.over.textColor = 0xffffff;
			loginStyle.over.colors = [0x459cce, 0x459cce];
			loginStyle.over.alphas = [1, 1];
			loginStyle.over.drawAction = function(item:Sprite):void
			{
				var shape:Shape = item.getChildByName(Button.SHAPE_NAME) as Shape;
				shape.blendMode = BlendMode.NORMAL;
				
				var filterD:DropShadowFilter = new DropShadowFilter(0, 80, 0x51877b, 1, 6, 6, 1, 2, false, true);
				var filter:Shape = item.getChildByName(Button.FILTER_NAME) as Shape;
				filter.filters = [filterD];
			}
				
			registerStyle = new ButtonStyle();
			registerStyle.base.colors = [0xFF0000, 0xFF0000];
			registerStyle.base.alphas = [1, 1];
			registerStyle.base.drawAction = function(item:Sprite):void
			{
				var shape:Shape = item.getChildByName(Button.SHAPE_NAME) as Shape;
				shape.blendMode = BlendMode.MULTIPLY;

				var filterD:DropShadowFilter = new DropShadowFilter(0, 80, 0xf7832e, 1, 6, 6, 2, 2, false, true);
				var filter:Shape = item.getChildByName(Button.FILTER_NAME) as Shape;
				filter.filters = [filterD];
			}
			registerStyle.over.colors = [0x94470f, 0x94470f];
			registerStyle.over.alphas = [1, 1];
			registerStyle.over.textColor = 0xffffff;
			registerStyle.over.drawAction = function(item:Sprite):void
			{
				var shape:Shape = item.getChildByName(Button.SHAPE_NAME) as Shape;
				shape.blendMode = BlendMode.ERASE;

				var filter:Shape = item.getChildByName(Button.FILTER_NAME) as Shape;
			}
			registerStyle.press.textColor = registerStyle.over.textColor;
				
			conditionStyle = new ButtonStyle();
			conditionStyle.base.colors = [0x51877b, 0x51877b];
			conditionStyle.base.alphas = [0.5, 0.5];
			conditionStyle.base.lineStyleAlpha = 0;
			conditionStyle.fontSize = 20;
			conditionStyle.base.drawAction = function(base:Sprite):void
			{
				var shape:Shape = base.getChildByName(Button.SHAPE_NAME) as Shape;
				shape.blendMode = BlendMode.MULTIPLY;
				
				var filterD:DropShadowFilter = new DropShadowFilter(4, 80, 0x000000, 1, 6, 6, 2, 3, false, false);
				var filter:Shape = base.getChildByName(Button.FILTER_NAME) as Shape;
				filter.filters = [filterD];
			}
			conditionStyle.over.textColor = 0xffffff;
			conditionStyle.over.colors = [0x51877b, 0x51877b];
			conditionStyle.over.lineStyleAlpha = 0;
			conditionStyle.over.drawAction = function(base:Sprite):void
			{
				var shape:Shape = base.getChildByName(Button.SHAPE_NAME) as Shape;
				shape.blendMode = BlendMode.LIGHTEN;
				
				var filter:Shape = base.getChildByName(Button.FILTER_NAME) as Shape;
				filter.filters = [];
			}
				
			blueStyle = new ButtonStyle();
			blueStyle.base.colors = [0x7bafc0, 0x7bafc0];
			blueStyle.base.drawAction = function(base:Sprite):void
			{
				var filterD:DropShadowFilter = new DropShadowFilter(1, 80, 0xffffff, 1, 6, 6, 2, 3, false, true);
				var filter:Shape = base.getChildByName(Button.FILTER_NAME) as Shape;
				filter.filters = [filterD];
			}
			blueStyle.over.drawAction = function(base:Sprite):void
			{
				var shape:Shape = base.getChildByName(Button.SHAPE_NAME) as Shape;
				shape.blendMode = BlendMode.LIGHTEN;
				
				var filterD:DropShadowFilter = new DropShadowFilter(1, 80, 0x1f416c, 1, 6, 6, 2, 3, false, true);
				var filter:Shape = base.getChildByName(Button.FILTER_NAME) as Shape;
				filter.filters = [filterD];
			}
			blueStyle.press.textColor = blueStyle.over.textColor;
				
			violetStyle = new ButtonStyle();
			violetStyle.base.colors = [0x2a3160, 0x2a3160];
			violetStyle.base.drawAction = function(base:Sprite):void
			{
				var shape:Shape = base.getChildByName(Button.SHAPE_NAME) as Shape;
				shape.blendMode = BlendMode.MULTIPLY;
				
				var filterD:DropShadowFilter = new DropShadowFilter(1, 80, 0xffffff, 1, 6, 6, 2, 3, false, true);
				var filter:Shape = base.getChildByName(Button.FILTER_NAME) as Shape;
				filter.filters = [filterD];
			}
			violetStyle.over.textColor = 0x2a3160;
			violetStyle.over.colors = [0xf4ab38, 0xf4ab38];
			violetStyle.press.textColor = violetStyle.over.textColor;
		}
	}
}

class SingletonEnforcer {}