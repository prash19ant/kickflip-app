package flipviw.viw.view
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Strong;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flipviw.app.AppGlobal;
	import flipviw.app.util.GlideTransition;
	
	import org.osflash.signals.Signal;
	
	public class View extends Sprite
	{
		public static const HOME_MENU:String = "home";
		public static const PLAY_MENU:String = "play";
		private static const VIEW_WIDTH_NAME:String = "viewWidth";
		private static const VIEW_HEIGHT_NAME:String = "viewHeight";
		
		protected var panel:Sprite;
		public var viewWidth:uint;
		public var viewHeight:uint;
		private var _needReadyStatus:Boolean = false;
		private var _imageloading:Number = 0;
		public var onViewReady:Signal = new Signal();
		
		public var onMenuClick:Signal = new Signal();
		private var currentView:View;
		
		public function View()
		{
			super();
		}
		
		protected function getPanel():Sprite
		{
			viewWidth = AppGlobal.DEFAULT_WIDTH;
			viewHeight = AppGlobal.DEFAULT_HEIGHT;
			var base:Sprite = new Sprite();
			//base.addChild(new backgroundClass() as Bitmap);
			return base;
		}
		
		protected function getBasePanel(path:String = null):Sprite
		{
			viewWidth = AppGlobal.DEFAULT_WIDTH;
			viewHeight = AppGlobal.DEFAULT_HEIGHT;
			if(path != null)
			{
				return buildImagePanel(path);
			}
			return buildPlainPanel();
		}
		
		protected function buildPlainPanel():Sprite
		{
			var base:Sprite = new Sprite();
			var rounded:uint = 5;
			base.graphics.beginFill(0xC7D2D6);
			base.graphics.drawRoundRect(0, 0, viewWidth, viewHeight, rounded, rounded);
			base.graphics.endFill();
			return base;
		}
		
		protected function buildImagePanel(path:String):Sprite
		{
			var base:Sprite = new Sprite();
			base.graphics.beginFill(0x000000);
			base.graphics.drawRect(0, 0, viewWidth, viewHeight);
			base.graphics.endFill();
			base.addChild(loadImage(path));
			return base;
		}
		
		public function centerSprite(sprite:Sprite):void
		{
			var appWidth:int = sprite.hasOwnProperty(VIEW_WIDTH_NAME) ? sprite[VIEW_WIDTH_NAME]/2 : sprite.width/2;
			var appHeight:int = sprite.hasOwnProperty(VIEW_HEIGHT_NAME) ? sprite[VIEW_HEIGHT_NAME]/2 : sprite.height/2;
			sprite.x = stage.stageWidth/2 - appWidth;
			sprite.y = stage.stageHeight/2 - appHeight;
		}
		
		private function loadImage(path:String):DisplayObject
		{
			_imageloading++;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load(new URLRequest(path));
			return loader;
		}
		
		private function onIOError(evt:IOErrorEvent):void
		{
			trace("View.onIOError["+ evt.text +"]");
			_imageloading--;
			removeLoaderListener(evt);
		}		
		
		private function imageComplete(evt:Event):void
		{
			_imageloading--;
			removeLoaderListener(evt);
			if(_imageloading==0)
			{
				onViewReady.dispatch();
			}
		}
		
		private function removeLoaderListener(evt:Event):void
		{
			var loader:LoaderInfo = evt.target as LoaderInfo;
			loader.removeEventListener(Event.COMPLETE, imageComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		public function get needReadyStatus():Boolean { return _needReadyStatus; }
		public function set needReadyStatus(value:Boolean):void
		{
			if(value) visible = false;
			_needReadyStatus = value;
		}
		
		public function addView(view:View):void
		{
			addChild(view);
			doTransition(currentView, view);
			currentView = view;
		}
		
		private function doTransition(prevView:View, nextView:View):void
		{
			if(!prevView)
			{
				if(nextView.needReadyStatus)
					nextView.visible = true;
				return;
			};
			var onComplete:Function = function():void{ prevView.dispose(); nextView.initView(); };
			if(nextView.needReadyStatus)
			{
				nextView.onViewReady.addOnce(function():void
				{
					GlideTransition.start(prevView, nextView, true, onComplete);
				});
			} else {
				GlideTransition.start(prevView, nextView, true, onComplete);
			}
		}
		
		public function initView():void
		{
		}
		
		public function centerCurrentView():void
		{
			centerSprite(currentView);
		}
		
		public function dispose():void
		{
			parent.removeChild(this);
		}
	}		
}