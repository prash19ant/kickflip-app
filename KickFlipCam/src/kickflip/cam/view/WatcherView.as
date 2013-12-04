package kickflip.cam.view
{
	import flash.events.Event;
	
	import kickflip.app.control.CoolButton;
	import kickflip.cam.common.ViewConstant;
	import kickflip.cam.control.VideoWatcher;
	import kickflip.cam.mediator.WatcherViewMediator;
	import kickflip.common.view.View;
	
	public class WatcherView extends View
	{
		private var mediator:WatcherViewMediator;
		private var quitButton:CoolButton;
		private var watcher:VideoWatcher;

		public function WatcherView()
		{
			super();
			mediator = new WatcherViewMediator(this);
			addEventListener(Event.ADDED_TO_STAGE, initStage);
		}
		
		private function initStage(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initStage);
			mediator.init();
			initContent();
		}
		
		private function initContent():void
		{
			panel = getBasePanel();
			addChild(panel);
			
			var gapy:uint = 5;

			watcher = new VideoWatcher();
			panel.addChild(watcher);
			watcher.x = viewWidth/2 - watcher.appWidth/2 
			var posy:uint = viewHeight/2 - watcher.appHeight/2 - 20;
			watcher.y = posy; posy += watcher.appHeight + gapy;
			
			var btnWidth:uint = 200;
			var btnHeight:uint = 40;
			quitButton = new CoolButton("Close", btnWidth, btnHeight);
			quitButton.onClick.add(quitClickHandler);
			quitButton.x = viewWidth/2 - btnWidth/2;
			quitButton.y = posy;
			panel.addChild(quitButton);
			
			centerSprite(this);
		}
		
		private function quitClickHandler():void
		{
			watcher.dispose();
			onMenuClick.dispatch(ViewConstant.HOME_MENU);
		}
	}
}