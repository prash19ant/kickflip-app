package flipviw.app.control
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	
	public class ProgressIndicatorControl extends Sprite
	{
		private var controlWidth:uint = 42;
		private var controlHeight:uint = 30;
		private var green:Sprite;
		private var red:Sprite;
		private var gap:uint = 2;
		private var tween:TweenLite;
		
		public function ProgressIndicatorControl()
		{
			super();
			green = new Sprite();
			addChild(green);
			red = new Sprite();
			addChild(red);
			
			buildBase(green, 0x00ff00);
			buildBase(red, 0xff0000);
			green.alpha = 0;
			red.alpha = 0;
		}
		
		private function buildBase(item:Sprite, color:uint):void
		{
			item.graphics.clear();
			item.graphics.beginFill(color);
			item.graphics.drawRoundRect(gap, gap, controlWidth-gap, controlHeight-gap, 5, 5);
			item.graphics.endFill();
			var glowF:GlowFilter = new GlowFilter(color, 0.7, 9, 9, 3, 6);
			item.filters = [glowF];
		}
		
		public function showGreen():void
		{
			show(green);
		}
		
		public function showRed():void
		{
			show(red);
		}
		
		private function show(item:Sprite):void
		{
			if(tween!=null)
			{
				if(tween.active)
				{
					tween.kill();
					tween.target.alpha = 0;
				}
			}
			tween = new TweenLite(item, 2, {
				ease:Strong.easeOut,
				alpha:1,
				onComplete:function():void{
					tween.reverse();
				}
			});
		}
	}
}