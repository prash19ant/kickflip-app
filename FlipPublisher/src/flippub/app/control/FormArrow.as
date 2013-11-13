package flippub.app.control
{
	import flippub.app.manager.ButtonStyleManager;
	import flippub.app.model.ButtonStyle;
	import flippub.app.model.ButtonStyleParameter;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	
	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	
	import org.osflash.signals.Signal;

	public class FormArrow extends Sprite
	{
		[Embed(source="./../asset/formArrowRight.png")]
		private static var formArrowRightClass:Class;

		public static const SHAPE_NAME:String = "shape";
		public static const FILTER_NAME:String = "filter";
		public static const RIGHT_SENSE:uint = 0;
		public static const LEFT_SENSE:uint = 1;
		public var onClick:Signal = new Signal();
		public static var defaultStyle:ButtonStyle = ButtonStyleManager.instance.defaultStyle;
		private var appWidth:uint = 75;
		private var appHeight:uint = 75;
		private var main:Sprite;
		private var base:Sprite;
		private var over:Sprite;
		private var press:Sprite;
		private var style:ButtonStyle;
		private var rounded:uint = 6;
		private var sense:uint = RIGHT_SENSE; 

		public function FormArrow(style:ButtonStyle = null, sense:uint = RIGHT_SENSE)
		{
			this.style = style == null ? defaultStyle : style;
			this.sense = sense;
			main = new Sprite();
			base = new Sprite();
			over = new Sprite();
			press = new Sprite();
			
			addChild(main);
			main.addChild(base);
			main.addChild(over);
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
			buildItem(base, style.base);
			buildItem(over, style.over);
			buildItem(press, style.press);
			addListeners();
			base.alpha = 1;
		}
		
		private function buildItem(item:Sprite, param:ButtonStyleParameter):void
		{
			var shape:Shape = new Shape();
			shape.name = SHAPE_NAME;
			shape.graphics.beginFill(param.colors[0], 0);
			shape.graphics.drawRoundRect(0, 0, appWidth, appHeight, rounded, rounded);
			shape.graphics.endFill();
			
			var filter:Shape = new Shape();
			filter.name = FILTER_NAME;
			filter.graphics.beginFill(param.colors[0], 0);
			filter.graphics.drawRoundRect(0, 0, appWidth, appHeight, rounded, rounded);
			filter.graphics.endFill();
			var filterD:DropShadowFilter = new DropShadowFilter(0.5, 45, 0x000000, .5, 4, 4, 1, 3, false, false, false);
			filter.filters = [filterD];
			
			var arrow:Bitmap = new formArrowRightClass();
			if(sense == LEFT_SENSE)
			{
				arrow.scaleX = -arrow.scaleX;
				arrow.x += arrow.width;
			}
			
			item.addChild(filter);
			item.addChild(shape);
			item.addChild(arrow);
			
			item.alpha = 0;
			param.drawAction(item);
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

		public function set enabled(value:Boolean):void
		{
			if(value)
			{
				addListeners();
				base.alpha = 1;
			} else {
				removeListeners();
				base.alpha = 0.1;
				over.alpha = 0;
				press.alpha = 0;
			}				
		}
	}
}