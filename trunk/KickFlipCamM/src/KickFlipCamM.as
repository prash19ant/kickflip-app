package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import kickflip.app.AppGlobal;
	import kickflip.cam.view.MainView;
	
	[SWF(width='800',height='1232', backgroundColor='#AAAAAA', frameRate='60')]
	public class KickFlipCamM extends Sprite
	{
		public function KickFlipCamM()
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
			AppGlobal.defaultWidth = 800;
			AppGlobal.defaultHeight = 1232;
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