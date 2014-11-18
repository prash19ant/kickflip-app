package kickflip.cam.control
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetStream;
	
	import kickflip.app.AppGlobal;
	import kickflip.app.control.Alert;
	import kickflip.common.manager.ConnectionManager;
	
	public class CameraControl extends Sprite
	{
		public var appWidth:uint = 400;
		public var appHeight:uint = 350;
		private var video:Video;
		private var camera:Camera;
		private var connManager:ConnectionManager;
		private var netStream:NetStream;

		public function CameraControl()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, initStage);
		}
		
		private function initStage(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initStage);
			connManager = new ConnectionManager();
			connManager.onSuccess.add(connectionHandler);
		}
		
		private function connectionHandler():void
		{
			netStream = connManager.CurrentNetStream;
			initContent();
		}
		
		private function initContent():void
		{
			camera = Camera.getCamera("0");
			if(camera == null)
			{
				Alert.show("CameraControl.setStream > Camera not found");
				return;
			}
			
			camera.setMode(appWidth, appHeight, 25, false);
			camera.setQuality(0, 75);
			
			netStream.attachCamera(camera);
			
			video = new Video();
			video.attachCamera(camera);
			video.width = appWidth;
			video.height = appHeight;
			var filterD:DropShadowFilter = new DropShadowFilter(0, 60, 0x000000, 1, 10, 10, 1, 3, false, false, false);
			video.filters = [filterD];
			addChild(video);
			
			publish();
		}
		
		private function publish():void
		{
			try
			{
				netStream.publish(AppGlobal.DEFAULT_STREAM_NAME, "live");
			} catch(err:Error)
			{
				var msg:String = "CameraControl.publish.error netStream probably camera not found. Error:"+ err.message;
				trace(msg);
				Alert.show(msg);
			}
		}
		
		public function dispose():void
		{
			if(netStream != null)
				netStream.close();
			if(video != null)
				removeChild(video);
		}
	}
}