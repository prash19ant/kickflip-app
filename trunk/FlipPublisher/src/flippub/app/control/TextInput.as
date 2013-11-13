package flippub.app.control
{
	import flippub.app.AppGlobal;
	import flippub.app.manager.FontManager;
	import cesvi.quiz.manager.InputStyleManager;
	import cesvi.quiz.model.InputStyle;
	import cesvi.quiz.model.InputStyleParameter;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.filters.*;
	import flash.geom.*;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import mx.utils.StringUtil;
	
	import org.osflash.signals.Signal;
	
	public class TextInput extends Sprite
	{
		public static var defaultWidth:uint = 160;
		public static var defaultHeight:uint = 40;
		public static var defaultStyle:InputStyle = InputStyleManager.instance.defaultStyle;
		public static function clearStyle():void { defaultStyle = InputStyleManager.instance.defaultStyle; }
		private var style:InputStyle;
		private var _text:String = "";
		private var appWidth:uint = 100;
		private var appHeight:uint = 40;
		private var rounded:uint = 0;
		private var main:Sprite;
		private var base:Sprite;
		private var over:Sprite;
		private var invalid:Sprite;
		public var textInput:TextField;
		private var gapTxt:uint = 1;
		public var maxChars:uint = 400;
		public var displayAsPassword:Boolean = false;
		public var onFocusIn:Signal = new Signal();
		public var onFocusOut:Signal = new Signal();
		
		public function TextInput(style:InputStyle = null, widthInput:uint = 0, heightInput:uint = 0)
		{
			this.style = style == null ? defaultStyle : style;
			appWidth = (widthInput>0)?widthInput:defaultWidth;
			appHeight = (heightInput>0)?heightInput:defaultHeight;
			rounded = style.inputRound;
			
			main = new Sprite();
			base = new Sprite();
			over = new Sprite();
			invalid = new Sprite();

			addChild(main);
			main.addChild(base);
			main.addChild(over);
			main.addChild(invalid);
		}
		
		public function display():void
		{
			buildItem(base, style.base);
			buildItem(over, style.over);
			buildItem(invalid, style.invalid);
			
			buildTextInput();
			addListeners();
			base.alpha = 1;
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

		private function buildTextInput():void
		{
			textInput = buildText( {
				text : _text
			} );
			var filterD:DropShadowFilter = new DropShadowFilter(0.5, 45, 0x000000, .5, 4, 4, 1, 3, false, false, false);
			textInput.filters = [filterD];
			main.addChild(textInput);
			textInput.x = gapTxt;
		}
		
		private function buildText(config:Object) : TextField
		{
			var text:String = (config.text != undefined)?config.text:"";
			var color:uint = (config.color != undefined)?config.color:0xffffff;

			var txtWidth:uint = appWidth;
			txtWidth = txtWidth-gapTxt*2;
			
			var format:TextFormat = new TextFormat();
			format.font = FontManager.instance.TradeGothicLgCn;
			format.color = style.textColor;
			format.size = style.inputFontSize;
			format.align = "left";
			
			var txt:TextField = new TextField();
			txt.embedFonts = true;
			txt.defaultTextFormat = format;
			txt.type = TextFieldType.INPUT;
			txt.displayAsPassword = displayAsPassword;
			txt.text = text;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.width = txtWidth;
			txt.height = appHeight;
			txt.gridFitType = GridFitType.PIXEL;
			txt.maxChars = maxChars;
			txt.x = 0;
			txt.y = appHeight/2 - txt.textHeight/2 - 1;
			return txt;
		}
		
		public function get text():String
		{
			var txt:String = !StringUtil.isWhitespace(textInput.htmlText) ? textInput.htmlText : textInput.text;
			return txt;
		}
		public function set text(value:String):void
		{
			_text = value;
		}
		
		private function addListeners():void
		{
			textInput.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
			textInput.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
		}
		
		private function onRollOver(evt:Event):void 
		{
			var tween:TweenLite = new TweenLite(over,0.5,{ease:Strong.easeOut,alpha:1});
		}
		
		private function onRollOut(evt:Event):void 
		{
			var tween:TweenLite = new TweenLite(over,0.5,{ease:Strong.easeOut,alpha:0});
		}
		
		private function focusInHandler(evt:Event):void 
		{
			var tween:TweenLite = new TweenLite(over,1,{ease:Strong.easeOut,alpha:1});
			onFocusIn.dispatch();
		}
		
		private function focusOutHandler(evt:Event):void 
		{
			var tween:TweenLite = new TweenLite(over,1,{ease:Strong.easeOut,alpha:0});
			onFocusOut.dispatch();
		}
		
		public function setText(txt:String):void
		{
			text = txt;
			textInput.text = txt;
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
		
		public function set invalided(value:Boolean):void
		{
			var alfa:uint = 1;
			if(!value)
			{
				alfa = 0;
			}				
			var tween:TweenLite = new TweenLite(invalid,0.5,{ease:Strong.easeOut,alpha:alfa});
		}
	}
}