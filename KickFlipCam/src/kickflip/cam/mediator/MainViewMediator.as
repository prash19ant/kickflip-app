package kickflip.cam.mediator
{
	import flash.events.Event;
	
	import kickflip.cam.common.ViewConstant;
	import kickflip.cam.view.HomeView;
	import kickflip.cam.view.MainView;
	import kickflip.cam.view.PublisherView;
	import kickflip.cam.view.WatcherView;

	public class MainViewMediator
	{
		public var view:MainView;
		private var homeView:HomeView;
		private var watcherView:WatcherView;
		private var publisherView:PublisherView;

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
				case ViewConstant.HOME_MENU:
				{
					goHome();
					break;
				}
				case ViewConstant.WATCHER_MENU:
				{
					goWatcher();
					break;
				}
				case ViewConstant.PUBLISHER_MENU:
				{
					goPublisher();
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
		
		private function goWatcher():void
		{
			watcherView = new WatcherView();
			watcherView.onMenuClick.add(menuHandler);
			view.addView(watcherView);
		}
		
		private function goPublisher():void
		{
			publisherView = new PublisherView();
			publisherView.onMenuClick.add(menuHandler);
			view.addView(publisherView);
		}
	}
}