package flippub.app.manager
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import flippub.app.util.Utils;

	public class ExplodeFxManager
	{
		private var pixelContainer:Sprite;
		private var pixels:Sprite;

		public function ExplodeFxManager()
		{
		}

		private function explode():void
		{  
			for(var i:int = 0; i<pixels.numChildren; i++)
			{  
				var pix:ExplodePixel = ExplodePixel(pixels.getChildAt(i));
				var xdest:int = Utils.random(-20,70);  
				var ydest:int = Utils.random(-20,100);
				var complete:Function = null;
				if(i==0)
				{
					complete = function():void
					{
						pixelContainer.parent.removeChild(pixelContainer);
					}
				}
				TweenMax.to(pix, 2, {
					x:xdest,
					y:ydest,
					alpha:0,
					rotation:90,
					ease:Circ.easeOut,
					onComplete:complete
				});
			}  
		}
		
		public function getStarExplode(star:DisplayObject):Sprite
		{
			pixelContainer = new Sprite();
			
			var bounds:Rectangle = star.getBounds(star);
			var matrix:Matrix = new Matrix();
			matrix.translate(-bounds.x, bounds.y);
			
			var pixelBMP:BitmapData = new BitmapData(star.width, star.height, true, 0xff0000);
			pixelBMP.draw(star,matrix);
			
			pixels = new Sprite();
			var pixel32:uint;
			var starWidth:int = star.width;
			var starHeight:int = star.height;
			var starY:Number = star.height/2 - starHeight/2;
			for(var py:int = starY; py<starHeight; py+=2)
			{
				for(var px:int = 0; px<starWidth; px+=2)
				{  
					pixel32 = pixelBMP.getPixel32(px, py);
					if(pixel32>0)
					{
						var pixel:ExplodePixel = new ExplodePixel();
						pixel.setUpPixel(pixel32);
						pixel.x = px;
						pixel.y = py;
						pixels.addChild(pixel);
					}
				}
			}
			pixels.x -= 10;
			pixelContainer.addChild(pixels);
			starExplode();
			return pixelContainer;
		}
		
		private function starExplode():void
		{  
			for(var i:int = 0; i<pixels.numChildren; i++)
			{  
				var pix:ExplodePixel = ExplodePixel(pixels.getChildAt(i));
				var xdest:int = Utils.random(-20,100);  
				var ydest:int = Utils.random(-20,100);
				var complete:Function = null;
				if(i==0)
				{
					complete = function():void
					{
						if(pixelContainer.parent)
							pixelContainer.parent.removeChild(pixelContainer);
					}
				}
				TweenMax.to(pix, 2, {
					x:xdest,
					y:ydest,
					alpha:0,
					rotation:90,
					ease:Circ.easeOut,
					onComplete:complete
				});
			}  
		}

		public function wordExplode(item:DisplayObject,complete:Function):Sprite
		{
			pixelContainer = new Sprite();
			
			var bounds:Rectangle = item.getBounds(item);
			var matrix:Matrix = new Matrix();
			matrix.translate(-bounds.x, bounds.y);
			
			var pixelBMP:BitmapData = new BitmapData(item.width, item.height, true, 0xff0000);
			pixelBMP.draw(item,matrix);
			
			pixels = new Sprite();
			var pixel32:uint;
			var itemWidth:int = item.width;
			var itemHeight:int = item.height;
			var itemY:Number = item.height/2 - itemHeight/2;
			for(var py:int = itemY; py<itemHeight; py+=1)
			{
				for(var px:int = 0; px<itemWidth; px+=1)
				{  
					pixel32 = pixelBMP.getPixel32(px, py);
					if(pixel32>0)
					{
						var pixel:ExplodePixel = new ExplodePixel();
						pixel.setUpPixelSameColor(0xffffff);
						pixel.x = px;
						pixel.y = py;
						pixels.addChild(pixel);
					}
				}
			}
			pixelContainer.addChild(pixels);
			startWordExplode(complete);
			return pixelContainer;
		}

		private function startWordExplode(onComplete:Function):void
		{  
			for(var i:int = 0; i<pixels.numChildren; i++)
			{  
				var pix:ExplodePixel = pixels.getChildAt(i) as ExplodePixel;
				var xdest:int = pix.x + Utils.random(-50,50);  
				var ydest:int = pix.y + Utils.random(-50,50);
				var complete:Function = null;
				if(i==0)
				{
					complete = function():void
					{
						if(pixelContainer.parent)
							pixelContainer.parent.removeChild(pixelContainer);
						onComplete();
					}
				}
				TweenMax.to(pix, 2, {
					x:xdest,
					y:ydest,
					alpha:0,
					rotation:90,
					ease:Circ.easeOut,
					onComplete:complete
				});
			}  
		}
	}
}