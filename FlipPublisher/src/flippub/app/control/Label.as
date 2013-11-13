package flippub.app.control
{
	import flippub.app.AppGlobal;
	import flippub.app.manager.FontManager;
	import cesvi.quiz.manager.InputStyleManager;
	import cesvi.quiz.model.InputStyle;
	
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	public class Label extends Sprite
	{
		public static var defaultWidth:uint = 100;
		public static var defaultHeight:uint = 40;
		public static var defaultStyle:InputStyle = InputStyleManager.instance.defaultStyle;
		public static function clearStyle():void { defaultStyle = InputStyleManager.instance.defaultStyle; }
		private var style:InputStyle;
		private var appWidth:uint = 100;
		private var appHeight:uint = 40;
		private var main:Sprite;
		
		public function Label(text:String, style:InputStyle = null, widthInput:uint = 0, heightInput:uint = 0, textAlign:String = "right")
		{
			appWidth = (widthInput>0)?widthInput:defaultWidth;
			appHeight = (heightInput>0)?heightInput:defaultHeight;
			this.style = style == null ? defaultStyle : style;
			
			main = new Sprite();
			main.graphics.beginFill(0xffffff,0);
			main.graphics.drawRect(0, 0, appWidth, appHeight);
			main.graphics.endFill();
			addChild(main);
			
			var format:TextFormat = new TextFormat();
			format.font = FontManager.instance.TradeGothicLgCn;
			format.color = 0xffffff;
			format.size = style.labelFontSize;
			format.align = textAlign;
			
			var txt:TextField = new TextField();
			txt.type = TextFieldType.DYNAMIC;
			txt.text = text;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.width = appWidth;
			txt.height = appHeight;
			txt.gridFitType = GridFitType.PIXEL;
			txt.embedFonts = true;
			txt.defaultTextFormat = format;
			txt.setTextFormat(format);
			txt.x = 0;
			txt.y = appHeight/2 - txt.textHeight/2 - 1;
			main.addChild(txt);
			
			var filterD:DropShadowFilter = new DropShadowFilter(3, 80, 0x000000, 0.8, 5, 5, 1, 3);
			txt.filters = [filterD];
			
			height = appHeight;
			width = appWidth;
		}
	}
}