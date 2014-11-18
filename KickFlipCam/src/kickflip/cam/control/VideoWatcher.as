package kickflip.cam.control
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.media.Video;
	import flash.net.NetStream;
	
	import kickflip.app.AppGlobal;
	import kickflip.common.manager.ConnectionManager;
	
	public class VideoWatcher extends Sprite
	{
		public var appWidth:uint = 400;
		public var appHeight:uint = 350;
		private var video:Video;
		private var connManager:ConnectionManager;
		private var netStream:NetStream;

		public function VideoWatcher()
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
			video = new Video();
			video.attachNetStream(netStream);
			video.width = appWidth;
			video.height = appHeight;
			var filterD:DropShadowFilter = new DropShadowFilter(0, 60, 0x000000, 1, 10, 10, 1, 3, false, false, false);
			video.filters = [filterD];
			addChild(video);
			
			netStream.play(AppGlobal.DEFAULT_STREAM_NAME);
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