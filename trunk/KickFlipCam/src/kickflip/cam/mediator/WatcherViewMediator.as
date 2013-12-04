package kickflip.cam.mediator
{
	import flash.events.Event;
	
	import kickflip.cam.view.WatcherView;

	public class WatcherViewMediator
	{
		public var view:WatcherView;

		public function WatcherViewMediator(view:WatcherView)
		{
			this.view = view;
		}

		public function init():void
		{
			view.stage.addEventListener(Event.RESIZE, resizeHandler);
		}
		
		private function resizeHandler(evt:Event):void
		{
			view.centerCurrentView();
		}
	}
}