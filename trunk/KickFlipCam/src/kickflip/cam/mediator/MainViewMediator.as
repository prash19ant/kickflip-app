package kickflip.cam.mediator
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
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
		private var actionDictionary:Dictionary;

		public function MainViewMediator(view:MainView)
		{
			this.view = view;
			setActionDictionary();
			init();
		}
		
		private function setActionDictionary():void
		{
			actionDictionary = new Dictionary();
			actionDictionary[ViewConstant.HOME_MENU] = goHome;
			actionDictionary[ViewConstant.WATCHER_MENU] = goWatcher;
			actionDictionary[ViewConstant.PUBLISHER_MENU] = goPublisher;
		}

		private function init():void
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
			if(!actionDictionary.hasOwnProperty(item))
				return;
			actionDictionary[item]();
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