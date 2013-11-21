package kickflip.app.control
{
	import kickflip.app.AppGlobal;
	import kickflip.app.AppText;
	import kickflip.app.manager.ButtonStyleManager;
	import kickflip.app.manager.FontManager;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Strong;
	
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import org.osflash.signals.Signal;
	
	public class Alert extends Sprite
	{
		private static var appStage:Stage = null;
		private static const GlideHideEffect:uint = 0;
		private static const DropHideEffect:uint = 1;
		private static const ALERT_CHILD_NAME:String = "alertChildName";
		public var onClose:Signal = new Signal();
		public var onConfirm:Signal = new Signal();
		private var modal:Sprite;
		private var modalColor:uint = 0x000000;
		private var panel:Sprite;
		private var panelWidth:uint = 350;
		private var panelHeight:uint = 250;
		private var text:String = "";
		private var hideEffect:uint = GlideHideEffect;
		private var isConfirmDialog:Boolean = false;
		private var rounded:uint = 17;
		private var buttonFontSize:uint = 20;
		
		public function Alert()
		{
			super();
		}
		
		private function display():void
		{
			if(appStage == null)
			{
				addEventListener(Event.ADDED_TO_STAGE, initStage);
			} else {
				initDisplay();
			}
		}
		
		private function initStage(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initStage);
			initDisplay();
		}
		
		private function initDisplay():void
		{
			buildModal();
			configureListener();
		}
		
		private function configureListener():void
		{
			appStage.addEventListener(Event.RESIZE, stageResize);
			appStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		private function removeListener():void
		{
			appStage.removeEventListener(Event.RESIZE, stageResize);
			appStage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			panelDisableDragDrop();
		}
		
		private function keyDownHandler(event:KeyboardEvent) : void
		{
			if (event.keyCode == Keyboard.ESCAPE)
			{
				panelHide();
			}
		}
		
		private function stageResize(evt:Event):void
		{
			if(appStage==null) return;
			if(panel==null) return;
			panel.x = appStage.stageWidth/2 - panelWidth/2;
			panel.y = appStage.stageHeight/2 - panelHeight/2;
			modal.graphics.clear();
			modal.graphics.beginFill(modalColor,0.7);
			modal.graphics.drawRect(0,0, appStage.stageWidth, appStage.stageHeight);
			modal.graphics.endFill();
		}
		
		private function buildModal():void
		{
			if(modal == null)
			{
				modal = new Sprite();
				modal.graphics.beginFill(modalColor,0.7);
				modal.graphics.drawRect(0,0, appStage.stageWidth, appStage.stageHeight);
				modal.graphics.endFill();
				addChild(modal);
			}
			modal.alpha = 0;
			var modalTween:TweenLite = new TweenLite(modal,0.5,{
				ease:Strong.easeOut,
				alpha:1
			});
			buildPanel();
		}
		
		private function buildPanel():void
		{
			if(panel == null)
			{
				panel = getBasePanel();
				addChild(panel);
				panel.addChild(getLabel());
				panel.addChild(getButtons());
			}
			panel.alpha = 0;
			panelShow();
		}
		
		private function getBasePanel():Sprite
		{
			var base:Sprite = new Sprite();
			var colors:Array = [ 0xffffff, 0xC2C6CA, 0xa9b8c3];
			var alphas:Array = [ 1, 1, 1 ];
			var ratios:Array = [ 0x00, 0xB5, 0xFF ];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(panelWidth, panelHeight, (Math.PI / 2), 0, 0);
			base.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.PAD);
			base.graphics.drawRoundRect(0, 0, panelWidth, panelHeight, rounded, rounded);
			base.graphics.endFill();
			var filterB:BevelFilter = new BevelFilter(1, 45, 0xffffff, 0.5, 0x5c5c5c, .8, 1.1, 2.5, 4, 3, "inner", false);
			var filterD:DropShadowFilter = new DropShadowFilter(0, 60, 0x000000, .5, 10, 10, 1, 3, false, false, false);
			base.filters = [filterB, filterD];
			/*
			var colors:Array = [0xfea100, 0x5a3900];
			var alphas:Array = [ 1, 1 ];
			var ratios:Array = [ 0x00, 0xFF ];
			var matrix:Matrix = new Matrix();
			var rounded:uint = 10;
			matrix.createGradientBox(panelWidth, panelHeight, (Math.PI / 2), 0, 0);
			base.graphics.clear();
			base.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.PAD);
			base.graphics.drawRoundRect(0, 0, panelWidth, panelHeight, rounded, rounded);
			base.graphics.endFill();
			var filterD:DropShadowFilter = new DropShadowFilter(0, 60, 0x000000, .5, 10, 10, 1, 3, false, false, false);
			base.filters = [filterD];
			*/
			return base;
		}
		
		private function getLabel():TextField
		{
			var headerHeight:uint = 50;
			var textPadding:uint = 15;
			var label:TextField = buildText( {
				width : panelWidth - textPadding*2,
				height : panelHeight - headerHeight - textPadding,
				text : text,
				color : 0x000000
			} );
			label.x = textPadding;
			label.y = headerHeight;
			return label;
		}
		
		private function getButtons():Sprite
		{
			if(!isConfirmDialog)
				return getCloseButton();
			else
				return getConfirmButton();
		}

		private function getCloseButton():Sprite
		{
			var btnWidth:uint = 200;
			var btnheight:uint = 40;
			var closeBtn:Button = new Button(AppText.CLOSE, ButtonStyleManager.instance.loginStyle, btnWidth, btnheight, buttonFontSize);
			closeBtn.onClick.addOnce(function():void{
				panelHide();
			});
			closeBtn.x = panelWidth/2 - btnWidth/2;
			closeBtn.y = panelHeight - btnheight - 10;
			return closeBtn;
		}
		
		private function getConfirmButton():Sprite
		{
			var btns:Sprite = new Sprite();
			var btnWidth:uint = 160;
			var btnheight:uint = 40;
			var gapx:uint = 20;
			var posx:uint = 0;
			var yes:Button = new Button(AppText.YES, ButtonStyleManager.instance.defaultStyle, btnWidth, btnheight, buttonFontSize);
			yes.onClick.addOnce(function():void{
				panelHide(function():void{
					onConfirm.dispatch();
				});
			});
			yes.x = posx; posx += btnWidth+gapx;
			yes.y = panelHeight - btnheight - 10;
			btns.addChild(yes);

			var no:Button = new Button(AppText.NO, ButtonStyleManager.instance.defaultStyle, btnWidth, btnheight, buttonFontSize);
			no.onClick.addOnce(function():void{
				panelHide();
			});
			no.x = posx;
			no.y = panelHeight - btnheight - 10;
			btns.addChild(no);
			btns.x = panelWidth/2 - btnWidth - gapx/2;
			return btns;
		}

		private function buildText(config:Object) : TextField
		{
			var text:String = (config.text != undefined)?config.text:"";
			var width:uint = (config.width != undefined)?config.width:120;
			var height:uint = (config.height != undefined)?config.height:18;
			var color:uint = (config.color != undefined)?config.color:0xffffff;
			var wordWrap:Boolean = (config.wordWrap != undefined)?config.wordWrap:true;
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.color = color;
			format.size = 20;
			format.align = "center";
			var txt:TextField = new TextField();
			txt.embedFonts = false;
			txt.selectable = false;
			txt.width = width;
			txt.height = height;
			txt.defaultTextFormat = format;
			txt.text = text;	
			txt.wordWrap = wordWrap;
			txt.cacheAsBitmap = true;
			return txt;
		}
		
		private function panelShow():void
		{
			var panelScale:Number = 1.5;
			panel.scaleX = panelScale;
			panel.scaleY = panelScale;
			panel.x = appStage.stageWidth/2 - panel.width/2;
			panel.y = appStage.stageHeight/2 - panel.height/2;
			var posx:uint = appStage.stageWidth/2 - panelWidth/2;
			var posy:uint = appStage.stageHeight/2 - panelHeight/2;
			panel.alpha = 0;
			var panelTween:TweenLite = new TweenLite(panel,0.5,{
				ease:Strong.easeInOut, alpha:1,
				x:posx, y:posy,
				width:panelWidth,
				height:panelHeight,
				onComplete:panelEnableDragDrop
			});
		}
		
		public function panelHide(delayfnc:Function = null):void
		{
			switch(hideEffect)
			{
				case GlideHideEffect:
					glideHideEffect(panel, delayfnc);
					break;
				case DropHideEffect:
					dropHideEffect(panel);
					break;
				default:
					dropHideEffect(panel);
					break;
			}
		}
		
		private function glideHideEffect(sprite:Sprite, delayfnc:Function = null):void
		{
			var spriteScale:Number = 2;
			sprite.scaleX = spriteScale;
			sprite.scaleY = spriteScale;
			var posx:int = sprite.x - sprite.width/4;
			var posy:int = sprite.y - sprite.height/4;
			sprite.scaleX = 1;
			sprite.scaleY = 1;
			var spriteTween:TweenLite = new TweenLite(sprite,0.5,{
				ease:Strong.easeOut, alpha:0,
				x:posx, y:posy,
				scaleX:spriteScale,
				scaleY:spriteScale,
				onComplete:modalHide,
				onCompleteParams:[delayfnc]
			});
		}
		
		private function dropHideEffect(sprite:Sprite):void
		{
			var posy:int = appStage.stageHeight + 50;
			var spriteTween:TweenLite = new TweenLite(sprite,1,{
				ease:Strong.easeInOut,
				y:posy,
				onComplete:modalHide
			});
		}
		
		private function modalHide(delayfnc:Function = null):void
		{
			var modalTween:TweenLite = new TweenLite(modal,0.5,{
				ease:Strong.easeOut,
				alpha:0,
				onComplete:close,
				onCompleteParams:[delayfnc]
			});
		}
		
		private function panelEnableDragDrop():void
		{
			panel.addEventListener(MouseEvent.MOUSE_DOWN, panelStarDrag);
			panel.addEventListener(MouseEvent.MOUSE_UP, panelstopDrag);
		}
		
		private function panelDisableDragDrop():void
		{
			panel.removeEventListener(MouseEvent.MOUSE_DOWN, panelStarDrag);
			panel.removeEventListener(MouseEvent.MOUSE_UP, panelstopDrag);
		}

		private function panelStarDrag(evt:Event):void
		{
			panel.startDrag();
		}

		private function panelstopDrag(evt:Event):void
		{
			panel.stopDrag();
		}

		private function show(text:String):void
		{
			this.text = text;
			display();
		}
		
		private function confirm(text:String):void
		{
			this.text = text;
			this.isConfirmDialog = true;
			panelWidth = 450;
			panelHeight = 270;
			display();
		}

		private function close(delayfnc:Function = null):void
		{
			if(delayfnc != null) delayfnc();
			onClose.dispatch();
			removeListener();
			if(parent != null)
				parent.removeChild(this);
		}
		
		public static function init(mainStage:Stage):void
		{
			appStage = mainStage;
		}

		public static function show(txt:String):Alert
		{
			if(appStage==null){return null;}
			var alertChildName:String = ALERT_CHILD_NAME;
			if(appStage.getChildByName(alertChildName) != null)
			{
				appStage.removeChild(appStage.getChildByName(alertChildName));
			}
			var alert:Alert = new Alert();
			alert.name = alertChildName;
			appStage.addChild(alert);
			alert.show(txt);
			return alert;
		}
		
		public static function confirm(txt:String):Alert
		{
			if(appStage==null){return null;}
			var alertChildName:String = ALERT_CHILD_NAME;
			if(appStage.getChildByName(alertChildName) != null)
			{
				appStage.removeChild(appStage.getChildByName(alertChildName));
			}
			var alert:Alert = new Alert();
			alert.name = alertChildName;
			appStage.addChild(alert);
			alert.confirm(txt);
			return alert;
		}
	}
}