package flipviw.viw.view
{
	import flash.events.Event;
	
	import flipviw.viw.mediator.HomeViewMediator;
	
	import kickflip.app.control.CoolButton;
	import kickflip.common.view.View;

	public class HomeView extends View
	{
		private var mediator:HomeViewMediator;
		private var playButton:CoolButton;
		
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
			
			var gapy:uint = 40;
			var posy:uint = 50;
			
			var btnWidth:uint = 200;
			var btnHeight:uint = 40;
			playButton = new CoolButton("Play", btnWidth, btnHeight);
			playButton.onClick.add(playClickHandler);
			playButton.x = viewWidth/2 - btnWidth/2;
			playButton.y = posy; posy += btnHeight + gapy;
			panel.addChild(playButton);
			
			centerSprite(this);
		}
		
		private function playClickHandler():void
		{
			onMenuClick.dispatch(PLAY_MENU);
		}
	}
}