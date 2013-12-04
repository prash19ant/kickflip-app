package kickflip.cam.view
{
	import flash.events.Event;
	
	import kickflip.app.control.CoolButton;
	import kickflip.cam.common.ViewConstant;
	import kickflip.cam.control.CameraControl;
	import kickflip.cam.mediator.PublisherViewMediator;
	import kickflip.common.view.View;
	
	public class PublisherView extends View
	{
		private var mediator:PublisherViewMediator;
		private var quitButton:CoolButton;
		private var camera:CameraControl;

		public function PublisherView()
		{
			super();
			mediator = new PublisherViewMediator(this);
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
			
			var gapy:uint = 5;
			
			camera = new CameraControl();
			panel.addChild(camera);
			camera.x = viewWidth/2 - camera.appWidth/2 
			var posy:uint = viewHeight/2 - camera.appHeight/2 - 20;
			camera.y = posy; posy += camera.appHeight + gapy;

			var btnWidth:uint = 200;
			var btnHeight:uint = 40;
			quitButton = new CoolButton("Close", btnWidth, btnHeight);
			quitButton.onClick.add(quitClickHandler);
			quitButton.x = viewWidth/2 - btnWidth/2;
			quitButton.y = posy;
			panel.addChild(quitButton);
			
			centerSprite(this);
		}
		
		private function quitClickHandler():void
		{
			camera.dispose();
			onMenuClick.dispatch(ViewConstant.HOME_MENU);
		}
	}
}