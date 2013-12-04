package kickflip.cam.view
{
	import flash.events.Event;
	
	import kickflip.cam.mediator.MainViewMediator;
	import kickflip.common.view.View;
	
	public class MainView extends View
	{
		private var mediator:MainViewMediator;

		public function MainView()
		{
			super();
			mediator = new MainViewMediator(this);
			addEventListener(Event.ADDED_TO_STAGE, initStage);
		}
		
		private function initStage(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initStage);
			mediator.init();
		}
	}
}