package kickflip.watcher.view
{
	import flash.events.Event;
	
	import kickflip.app.control.CoolButton;
	import kickflip.cam.common.ViewConstant;
	import kickflip.cam.mediator.HomeViewMediator;
	import kickflip.common.view.View;
	
	public class HomeView extends View
	{
		private var playButton:CoolButton;

		public function HomeView()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, initStage);
		}
		
		private function initStage(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initStage);
			initContent();
		}
		
		private function initContent():void
		{
			panel = getBasePanel();
			addChild(panel);
			
			var btnWidth:uint = viewWidth - 10;
			var btnHeight:uint = 50;
			
			playButton = new CoolButton("Play", btnWidth, btnHeight);
			playButton.onClick.add(playClickHandler);
			playButton.x = viewWidth/2 - btnWidth/2;
			playButton.y = viewHeight/2 - btnHeight/2;
			panel.addChild(playButton);
			
			centerSprite(this);
		}

		private function playClickHandler():void
		{
			onMenuClick.dispatch(ViewConstant.WATCHER_MENU);
		}
	}
}