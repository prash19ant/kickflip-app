package flippub.flip.view
{
	import flash.events.Event;
	import flash.media.Camera;
	
	import flippub.flip.control.CameraControl;
	import flippub.flip.mediator.PlayViewMediator;
	
	import kickflip.app.control.CoolButton;
	import kickflip.common.manager.ConnectionManager;
	import kickflip.common.view.View;

	public class PlayView extends View
	{
		private var mediator:PlayViewMediator;
		private var quitButton:CoolButton;
		private var camera:CameraControl;
		
		public function PlayView()
		{
			super();
			mediator = new PlayViewMediator(this);
			addEventListener(Event.ADDED_TO_STAGE, initStage);
		}
		
		private function initStage(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initStage);
			mediator.init();
			initContent();
		}

		private function initContent():void
		{
			panel = getBasePanel();
			addChild(panel);
			
			var gapy:uint = 40;
			var posy:uint = 10;
			
			camera = new CameraControl();
			panel.addChild(camera);
			camera.x = viewWidth/2 - camera.appWidth/2 
			camera.y = posy; posy += camera.appHeight + 5;

			var btnWidth:uint = 200;
			var btnHeight:uint = 40;
			quitButton = new CoolButton("Close", btnWidth, btnHeight);
			quitButton.onClick.add(quitClickHandler);
			quitButton.x = viewWidth/2 - btnWidth/2;
			quitButton.y = viewHeight - btnHeight - 5;
			panel.addChild(quitButton);
			
			
			centerSprite(this);
		}

		private function quitClickHandler():void
		{
			onMenuClick.dispatch(HOME_MENU);
		}
	}
}