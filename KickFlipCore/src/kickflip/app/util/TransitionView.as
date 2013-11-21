package kickflip.app.util
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
	
	public class TransitionView
	{
		private static var target1:Sprite;
		private static var target2:Sprite;
		private static var target1Bmp:Bitmap;
		private static var target2Bmp:Bitmap;
		private static var targetParent:DisplayObjectContainer;
		private static var complete:Function;
		
		public function TransitionView()
		{
		}
		
		public static function start(sprite1:Sprite, sprite2:Sprite, reverse:Boolean = false):void
		{
			target1 = sprite1;
			target2 = sprite2;
			targetParent = target2.parent;
			
			var rectangle:Rectangle;
			rectangle = getDisplayObjectRectangle(target1, true);
			
			var bitmapData:BitmapData = new BitmapData(rectangle.width, rectangle.height,true,0x00FFFFFF);
			bitmapData.draw(target1);
			target1Bmp = new Bitmap(bitmapData);
			
			rectangle = getDisplayObjectRectangle(target2, true);
			var bitmapData2:BitmapData = new BitmapData(rectangle.width, rectangle.height);
			bitmapData2.draw(target2);
			target2Bmp = new Bitmap(bitmapData2);
			
			targetParent.addChild(target2Bmp);
			targetParent.addChild(target1Bmp);
			
			target1.visible = false;
			target2.visible = false;
			complete = function():void
			{
				targetParent.removeChild(target1);
				target2.visible = true;
			};
			if(reverse)
			{
				glideHideEffect(target1Bmp, 1, 1.5, 1, .5);
				glideHideEffect(target2Bmp, 0.75, 1, .5, 1, complete);
			} else {
				glideHideEffect(target1Bmp, 1, 0.75, 1, .5);
				glideHideEffect(target2Bmp, 1.5, 1, .5, 1, complete);
			}
		}
		
		private static function glideHideEffect(sprite:Bitmap, startScale:Number = 0.5, endScale:Number = 1, startAlpha:uint = 1, endAlpha:uint = 0.5, fxComplete:Function = null):void
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
				onComplete:function():void {
					sprite.parent.removeChild(sprite);
					if(fxComplete != null)
						fxComplete();
				}
			});
		}
		
		private static function getDisplayObjectRectangle(container:DisplayObjectContainer, processFilters:Boolean):Rectangle
		{
			var final_rectangle:Rectangle = processDisplayObjectContainer(container, processFilters);
			
			// translate to local
			var local_point:Point = container.globalToLocal(new Point(final_rectangle.x, final_rectangle.y));
			final_rectangle = new Rectangle(local_point.x, local_point.y, final_rectangle.width, final_rectangle.height);           
			
			return final_rectangle;
		}
		
		private static function processDisplayObjectContainer(container:DisplayObjectContainer, processFilters:Boolean):Rectangle {
			var result_rectangle:Rectangle = null;
			
			// Process if container exists
			if (container != null) {
				var index:int = 0;
				var displayObject:DisplayObject;
				
				// Process each child DisplayObject
				for(var childIndex:int = 0; childIndex < container.numChildren; childIndex++){
					displayObject = container.getChildAt(childIndex);
					
					//If we are recursing all children, we also get the rectangle of children within these children.
					if (displayObject is DisplayObjectContainer) {
						
						// Let's drill into the structure till we find the deepest DisplayObject
						var displayObject_rectangle:Rectangle = processDisplayObjectContainer(displayObject as DisplayObjectContainer, processFilters);
						
						// Now, stepping out, uniting the result creates a rectangle that surrounds siblings
						if (result_rectangle == null) { 
							result_rectangle = displayObject_rectangle.clone(); 
						} else {
							result_rectangle = result_rectangle.union(displayObject_rectangle);
						}                                               
					}                                               
				}
				
				// Get bounds of current container, at this point we're stepping out of the nested DisplayObjects
				var container_rectangle:Rectangle = container.getBounds(container.stage);
				
				if (result_rectangle == null) { 
					result_rectangle = container_rectangle.clone(); 
				} else {
					result_rectangle = result_rectangle.union(container_rectangle);
				}
				
				
				// Include all filters if requested and they exist
				if ((processFilters == true) && (container.filters.length > 0)) {
					var filterGenerater_rectangle:Rectangle = new Rectangle(0,0,result_rectangle.width, result_rectangle.height);
					var bmd:BitmapData = new BitmapData(result_rectangle.width, result_rectangle.height, true, 0x00000000);
					
					var filter_minimumX:Number = 0;
					var filter_minimumY:Number = 0;
					
					var filtersLength:int = container.filters.length;
					for (var filtersIndex:int = 0; filtersIndex < filtersLength; filtersIndex++) {                                          
						var filter:BitmapFilter = container.filters[filtersIndex];
						
						var filter_rectangle:Rectangle = bmd.generateFilterRect(filterGenerater_rectangle, filter);
						
						filter_minimumX = filter_minimumX + filter_rectangle.x;
						filter_minimumY = filter_minimumY + filter_rectangle.y;
						
						filterGenerater_rectangle = filter_rectangle.clone();
						filterGenerater_rectangle.x = 0;
						filterGenerater_rectangle.y = 0;
						
						bmd = new BitmapData(filterGenerater_rectangle.width, filterGenerater_rectangle.height, true, 0x00000000);                                              
					}
					
					// Reposition filter_rectangle back to global coordinates
					filter_rectangle.x = result_rectangle.x + filter_minimumX;
					filter_rectangle.y = result_rectangle.y + filter_minimumY;
					
					result_rectangle = filter_rectangle.clone();
				}                               
			} else {
				throw new Error("No displayobject was passed as an argument");
			}
			
			return result_rectangle;
		}
	}
}