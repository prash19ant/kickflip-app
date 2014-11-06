package flipviw.viw.mediator
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import flipviw.viw.view.HomeView;
	import flipviw.viw.view.MainView;
	import flipviw.viw.view.PlayView;
	
	import kickflip.common.view.View;

	public class MainViewMediator
	{
		public var view:MainView;
		private var homeView:HomeView;
		private var playView:PlayView;
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
			actionDictionary[View.HOME_MENU] = goHome;
			actionDictionary[View.PLAY_MENU] = goPlay;
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
		
		private function goPlay():void
		{
			playView = new PlayView();
			playView.onMenuClick.add(menuHandler);
			view.addView(playView);
		}
	}
}