package kickflip.app.control
{
	import kickflip.app.manager.ButtonStyleManager;
	import kickflip.app.manager.FontManager;
	import kickflip.app.model.ButtonStyle;
	import kickflip.app.model.ButtonStyleParameter;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.*;
	import flash.geom.*;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.osflash.signals.Signal;

	public class Button extends Sprite
	{
		public static const SHAPE_NAME:String = "shape";
		public static const FILTER_NAME:String = "filter";
		public var onClick:Signal = new Signal();
		public static var defaultWidth:uint = 100;
		public static var defaultHeight:uint = 47;
		public static var defaultStyle:ButtonStyle = ButtonStyleManager.instance.defaultStyle;
		public static function clearStyle():void { defaultStyle = ButtonStyleManager.instance.defaultStyle; }
		private var fontSize:uint;
		public var text:String = "default";
		private var appWidth:uint = 100;
		private var appHeight:uint = 40;
		private var style:ButtonStyle;
		
		private var main:Sprite;
		private var base:Sprite;
		private var over:Sprite;
		private var press:Sprite;
		private var disabled:Sprite;
		private var baseTxt:TextField;
		private var overTxt:TextField;
		private var disabledTxt:TextField;
		private var pressTxt:TextField;
		
		private var rounded:uint = 6;
		
		public function Button(text:String = "", style:ButtonStyle = null, widthButton:uint = 0, heightButton:uint = 0, fontSize:uint = 0)
		{
			super();
			this.text = text;
			this.style = style == null ? defaultStyle : style;
			this.fontSize = fontSize > 0 ? fontSize : style.fontSize;
			rounded = this.style.round;
			appWidth = widthButton>0 ? widthButton : Button.defaultWidth;
			appHeight = heightButton>0 ? heightButton : Button.defaultHeight;
			
			main = new Sprite();
			base = new Sprite();
			over = new Sprite();
			press = new Sprite();
			disabled = new Sprite();
			
			addChild(main);
			main.addChild(base);
			main.addChild(over);
			main.addChild(disabled);
			main.addChild(press);
			main.mouseChildren = false;
			main.mouseEnabled = false;
			buttonMode = true;
			useHandCursor = true;
			addEventListener(Event.ADDED_TO_STAGE, initStage);
		}
		
		private function initStage(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initStage);
			display();
		}
		
		private function display():void
		{
			buildItem(base, baseTxt, style.base);
			buildItem(over, overTxt, style.over);
			buildItem(press, pressTxt, style.press);
			buildItem(disabled, disabledTxt, style.disabled);
			addListeners();
			base.alpha = 1;
		}
		
		private function buildItem(item:Sprite, itemTxt:TextField, param:ButtonStyleParameter):void
		{
			var colors:Array = param.colors;
			var alphas:Array = param.alphas;
			var ratios:Array = param.ratios;
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(appWidth, appHeight, (Math.PI / 2), 0, 0);
			
			var shape:Shape = new Shape();
			shape.name = SHAPE_NAME;
			shape.graphics.lineStyle(param.lineStyleThickness, param.lineStyleColor, param.lineStyleAlpha, true,"none", "round", "miter", 1);
			shape.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.PAD);
			shape.graphics.drawRoundRect(0, 0, appWidth, appHeight, rounded, rounded);
			shape.graphics.endFill();
			
			var filter:Shape = new Shape();
			filter.name = FILTER_NAME;
			filter.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.PAD);
			filter.graphics.drawRoundRect(0, 0, appWidth, appHeight, rounded, rounded);
			filter.graphics.endFill();
			var filterD:DropShadowFilter = new DropShadowFilter(0.5, 45, 0x000000, .5, 4, 4, 1, 3, false, false, false);
			filter.filters = [filterD];
			
			item.addChild(filter);
			item.addChild(shape);
			
			itemTxt = buildText( {
				width : appWidth,
				text : text,
				color : param.textColor
			} );
			item.addChild(itemTxt);
			item.scale9Grid = getRectangleScale();
			item.alpha = 0;
			param.drawAction(item);
		}
		
		private function buildText(config:Object):TextField
		{
			var text:String = (config.text != undefined)?config.text:"";
			var width:uint = (config.width != undefined)?config.width:120;
			var height:uint = (config.height != undefined)?config.height:22;
			var color:uint = (config.color != undefined)?config.color:0xffffff;
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.color = color;
			format.size = fontSize;
			format.align = "center";
			format.bold = false;
			var txt:TextField = new TextField();
			txt.selectable = false;
			txt.defaultTextFormat = format;
			txt.embedFonts = false;
			
			txt.text = text;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.gridFitType = GridFitType.PIXEL;
			txt.x = appWidth/2 - txt.textWidth/2 - 1;
			txt.y = appHeight/2 - txt.textHeight/2 - 1;
			txt.mouseEnabled = false;
			return txt;
		}
		
		private function addListeners():void
		{
			if(hasEventListener(MouseEvent.MOUSE_OVER))
				return;
			addEventListener(MouseEvent.MOUSE_OVER, onRollOver);
			addEventListener(MouseEvent.MOUSE_OUT, onRollOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onPress);
			addEventListener(MouseEvent.MOUSE_UP, onRelease);
		}
		
		private function removeListeners():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER, onRollOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onRollOut);
			removeEventListener(MouseEvent.MOUSE_DOWN, onPress);
			removeEventListener(MouseEvent.MOUSE_UP, onRelease);
		}
		
		private function onRollOver(evt:Event):void
		{
			var tween:TweenLite = new TweenLite(over,1,{ease:Strong.easeOut,alpha:1});
		}
		
		private function onRollOut(evt:Event):void
		{
			var tween:TweenLite = new TweenLite(over,2,{ease:Strong.easeOut,alpha:0});
			press.alpha = 0;
		}
		
		private function onPress(evt:Event):void
		{
			var tween:TweenLite = new TweenLite(press,0.5,{ease:Strong.easeOut,alpha:1});
		}
		
		private function onRelease(evt:Event):void
		{
			var tween:TweenLite = new TweenLite(press,1,{ease:Strong.easeOut,alpha:0});
			onClick.dispatch();
		}
		
		public function setText(txt:String):void
			
		{
			text = txt;
			baseTxt.text = txt;
			overTxt.text = txt;
			pressTxt.text = txt;
		}
		
		private function getRectangleScale() : Rectangle
		{
			return new Rectangle(rounded/2,rounded/2,appWidth-rounded,appHeight-rounded);
		}
		
		public function set enabled(value:Boolean):void
		{
			if(value)
			{
				addListeners();
				disabled.alpha = 0;
			} else {
				removeListeners();
				disabled.alpha = 1;
			}				
		}
	}
}
