package flippub.app.control
{
	import cesvi.quiz.manager.InputStyleManager;
	import cesvi.quiz.model.InputStyle;
	import cesvi.quiz.model.InputStyleParameter;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filters.*;
	import flash.geom.*;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import org.osflash.signals.Signal;

	public class CheckBoxControl extends Sprite
	{
		public static var defaultWidth:uint = 40;
		public static var defaultHeight:uint = 40;
		public static var defaultStyle:InputStyle = InputStyleManager.instance.defaultStyle;
		public static function clearStyle():void { defaultStyle = InputStyleManager.instance.defaultStyle; }

		private var style:InputStyle;
		private var _text:String = "";
		public var appWidth:uint = 40;
		public var appHeight:uint = 30;
		private var rounded:uint = 6;
		private var bulletWidth:uint = 8;
		public var onClick:Signal = new Signal();

		private var base:Sprite;
		private var over:Sprite;
		private var press:Sprite;
		private var invalid:Sprite;
		private var bullet:Sprite;

		private var _checked:Boolean = false;
		public function get checked():Boolean { return _checked; }
		public function set checked(value:Boolean):void
		{ 
			_checked = value;
			new TweenLite(bullet, 1, {ease:Strong.easeOut, alpha:_checked ? 0 : 1});
		}

		public function CheckBoxControl(style:InputStyle = null)
		{
			this.style = style == null ? defaultStyle : style;
			base = new Sprite();
			over = new Sprite();
			press = new Sprite();
			invalid = new Sprite();
			bullet = new Sprite();
			addChild(base);
			addChild(over);
			addChild(press);
			addChild(invalid);
			addChild(bullet);
		}
		
		public function display():void
		{
			buildItem(base, style.base);
			buildItem(over, style.over);
			buildItem(press, style.press);
			buildItem(invalid, style.invalid);

			buildBullet();
			addListeners();
			base.alpha = 1;
		}
		
		public function display2():void
		{
			buildBase();
			buildOver();
			buildPress();
			buildInvalid();
			buildBullet();
			addListeners();
		}
		
		private function buildItem(item:Sprite, param:InputStyleParameter):void
		{
			var colors:Array = param.colors;
			var alphas:Array = param.alphas;
			var ratios:Array = param.ratios;
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(appWidth, appHeight, (Math.PI / 2), 0, 0);
			
			item.graphics.lineStyle(param.lineStyleThickness, param.lineStyleColor, param.lineStyleAlpha, true,"none", "round", "miter", 1);
			item.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.PAD);
			item.graphics.drawRoundRect(0, 0, appWidth, appHeight, rounded, rounded);
			item.graphics.endFill();
			
			param.drawAction(item);
			item.mouseEnabled = false;
			item.mouseChildren = false;
			item.alpha = 0;
		}

		private function buildBase():void
		{
			var colors:Array = [0xffffff, 0xa9b8c3, 0x999999];
			var alphas:Array = [1, 1, 1 ];
			var ratios:Array = [0x30, 0xF0, 0xFF];
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(appWidth, appHeight, (Math.PI / 2), 0, 0);
			
			base.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.PAD);
			base.graphics.drawRoundRect(0, 0, appWidth, appHeight, rounded, rounded);
			base.graphics.endFill();

			var filterD:DropShadowFilter = new DropShadowFilter(0.5, 45, 0x000000, .5, 4, 4, 1, 3, false, false, false);
			base.filters = [filterD];
			base.mouseChildren = false;
			base.mouseEnabled = false;
		}
		
		private function buildInvalid():void
		{
			var colors:Array = [0xF6FAD2, 0xCACCB8];
			var alphas:Array = [0.7, 0.7];
			var ratios:Array = [0x00, 0xFF];
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(appWidth, appHeight, (Math.PI / 2), 0, 0);
			
			invalid.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.PAD);
			invalid.graphics.drawRoundRect(0, 0, appWidth, appHeight, rounded, rounded);
			invalid.graphics.endFill();
			
			var filterD:DropShadowFilter = new DropShadowFilter(0.5, 45, 0xE01B1B, .5, 4, 4, 1, 3, false, false, false);
			var filterGlow:GlowFilter = new GlowFilter(0xE01B1B);
			
			invalid.filters = [filterGlow];
			invalid.alpha = 0;
			invalid.mouseEnabled = false;
			invalid.mouseChildren = false;
		}
		
		private function buildOver():void
		{
			var colors:Array = [0xF6FAD2, 0xCACCB8];
			var alphas:Array = [0.5, 0.5];
			var ratios:Array = [0x00, 0xFF];
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(appWidth, appHeight, (Math.PI / 2), 0, 0);
			over.graphics.lineStyle(0, 0xD8DAD6, 100, true,"none", "round", "miter", 1);
			over.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.PAD);
			over.graphics.drawRoundRect(0, 0, appWidth, appHeight, rounded, rounded);
			over.graphics.endFill();
			
			var filterGlow:GlowFilter = new GlowFilter(0xEFFA89, 0.5);
			over.filters = [ filterGlow ];
			
			over.mouseEnabled = false;
			over.mouseChildren = false;
			over.alpha = 0;
		}
		
		private function buildPress():void
		{
			var colors:Array = [ 0xf9f2c3, 0xeee2b7];
			var alphas:Array = [ 1, 1 ];
			var ratios:Array = [ 0x80, 0xFF ];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(appWidth, appWidth, (Math.PI / 2), 0, 0);
			
			press.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.PAD);
			press.graphics.drawRoundRect(0, 0, appWidth, appHeight, rounded, rounded);
			press.graphics.endFill();

			var filterD:DropShadowFilter = new DropShadowFilter(1, 80, 0x000000, 0.3, 4, 4, 1, 3, true, false, false);
			var filterB:BevelFilter = new BevelFilter(1, 45, 0xffffff, 1, 0x5c5c5c, .8, 4, 4, 2, 3, BitmapFilterType.OUTER, false);
			var filterG1:GlowFilter = new GlowFilter(0xf9f2c3, 1, 10, 10, 2, 2, false, false);
			var filterG2:GlowFilter = new GlowFilter(0xffffff, 0.8, 6, 6, 2, 3, false, false);
			press.filters = [filterD, filterB];
			press.mouseChildren = false;
			press.mouseEnabled = false;
			press.alpha = 0;
		}
		
		private function buildBullet():void
		{
			var colors:Array = [ 0xffffff, 0xeaf3f5];
			var alphas:Array = [ 1, 1 ];
			var ratios:Array = [ 0x00, 0xFF ];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(bulletWidth, bulletWidth, (Math.PI / 2), 0, 0);
			
			bullet.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.PAD);
			bullet.graphics.drawCircle(appWidth/2, appWidth/2, bulletWidth);
			bullet.graphics.endFill();
			
			var filterD:DropShadowFilter = new DropShadowFilter(1, 80, 0x000000, 0.4, 4, 4);
			var filterG:GlowFilter = new GlowFilter(0x999999, 1, 2, 2, 2, 1, true);
			bullet.filters = [filterG, filterD];
			bullet.mouseChildren = false;
			bullet.mouseEnabled = false;
			bullet.alpha = 0;
		}

		private function onPress(evt:Event):void
		{
			new TweenLite(press, 0.5, {ease:Strong.easeOut, alpha:1});
		}

		private function onRollOver(evt:Event):void 
		{
			var tween:TweenLite = new TweenLite(over,0.5,{ease:Strong.easeOut,alpha:1});
		}
		
		private function onRollOut(evt:Event):void
		{
			new TweenLite(over,2,{ease:Strong.easeOut,alpha:0});
			press.alpha = 0;
		}
		
		private function onRelease(evt:Event):void
		{
			new TweenLite(press, 1,{ease:Strong.easeOut,alpha:0});
			new TweenLite(bullet, 1, {ease:Strong.easeOut, alpha:_checked ? 0 : 1});
			_checked = !_checked;
			onClick.dispatch();
		}

		
		public function setDimension(widthButton:uint, heightButton:uint):void
		{
			appWidth = (widthButton < 20)?20:widthButton;
			appHeight = (heightButton < 10)?10:heightButton;
			base.width = appWidth;
			base.height = appHeight;
			over.width = appWidth;
			over.height = appHeight;
		}
		
		private function filterBevel():BitmapFilter {
			var highlightColor:Number = 0x999999;
			var highlightAlpha:Number = 0.6;
			var shadowColor:Number    = 0x999999;
			var shadowAlpha:Number    = 0.6;
			var blur:Number           = 3;
			var quality:Number        = BitmapFilterQuality.MEDIUM;
			var type:String           = BitmapFilterType.INNER;
			var knockout:Boolean      = false;
			return new BevelFilter(
				2, 45,
				highlightColor, highlightAlpha,
				shadowColor, shadowAlpha,
				blur, blur,
				1, quality, type, knockout);
		}
		
		public function set invalided(value:Boolean):void
		{
			var alfa:uint = 1;
			if(!value)
			{
				alfa = 0;
			}				
			var tween:TweenLite = new TweenLite(invalid,0.5,{ease:Strong.easeOut,alpha:alfa});
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
	}
}