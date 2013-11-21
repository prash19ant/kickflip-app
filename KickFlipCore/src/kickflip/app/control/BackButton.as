package kickflip.app.control
{
	import com.dncompute.graphics.ArrowStyle;
	import com.dncompute.graphics.GraphicsUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import kickflip.app.AppGlobal;
	
	public class BackButton extends Sprite
	{
		public static var EVENT_CLICK:String = "COOLBUTTON_EVENT_CLICK";
		private var controlWidth:uint = 40;
		private var controlHeight:uint = 40;
		
		private var main:Sprite = new Sprite();
		private var base:Sprite = new Sprite();
		private var over:Sprite = new Sprite();
		private var press:Sprite = new Sprite();
		private var rounded:uint = 60;

		public function BackButton()
		{
			super();
			addChild(main);
			main.addChild(base);
			main.addChild(over);
			main.addChild(press);
			addEventListener(Event.ADDED_TO_STAGE, InitStage);
		}
		
		private function InitStage(evt:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,InitStage);
			Display();
		}
		
		private function Display():void {
			buildBase();
			buildOver();
			buildPress();
			addListeners();
		}
		
		private function build(item:Sprite, colors:Array):void
		{
			var alphas:Array = [ 1, 1, 1 ];
			var ratios:Array = [ 0x00, 0xB5, 0xFF ];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(controlWidth, controlHeight, (Math.PI / 2), 0, 0);
			item.graphics.lineStyle(6, 0xffffff);
			item.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.PAD);
			item.graphics.drawRoundRect(0, 0, controlWidth, controlHeight, rounded, rounded);
			item.graphics.endFill();
			
			var filterD:DropShadowFilter = new DropShadowFilter(5, 50, 0xa39a95, .7, 4, 4, 1, 3, false, false, false);
			item.filters = [filterD];
			item.addChild(getArrow());
			item.alpha = 0;
		}
		
		private function getArrow():Shape
		{
			var style:ArrowStyle = new ArrowStyle();
			style.headLength = 10;
			style.headWidth = 16;
			style.shaftPosition = 0.3;
			style.shaftThickness = 1;
			style.edgeControlPosition = 0.5;
			style.edgeControlSize = 0.5;
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(5,0xffffff);
			shape.graphics.beginFill(0xffffff);
			GraphicsUtil.drawArrow(shape.graphics,
				new Point(29,20),
				new Point(10,20),
				style);
			return shape;
		}
		
		private function buildBase():void
		{
			build(base, [0xa5bfd4, 0x58768f, 0x2c353e], 0xffffff);
			base.alpha = 1;
		}
		
		private function buildOver() : void
		{
			build(over, [0x7fb2ea, 0x2267d1, 0x1a64c1], 0xffffff);
		}
		
		private function buildPress() : void
		{
			build(press, [0xA8A8AA, 0x616061, 0x282928], 0xDCDCDC);
		}
		
		private function buildText(config:Object) : TextField
		{
			var text:String = (config.text != undefined)?config.text:"";
			var width:uint = (config.width != undefined)?config.width:120;
			var height:uint = (config.height != undefined)?config.height:18;
			var color:uint = (config.color != undefined)?config.color:0xffffff;
			var format:TextFormat = new TextFormat();
			format.font = AppGlobal.FONT_TYPE;
			format.color = color;
			format.align = "center";
			var txt:TextField = new TextField();
			txt.selectable = false;
			txt.defaultTextFormat = format;
			txt.autoSize = TextFieldAutoSize.CENTER;
			txt.text = text;
			return txt;
		}
		
		private function addListeners():void
		{
			press.addEventListener(MouseEvent.MOUSE_OVER, onRollOver);
			press.addEventListener(MouseEvent.MOUSE_OUT, onRollOut);
			press.addEventListener(MouseEvent.MOUSE_DOWN, onPress);
			press.addEventListener(MouseEvent.MOUSE_UP, onRelease);
		}
		
		private function removeListeners():void
		{
			press.removeEventListener(MouseEvent.MOUSE_OVER, onRollOver);
			press.removeEventListener(MouseEvent.MOUSE_OUT, onRollOut);
			press.removeEventListener(MouseEvent.MOUSE_DOWN, onPress);
			press.removeEventListener(MouseEvent.MOUSE_UP, onRelease);
		}
		
		private function onRollOver(evt:Event):void {
			var tween:TweenLite = new TweenLite(over,1,{ease:Strong.easeOut,alpha:1});
		}
		
		private function onRollOut(evt:Event):void {
			var tween:TweenLite = new TweenLite(over,2,{ease:Strong.easeOut,alpha:0});
			press.alpha = 0;
		}
		
		private function onPress(evt:Event):void {
			var tween:TweenLite = new TweenLite(press,0.5,{ease:Strong.easeOut,alpha:1});
		}
		
		private function onRelease(evt:Event):void {
			var tween:TweenLite = new TweenLite(press,1,{ease:Strong.easeOut,alpha:0});
			dispatchEvent(new Event(EVENT_CLICK));
		}
		
		public function dispose():void
		{
			removeListeners();
		}
	}
}
