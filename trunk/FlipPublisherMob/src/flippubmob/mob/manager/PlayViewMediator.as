package flippubmob.mob.manager
{
	import flash.events.Event;
	
	import flippubmob.mob.view.PlayView;

	public class PlayViewMediator
	{
		public var view:PlayView;

		public function PlayViewMediator(view:PlayView)
		{
			this.view = view;
		}
		
		public function init():void
		{
			//view.stage.addEventListener(Event.RESIZE, resizeHandler);
		}
		
		private function resizeHandler(evt:Event):void
		{
			view.centerCurrentView();
		}
	}
}