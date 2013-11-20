package flipviw.app.manager
{
	import flash.display.Sprite;
	
	import flipviw.app.util.Utils;
	
	public class ExplodePixel extends Sprite
	{
		public function ExplodePixel()
		{
			super();
		}

		public function setUpPixel(color:uint):void
		{
			var whichColor:uint = (Utils.random(0,2)>1)?color:0x4C1112;
			graphics.beginFill(whichColor);
			if(Utils.random(0,2)>1)
			{
				graphics.drawCircle(0,0,1)
			} else {
				graphics.drawRect(0,0,Utils.random(1,4),Utils.random(1,4));
			}
			graphics.endFill();
		}

		public function setUpPixelSameColor(color:uint):void
		{
			graphics.beginFill(color);
			graphics.drawCircle(0,0,1)
			graphics.endFill();
		}
	}
}