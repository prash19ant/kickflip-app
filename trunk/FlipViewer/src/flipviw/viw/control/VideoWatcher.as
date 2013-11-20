package flipviw.viw.control
{
	import flash.display.Sprite;
	import flash.media.Video;
	import flash.net.NetStream;
	
	public class VideoWatcher extends Sprite
	{
		public var appWidth:uint = 400;
		public var appHeight:uint = 350;
		private var video:Video;
		private var netStream:NetStream;

		public function VideoWatcher()
		{
			super();
		}
		
		public function setStream(netstream:NetStream):void
		{
			trace("[setStream]");
			netStream = netstream;
			
			video = new Video();
			video.attachNetStream(netStream);
			video.width = appWidth;
			video.height = appHeight;
			addChild(video);
		}
	}
}