package flipviw.app.control
{
	import flipviw.app.AppGlobal;
	
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
	
	/**
	 * @author Francisco Rosales
	 * @site http://www.nessy.com.ar
	 */
	public class CoolButton extends Sprite
	{
		public var onClick:Signal = new Signal();
		public static var defaultWidth:uint = 100;
		public static var defaultHeight:uint = 40;
		private var fontSize:uint;
		public var text:String = "default";
		private var appWidth:uint = 100;
		private var appHeight:uint = 40;
		
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
		
		public function CoolButton(text:String = "", widthButton:uint = 0, heightButton:uint = 0, fontSize:uint = 16)
		{
			super();
			this.text = text;
			this.fontSize = fontSize;
			appWidth = widthButton>0 ? widthButton : CoolButton.defaultWidth;
			appHeight = heightButton>0 ? heightButton : CoolButton.defaultHeight;

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
			addEventListener(Event.ADDED_TO_STAGE, InitStage);
		}
		
		private function InitStage(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,InitStage);
			display();
		}
		
		private function display():void
		{
			buildBase();
			buildOver();
			buildDisabled();
			buildPress();
			addListeners();
		}
		
		private function buildBase():void
		{
			var colors:Array = [ 0xffffff, 0xa9b8c3];
			var alphas:Array = [ 1, 1 ];
			var ratios:Array = [ 0x00, 0xFF ];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(appWidth, appHeight, (Math.PI / 2), 0, 0);

			base.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.PAD);
			base.graphics.drawRoundRect(0, 0, appWidth, appHeight, rounded, rounded);
			base.graphics.endFill();

			var filterD:DropShadowFilter = new DropShadowFilter(0.5, 45, 0x000000, .5, 4, 4, 1, 3, false, false, false);
			base.filters = [filterD];
			baseTxt = buildText( {
				width : appWidth,
				text : text,
				color : 0x1f416c
			} );
			base.addChild(baseTxt);
			base.scale9Grid = getRectangleScale();
		}

		private function buildText(config:Object):TextField
		{
			var text:String = (config.text != undefined)?config.text:"";
			var width:uint = (config.width != undefined)?config.width:120;
			var height:uint = (config.height != undefined)?config.height:22;
			var color:uint = (config.color != undefined)?config.color:0xffffff;
			var format:TextFormat = new TextFormat();
			format.font = AppGlobal.FONT_TYPE;
			format.color = color;
			format.size = fontSize;
			format.align = "center";
			format.bold = true;
			var txt:TextField = new TextField();
			txt.selectable = false;
			txt.defaultTextFormat = format;

			txt.text = text;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.gridFitType = GridFitType.PIXEL;
			txt.x = appWidth/2 - txt.textWidth/2 - 1;
			txt.y = appHeight/2 - txt.textHeight/2 - 1;
			txt.mouseEnabled = false;
			return txt;
		}
		
		private function buildOver():void
		{
			var colors:Array = [ 0x7fb2ea, 0x2267d1, 0x1a64c1];
			var alphas:Array = [ 1, 1, 1 ];
			var ratios:Array = [ 0x00, 0xB5, 0xFF ];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(appWidth, appHeight, (Math.PI / 2), 0, 0);
			over.graphics.lineStyle(0, 0xD8DAD6, 1, true,"none", "round", "miter", 1);
			over.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.PAD);
			over.graphics.drawRoundRect(0, 0, appWidth, appHeight, rounded, rounded);
			over.graphics.endFill();
			var filterB:BevelFilter = new BevelFilter(1, 45, 0xffffff, 1, 0x5c5c5c, .8, 2, 2, 2, 3, "inner", false);
			var filterG1:GlowFilter = new GlowFilter(0x3192ff, .8, 2, 2, 1, 3, false, false);
			var filterG2:GlowFilter = new GlowFilter(0xffffff, 1, 10, 10, 1, 3, false, false);
			over.filters = [filterB,filterG1];
			overTxt = buildText( {
				width : appWidth,
				text : text,
				color : 0xffffff
			} );
			over.addChild(overTxt);
			over.alpha = 0;
			over.scale9Grid = getRectangleScale();
		}
		
		private function buildDisabled():void
		{
			var colors:Array = [ 0xDADADA, 0x999999];
			var alphas:Array = [ 1, 1 ];
			var ratios:Array = [ 0x00, 0xFF ];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(appWidth, appHeight, (Math.PI / 2), 0, 0);
			disabled.graphics.lineStyle(0, 0x999999, 1, true,"none", "round", "miter", 1);
			disabled.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.PAD);
			disabled.graphics.drawRoundRect(0, 0, appWidth, appHeight, rounded, rounded);
			disabled.graphics.endFill();
			disabledTxt = buildText( {
				width : appWidth,
				text : text,
				color : 0x777777
			} );
			disabled.addChild(disabledTxt);
			disabled.alpha = 0;
			disabled.scale9Grid = getRectangleScale();
		}
		
		private function buildPress():void
		{
			var colors:Array = [ 0xA8A8AA, 0x616061, 0x282928];
			var alphas:Array = [ 1, 1, 1 ];
			var ratios:Array = [ 0x00, 0xB5, 0xFF ];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(appWidth, appHeight, (Math.PI / 2), 0, 0);
			press.graphics.lineStyle(0, 0x188CF8, 1, true,"none", "round", "miter", 1);
			press.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.PAD);
			press.graphics.drawRoundRect(0, 0, appWidth, appHeight, rounded, rounded);
			press.graphics.endFill();
			var filterB:BevelFilter = new BevelFilter(1, 45, 0xffffff, 1, 0x5c5c5c, 1, 2, 2, 2, 3, "inner", false);
			var filterG1:GlowFilter = new GlowFilter(0x188CF8, 1, 2, 2, 1, 3, false, false);
			var filterG2:GlowFilter = new GlowFilter(0xffffff, 1, 5, 5, 1, 3, false, false);
			press.filters = [filterB,filterG1,filterG2];
			pressTxt = buildText( {
				width : appWidth,
				text : text,
				color : 0xDCDCDC
			} );
			press.addChild(pressTxt);
			press.alpha = 0;
			press.scale9Grid = getRectangleScale();
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
		
		public function setDimension(widthButton:uint, heightButton:uint):void
		{
			appWidth = (widthButton < 20)?20:widthButton;
			appHeight = (heightButton < 10)?10:heightButton;
			base.width = appWidth;
			base.height = appHeight;
			over.width = appWidth;
			over.height = appHeight;
			press.width = appWidth;
			press.height = appHeight;
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
