package kickflip.cam.mediator
{
	import flash.events.Event;
	
	import kickflip.cam.view.PublisherView;

	public class PublisherViewMediator
	{
		public var view:PublisherView;

		public function PublisherViewMediator(view:PublisherView)
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