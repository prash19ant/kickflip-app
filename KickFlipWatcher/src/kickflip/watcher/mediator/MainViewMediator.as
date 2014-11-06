package kickflip.watcher.mediator
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import kickflip.cam.common.ViewConstant;
	import kickflip.cam.view.WatcherView;
	import kickflip.watcher.view.HomeView;
	import kickflip.watcher.view.MainView;

	public class MainViewMediator
	{
		public var view:MainView;
		private var homeView:HomeView;
		private var watcherView:WatcherView;
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
	}
}