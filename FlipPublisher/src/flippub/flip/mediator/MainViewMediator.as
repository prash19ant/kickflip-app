package flippub.flip.mediator
{
	import flash.events.Event;
	
	import flippub.flip.view.HomeView;
	import flippub.flip.view.MainView;
	import flippub.flip.view.PlayView;
	import flippub.flip.view.View;

	public class MainViewMediator
	{
		public var view:MainView;
		private var homeView:HomeView;
		private var playView:PlayView;

		public function MainViewMediator(view:MainView)
		{
			this.view = view;
		}
		
		public function init():void
		{
			goHome();
			view.stage.addEventListener(Event.RESIZE, resizeHandler);
		}
		
		private function resizeHandler(evt:Event):void
		{
			view.centerCurrentView();
		}
		
		private function menuHandler(item:String):void
		{
			switch(item)
			{
				case View.HOME_MENU:
				{
					goHome();
					break;
				}
				case View.PLAY_MENU:
				{
					goPlay();
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		private function goHome():void
		{
			homeView = new HomeView();
			homeView.onMenuClick.add(menuHandler);
			view.addView(homeView);
		}
		
		private function goPlay():void
		{
			playView = new PlayView();
			playView.onMenuClick.add(menuHandler);
			view.addView(playView);
		}
	}
}