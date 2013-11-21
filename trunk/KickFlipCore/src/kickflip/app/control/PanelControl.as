package kickflip.app.control
{
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	
	public class PanelControl extends Sprite
	{
		private var shape:Shape;
		private var filter:Shape;
		public var appWidth:uint = 400;
		public var appHeight:uint = 200;
		private var rounded:uint = 50;
		
		public function PanelControl()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, initStage);
		}
		
		private function initStage(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initStage);
			display();
		}
		
		private function display():void
		{
			var colors:Array = [0x616161, 0x2b2524];
			var alphas:Array = [1, 1];
			var ratios:Array = [0x00, 0xA0];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(appWidth, appHeight, (Math.PI / 2), 0, 0);
			
			var borderWidth:uint = appWidth+5;
			var borderHeight:uint = appHeight+5;
			var border:Shape = new Shape();
			border.graphics.lineStyle(7, 0x5d4316, 0.5, true, LineScaleMode.NONE, CapsStyle.ROUND, JointStyle.ROUND, 1);
			border.graphics.beginFill(0x555555,0);
			border.graphics.drawRoundRect(0, 0, borderWidth, borderHeight, rounded, rounded);
			border.graphics.endFill();

			shape = new Shape();
			shape.graphics.lineStyle(0, 0x957f5b, 0, true, "none", "round", "miter", 1);
			shape.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.PAD);
			shape.graphics.drawRoundRect(0, 0, appWidth, appHeight, rounded, rounded);
			shape.graphics.endFill();
			shape.blendMode = BlendMode.MULTIPLY;
			
			filter = new Shape();
			filter.graphics.lineStyle(0, 0x957f5b, 0, true,"none", "round", "miter", 1);
			filter.graphics.beginFill(0x555555);
			filter.graphics.drawRoundRect(0, 0, appWidth, appHeight, rounded, rounded);
			filter.graphics.endFill();
			var filterD:DropShadowFilter = new DropShadowFilter(10, 80, 0x000000, 1, 15, 15, 1, 3, false, true, true);
			filter.filters = [filterD];
			
			addChild(filter);
			addChild(shape);
			addChild(border);
			border.x -= 3;
			border.y -= 3;
		}

	}
}