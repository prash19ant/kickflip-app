package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import kickflip.app.AppGlobal;
	import kickflip.cam.view.MainView;
	
	[SWF(width='700',height='400', backgroundColor='#ffffff', frameRate='60')]
	public class KickFlipCam extends Sprite
	{
		public function KickFlipCam()
		{
			if(stage!=null)
			{
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.frameRate = 60;
			}
			init();
		}
		
		private function init():void
		{
			var global:AppGlobal = new AppGlobal();
			global.onReady.add(globalReadyHandler);
			global.init(stage);
		}
		
		private function globalReadyHandler():void
		{
			addChild(new MainView());
		}
	}
}