package flippub.flip.control
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetStream;
	
	import flippub.app.AppGlobal;
	import flippub.app.control.Alert;
	import flippub.app.util.logger.Log;
	
	public class CameraControl extends Sprite
	{
		public var appWidth:uint = 400;
		public var appHeight:uint = 350;
		private var video:Video;
		private var camera:Camera;
		private var netStream:NetStream;

		public function CameraControl()
		{
			super();
		}

		public function setStream(netstream:NetStream):void
		{
			camera = Camera.getCamera();
			if(camera == null)
			{
				Alert.show("CameraClient.setStream > Camera not found");
				return;
			}
			
			camera.setMode(appWidth, appHeight, 25, false);
			camera.setQuality(0, 75);

			netStream = netstream;
			netStream.attachCamera(camera);

			video = new Video();
			video.attachCamera(camera);
			video.width = appWidth;
			video.height = appHeight;
			addChild(video);
		}
		
		public function publish():void
		{
			try
			{
				netStream.publish(AppGlobal.DEFAULT_STREAM_NAME, "live");
			} catch(err:Error)
			{
				Log.Error("CameraClient.publish.error netStream probably camera not found.");
			}
		}

		public function unpublish():void
		{
			try
			{
				netStream.close();
			} catch(err:Error)
			{
				Log.Error("CameraClient.unpublish.error netStream probably not open.");
			}
		}

	}
}