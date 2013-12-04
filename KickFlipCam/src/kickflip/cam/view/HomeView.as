package kickflip.cam.view
{
	import flash.events.Event;
	
	import kickflip.app.control.CoolButton;
	import kickflip.cam.common.ViewConstant;
	import kickflip.cam.mediator.HomeViewMediator;
	import kickflip.common.view.View;
	
	public class HomeView extends View
	{
		private var mediator:HomeViewMediator;
		private var watcherButton:CoolButton;
		private var publisherButton:CoolButton;

		public function HomeView()
		{
			super();
			mediator = new HomeViewMediator(this);
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
			var gapy:uint = 40;
			var posy:uint = stage.stageHeight/2 - 2*40/2 - gapy;
			
			publisherButton = new CoolButton("Publisher", btnWidth, btnHeight);
			publisherButton.onClick.add(publisherClickHandler);
			publisherButton.x = viewWidth/2 - btnWidth/2;
			publisherButton.y = posy; posy += btnHeight + gapy;
			panel.addChild(publisherButton);

			watcherButton = new CoolButton("Watcher", btnWidth, btnHeight);
			watcherButton.onClick.add(watcherClickHandler);
			watcherButton.x = viewWidth/2 - btnWidth/2;
			watcherButton.y = posy; posy += btnHeight + gapy;
			panel.addChild(watcherButton);

			centerSprite(this);
		}
		
		private function watcherClickHandler():void
		{
			onMenuClick.dispatch(ViewConstant.WATCHER_MENU);
		}

		private function publisherClickHandler():void
		{
			onMenuClick.dispatch(ViewConstant.PUBLISHER_MENU);
		}
	}
}