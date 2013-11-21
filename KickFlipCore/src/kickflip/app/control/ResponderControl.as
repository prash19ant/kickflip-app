package kickflip.app.control
{
	import kickflip.app.AppGlobal;
	import kickflip.app.AppText;
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Strong;
	
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	public class ResponderControl extends Sprite
	{
		
		private static const ANSWER_CORRECT_COLORS:Array = [0x77b611, 0x2b4106];
		private static const ANSWER_INCORRECT_COLORS:Array = [0xe4320a, 0x511103];
		private var modal:Sprite;
		private var modalColor:uint = 0x000000;
		private var panelWidth:uint = 350;
		private var panelHeight:uint = 180;
		private var controlWidth:uint;
		private var controlHeight:uint;
		private var panel:Sprite;
		private var text:String = "";
		private static const DropHideEffect:uint = 1;
		private var correct:Boolean = false;
		private var label:Sprite;
		private var closeButton:CoolButton;
		private var blink:Sprite;
		private var displayType:uint;
		private var fontSize:uint = 28;
		private var autoClose:Boolean = false;
		
		public function ResponderControl(controlWidth:uint = 0, controlHeight:uint = 0, displayType:uint = ResponderDisplayTypeEnum.POPUP, fontSize:uint = 28)
		{
			super();
			this.controlWidth = controlWidth;
			this.controlHeight = controlHeight;
			this.displayType = displayType;
			this.fontSize = fontSize;
			addEventListener(Event.ADDED_TO_STAGE, initStage);
		}
		
		private function initStage(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initStage);
			controlWidth = controlWidth > 0 ? controlWidth : stage.stageWidth;
			controlHeight = controlHeight > 0 ? controlHeight : stage.stageHeight;
			switch(displayType)
			{
				case ResponderDisplayTypeEnum.BLINK:
				{
					fontSize = 26;
					initBlink();
					break;
				}
				default:
				{
					fontSize = 28;
					initPopup();
					break;
				}
			}
			visible = false;
		}
		
		private function initPopup():void
		{
			buildModal();
			buildPanel();
		}
		
		private function initBlink():void
		{
			buildBlink();
		}

		private function buildModal():void
		{
			var modalWidth:uint = controlWidth;
			var modalHeight:uint = controlHeight;
			modal = new Sprite();
			modal.graphics.beginFill(modalColor,0.7);
			modal.graphics.drawRect(0,0, modalWidth, modalHeight);
			modal.graphics.endFill();
			addChild(modal);
			modal.alpha = 0;
		}
		
		private function buildPanel():void
		{
			panel = new Sprite();
			drawBasePanel();
			addChild(panel);
			label = new Sprite();
			panel.addChild(label);
			closeButton = getCloseButton();
			panel.addChild(closeButton);
			panel.x = controlWidth/2 - panel.width/2;
			panel.y = controlHeight/2 - panel.height/2;
			panel.alpha = 0;
		}
		
		public function display(correct:Boolean, forcedText:String = "", autoClose:Boolean = false):void
		{
			if(forcedText != "")
			{
				text = forcedText;
			} else {
				text = correct ? getRandomAnswer(AppText.ANSWER_CORRECT) : getRandomAnswer(AppText.ANSWER_INCORRECT);
			}
			this.correct = correct;
			this.autoClose = autoClose;
			if(closeButton)
				closeButton.visible = !autoClose;
			initDisplay();
		}

		private function getRandomAnswer(list:Array):String
		{
			var idx:uint = Utils.random(0, list.length);
			return list[idx];
		}
		
		private function initDisplay():void
		{
			switch(displayType)
			{
				case ResponderDisplayTypeEnum.BLINK:
				{
					initDisplayBlink();
					break;
				}
				default:
				{
					initDisplayPopup();
					break;
				}
			}
		}
		
		private function initDisplayPopup():void
		{
			buildLabel();
			visible = true;
			initModal();
			configureListener();
		}

		private function configureListener():void
		{
			if(stage == null) return;
			if(!stage.hasEventListener(KeyboardEvent.KEY_DOWN))
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		private function removeListener():void
		{
			if(stage == null) return;
			if(stage.hasEventListener(KeyboardEvent.KEY_DOWN))
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		private function keyDownHandler(event:KeyboardEvent) : void
		{
			if (event.keyCode == Keyboard.ESCAPE)
			{
				panelHide(null);
			}
		}
		
		private function initModal():void
		{
			modal.alpha = 0;
			panel.alpha = 0
			var modalTween:TweenLite = new TweenLite(modal, 0.5, {
				ease:Strong.easeOut,
				alpha:1
			});
			panelShow();
		}
		
		private function drawBasePanel():void
		{
			var colors:Array = correct ? ANSWER_CORRECT_COLORS : ANSWER_INCORRECT_COLORS;
			
			var base:Sprite = new Sprite();
			var alphas:Array = [ 1, 1 ];
			var ratios:Array = [ 0x00, 0xFF ];
			var matrix:Matrix = new Matrix();
			var rounded:uint = 10;
			matrix.createGradientBox(panelWidth, panelHeight, (Math.PI / 2), 0, 0);
			panel.graphics.clear();
			panel.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.PAD);
			panel.graphics.drawRoundRect(0, 0, panelWidth, panelHeight, rounded, rounded);
			panel.graphics.endFill();
			var filterD:DropShadowFilter = new DropShadowFilter(0, 60, 0x000000, .5, 10, 10, 1, 3, false, false, false);
			panel.filters = [filterD];
		}
		
		private function buildLabel(twidth:uint = 0, theight:uint = 0):TextField
		{
			label.removeChildren();
			var headerHeight:uint = 50;
			var textPadding:uint = 15;
			var txtWidth:uint = twidth>0 ? twidth : panelWidth - textPadding*2;
			var txtHeight:uint = theight>0 ? theight : panelHeight - headerHeight - textPadding;
			var txt:TextField = buildText( {
				width : txtWidth,
				height : txtHeight,
				text : text,
				color : 0xffffff
			} );
			txt.x = textPadding;
			txt.y = headerHeight;
			label.addChild(txt);
			txt.x = panelWidth/2 - txt.width/2;
			txt.y = panelHeight/2 - txt.height/2 - (autoClose ? 0: 20);
			return txt;
		}
		
		private function getCloseButton():CoolButton
		{
			var btnWidth:uint = 100;
			var btnheight:uint = 30;
			var closeBtn:CoolButton = new CoolButton(AppText.CLOSE, btnWidth, btnheight);
			closeBtn.addEventListener(CoolButton.EVENT_CLICK, panelHide);
			closeBtn.x = panelWidth/2 - btnWidth/2;
			closeBtn.y = panelHeight - btnheight - 10;
			return closeBtn;
		}
		
		private function buildText(config:Object) : TextField
		{
			var text:String = (config.text != undefined)?config.text:"";
			var width:uint = (config.width != undefined)?config.width:120;
			var height:uint = (config.height != undefined)?config.height:18;
			var color:uint = (config.color != undefined)?config.color:0xffffff;
			var format:TextFormat = new TextFormat();
			format.font = AppGlobal.FONT_TYPE;
			format.color = color;
			format.size = fontSize;
			format.align = "center";
			format.bold = true;
			var txt:TextField = new TextField();
			txt.selectable = false;
			txt.width = width;
			txt.height = height;
			txt.wordWrap = true;
			txt.defaultTextFormat = format;
			txt.text = text;
			txt.autoSize = TextFieldAutoSize.CENTER;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.gridFitType = GridFitType.PIXEL;
			return txt;
		}
		
		private function panelShow():void
		{
			drawBasePanel();
			var panelScale:Number = 1.5;
			panel.scaleX = panelScale;
			panel.scaleY = panelScale;
			panel.x = controlWidth/2 - panel.width/2;
			panel.y = controlHeight/2 - panel.height/2;
			var posx:uint = controlWidth/2 - panelWidth/2;
			var posy:uint = controlHeight/2 - panelHeight/2;
			var panelTween:TweenLite = new TweenLite(panel,0.5,{
				ease:Strong.easeInOut, alpha:1,
				x:posx, y:posy,
				width:panelWidth,
				height:panelHeight,
				onComplete:waitAndClose
			});
		}
		
		private function waitAndClose():void
		{
			if(autoClose)
			{
				new TweenLite(panel,3,{
					onComplete:panelHide
				});
			}
		}
		
		private function panelHide(evt:Event = null):void
		{
			var posy:int = stage.stageHeight + 50;
			var spriteTween:TweenLite = new TweenLite(panel,0.5,{
				ease:Strong.easeInOut,
				y:posy,
				onComplete:modalHide
			});
		}
		
		private function modalHide():void
		{
			var modalTween:TweenLite = new TweenLite(modal,0.7,{
				ease:Strong.easeOut,
				alpha:0,
				onComplete:close
			});
		}
		
		private function close():void
		{
			removeListener();
			visible = false;
			dispatchEvent(new ResponderEvent(ResponderEvent.RESPONSE_CLOSED, correct));
		}
		
		private function buildBlink():void
		{
			blink = new Sprite();
			addChild(blink);
			blink.alpha = 0;
			label = new Sprite();
			blink.addChild(label);
		}
		
		private function initDisplayBlink():void
		{
			fillBlink();
			var txt:TextField = buildLabel(controlWidth);
			txt.x = 0;
			txt.y = controlHeight/2 - txt.textHeight/2;
			visible = true;
			label.alpha = 1;
			new TweenMax(label, 1, {
				ease:Strong.easeOut,
				alpha:1,
				onComplete:function():void
				{
					var modalTween:TweenLite = new TweenLite(blink,1,{
						ease:Strong.easeOut,
						alpha:0,
						onComplete:close
					});
				}
			});
		}
		
		private function fillBlink():void
		{
			var colors:Array = correct ? ANSWER_CORRECT_COLORS : ANSWER_INCORRECT_COLORS;

			var base:Sprite = new Sprite();
			var alphas:Array = [ 1, 1 ];
			var ratios:Array = [ 0x00, 0xFF ];
			var matrix:Matrix = new Matrix();
			var rounded:uint = 10;
			matrix.createGradientBox(panelWidth, panelHeight, (Math.PI / 2), 0, 0);
			blink.graphics.clear();
			blink.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.PAD);
			blink.graphics.drawRoundRect(0, 0, controlWidth, controlHeight, rounded, rounded);
			blink.graphics.endFill();
			var filterD:DropShadowFilter = new DropShadowFilter(0, 60, 0x000000, .5, 10, 10, 1, 3, false, false, false);
			blink.filters = [filterD];
			blink.alpha = 1;
		}
		
		public function dispose():void
		{
			removeListener();
		}
	}
}