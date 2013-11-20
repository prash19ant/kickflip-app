package flipviw.app.util
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class GlideTransition
	{
		private static var target1:Sprite;
		private static var target2:Sprite;
		private static var target1Bmp:Bitmap;
		private static var target2Bmp:Bitmap;
		private static var targetParent:DisplayObjectContainer;
		private static var processFilters:Boolean = true;
		
		public function GlideTransition()
		{
		}
		
		public static function start(sprite1:Sprite, sprite2:Sprite, reverse:Boolean = false, onComplete:Function = null):void
		{
			target1 = sprite1;
			target2 = sprite2;
			targetParent = target2.parent;
			
			var rectangle:Rectangle;
			
			rectangle = getDisplayObjectRectangle(target1, processFilters);
			var bitmapData:BitmapData = new BitmapData(rectangle.width, rectangle.height, !processFilters);
			bitmapData.draw(target1);
			target1Bmp = new Bitmap(bitmapData);
			
			rectangle = getDisplayObjectRectangle(target2, processFilters);
			var bitmapData2:BitmapData = new BitmapData(rectangle.width, rectangle.height, !processFilters);
			bitmapData2.draw(target2);
			target2Bmp = new Bitmap(bitmapData2);
			
			targetParent.addChild(target2Bmp);
			targetParent.addChild(target1Bmp);
			target1Bmp.x = sprite1.x;
			target1Bmp.y = sprite1.y;
			target2Bmp.x = sprite2.x;
			target2Bmp.y = sprite2.y;
			
			var complete:Function = function():void
			{
				target2.visible = true;
				if(onComplete!=null)
					onComplete();
			};
			if(reverse)
			{
				glideHideEffect(target1Bmp, 1, 1.5, 1, 0);
				glideHideEffect(target2Bmp, 0.75, 1, 0, 1, complete);
			} else {
				glideHideEffect(target1Bmp, 1, 0.75, 1, 0);
				glideHideEffect(target2Bmp, 1.5, 1, 0, 1, complete);
			}
		}
		
		private static function glideHideEffect(sprite:Bitmap, startScale:Number = 0.5, endScale:Number = 1, startAlpha:Number = 1, endAlpha:Number = 0.5, fxComplete:Function = null):void
		{
			var originalW:Number = sprite.width;
			var originalH:Number = sprite.height;
			sprite.scaleX = endScale;
			sprite.scaleY = endScale;
			
			var posx:int = sprite.x - int(originalW*endScale-originalW)/2;
			var posy:int = sprite.y - int(originalH*endScale-originalH)/2;
			
			sprite.scaleX = startScale;
			sprite.scaleY = startScale;
			sprite.x = sprite.x - int(originalW*startScale-originalW)/2;
			sprite.y = sprite.y - int(originalH*startScale-originalH)/2;
			sprite.alpha = startAlpha;
			var spriteTween:TweenLite = new TweenLite(sprite,1,{
				ease:Strong.easeInOut, alpha:endAlpha,
				x:posx, y:posy,
				scaleX:endScale,
				scaleY:endScale,
				onComplete:function():void
				{
					sprite.parent.removeChild(sprite);
					if(fxComplete != null)
						fxComplete();
				}
			});
		}
		
		private static function getDisplayObjectRectangle(container:DisplayObjectContainer, processFilters:Boolean):Rectangle
		{
			var finalRect:Rectangle = processDisplayObjectContainer(container, processFilters);
			var localPoint:Point = container.globalToLocal(new Point(finalRect.x, finalRect.y));
			finalRect = new Rectangle(localPoint.x, localPoint.y, finalRect.width, finalRect.height);           
			return finalRect;
		}
		
		private static function processDisplayObjectContainer(container:DisplayObjectContainer, processFilters:Boolean):Rectangle
		{
			var resultRect:Rectangle = null;
			if (container != null) 
			{
				var index:int = 0;
				var displayObject:DisplayObject;
				
				for(var childIndex:int = 0; childIndex < container.numChildren; childIndex++)
				{
					displayObject = container.getChildAt(childIndex);
					if (displayObject is DisplayObjectContainer)
					{
						var displayObjectRect:Rectangle = processDisplayObjectContainer(displayObject as DisplayObjectContainer, processFilters);
						if (resultRect == null)
						{ 
							resultRect = displayObjectRect.clone(); 
						} else {
							resultRect = resultRect.union(displayObjectRect);
						}                                               
					}                                               
				}
				var containerRect:Rectangle = container.getBounds(container.stage);
				if (resultRect == null)
				{ 
					resultRect = containerRect.clone(); 
				} else {
					resultRect = resultRect.union(containerRect);
				}
				if ((processFilters == true) && (container.filters.length > 0))
				{
					var filterGeneraterRect:Rectangle = new Rectangle(0,0,resultRect.width, resultRect.height);
					var bmd:BitmapData = new BitmapData(resultRect.width, resultRect.height, true, 0x00000000);
					var filter_minimumX:Number = 0;
					var filter_minimumY:Number = 0;
					var filtersLength:int = container.filters.length;
					var filterRect:Rectangle;
					for (var filtersIndex:int = 0; filtersIndex < filtersLength; filtersIndex++)
					{                                          
						var filter:BitmapFilter = container.filters[filtersIndex];
						filterRect = bmd.generateFilterRect(filterGeneraterRect, filter);
						filter_minimumX = filter_minimumX + filterRect.x;
						filter_minimumY = filter_minimumY + filterRect.y;
						filterGeneraterRect = filterRect.clone();
						filterGeneraterRect.x = 0;
						filterGeneraterRect.y = 0;
						bmd = new BitmapData(filterGeneraterRect.width, filterGeneraterRect.height, true, 0x00000000);                                              
					}
					filterRect.x = resultRect.x + filter_minimumX;
					filterRect.y = resultRect.y + filter_minimumY;
					resultRect = filterRect.clone();
				}                               
			} else {
				throw new Error("No displayobject was passed as an argument");
			}
			return resultRect;
		}

		public static function startOne(sprite1:Sprite, reverse:Boolean = false, onComplete:Function = null):void
		{
			target1 = sprite1;
			targetParent = target1.parent;
			
			var rectangle:Rectangle;
			
			rectangle = getDisplayObjectRectangle(target1, processFilters);
			var bitmapData:BitmapData = new BitmapData(rectangle.width, rectangle.height, !processFilters);
			bitmapData.draw(target1);
			target1Bmp = new Bitmap(bitmapData);
			
			targetParent.addChild(target1Bmp);
			target1Bmp.x = sprite1.x;
			target1Bmp.y = sprite1.y;
			
			if(processFilters)
			{
				target1.visible = false;
			} else {
				TweenLite.to(target1,0.5,{alpha:0,onComplete:function():void{target1.visible = false;}});
			}
			var complete:Function = function():void
			{
				target1.visible = true;
				onComplete();
			};
			if(reverse)
			{
				glideHideEffect(target1Bmp, 0.75, 1, .5, 1, complete);
			} else {
				glideHideEffect(target1Bmp, 1.5, 1, .5, 1, complete);
			}
		}
	}
}