package flipviw.viw.view
{
	import flash.events.Event;
	
	import flipviw.viw.mediator.MainViewMediator;
	
	import kickflip.common.view.View;

	public class MainView extends View
	{
		private var mediator:MainViewMediator;

		public function MainView()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, initStage);
		}
		
		private function initStage(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initStage);
			mediator = new MainViewMediator(this);
		}
	}
}