package kickflip.app.control
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.controls.Text;
	
	import kickflip.app.AppGlobal;
	import seg.core.game.Session;
	import seg.core.model.CardLevel;
	import seg.core.model.LevelModel;
	import seg.core.model.MazeLevel;
	import seg.core.model.SoupLevel;
	import seg.core.model.WordLevel;
	
	public class ProgressControl extends Sprite
	{
		private var incorrectSoundPath:String = "";
		private var correctSoundPath:String = "";
		private var gapw:uint = 130;
		private var fontSize:uint = 15;
		private var level1:TextField;
		private var level2:TextField;
		private var level3:TextField;
		private var currentLevel:uint = 0;
		private const posxlevel1:uint = 0;
		private const posxlevel2:uint = 131;
		private const posxlevel3:uint = 264;
		private var level1total:uint = 0;
		private var level2total:uint = 0;
		private var level3total:uint = 0;
		private var indicator1:ProgressIndicatorControl;
		private var indicator2:ProgressIndicatorControl;
		private var indicator3:ProgressIndicatorControl;
		private var levelTextWidth:uint = 42;
		private var levelTextHeight:uint = 25;
		private var correctSound:Sound;
		private var incorrectSound:Sound;
		private var soundChannel:SoundChannel
		
		public function ProgressControl()
		{
			super();
			x = 248;
			y = 535;
			incorrectSoundPath = Session.getInstance().style.sound.incorrect;
			correctSoundPath = Session.getInstance().style.sound.correct;
			init();
		}
		
		private function init():void
		{
			var indiPosy:Number = -6;
			indicator1 = new ProgressIndicatorControl();
			addChild(indicator1);
			indicator1.x = -1;
			indicator1.y = indiPosy;
			
			indicator2 = new ProgressIndicatorControl();
			addChild(indicator2);
			indicator2.x = 131;
			indicator2.y = indiPosy;

			indicator3 = new ProgressIndicatorControl();
			addChild(indicator3);
			indicator3.x = 263;
			indicator3.y = indiPosy;

			level1 = buildProgress();
			addChild(level1);
			level1.x = posxlevel1;

			level2 = buildProgress();
			addChild(level2);
			level2.x = posxlevel2;

			level3 = buildProgress();
			addChild(level3);
			level3.x = posxlevel3;
			
			initSound();
		}
		
		private function buildProgress():TextField
		{
			return buildText("0/0");
		}
		
		public function nextLevel():void
		{
			currentLevel++;
			setActiveLevel();
		}

		public function setCurrent(current:uint):void
		{
			switch(currentLevel)
			{
				case 1:
					level1.text = current+"/"+level1total;
					break;
				case 2:
					level2.text = current+"/"+level2total;
					break;
				case 3:
					level3.text = current+"/"+level3total;
					break;
			}
		}

		private function buildText(text:String, format:TextFormat = null):TextField
		{
			var txt:TextField = new TextField();
			txt.selectable = false;
			txt.defaultTextFormat = format ? format : inactiveFormat;
			txt.text = text;
			txt.width = levelTextWidth;
			txt.height = levelTextHeight;
			return txt;
		}
		
		private function get inactiveFormat():TextFormat
		{
			var format:TextFormat = new TextFormat();
			format.font = AppGlobal.FONT_TYPE;
			format.color = 0x555555;
			format.size = fontSize;
			format.bold = true;
			format.align = "center";
			return format;
		}

		private function get activeFormat():TextFormat
		{
			var format:TextFormat = new TextFormat();
			format.font = AppGlobal.FONT_TYPE;
			format.color = 0x000000;
			format.size = fontSize;
			format.bold = true;
			format.align = "center";
			return format;
		}
		
		public function setLevels(levels:Object):void
		{
			if(levels is Vector.<MazeLevel>)
			{
				setMazeLevels(levels as Vector.<MazeLevel>);
			}
			if(levels is Vector.<CardLevel>)
			{
				setCardLevels(levels as Vector.<CardLevel>);
			}
			if(levels is Vector.<WordLevel>)
			{
				setWordLevels(levels as Vector.<WordLevel>);
			}
			if(levels is Vector.<SoupLevel>)
			{
				setSoupLevels(levels as Vector.<SoupLevel>);
			}
			level1.text = "0/"+level1total;
			level2.text = "0/"+level2total;
			level3.text = "0/"+level3total;
		}
		
		private function setMazeLevels(levels:Vector.<MazeLevel>):void
		{
			for(var i:uint = 0; i<levels.length; i++)
			{
				switch(i)
				{
					case 0:
						level1total = levels[0].limit;
						break;
					case 1:
						level2total = levels[1].limit;
						break;
					case 2:
						level3total = levels[2].limit;
						break;
				}
			}
		}
		
		private function setActiveLevel():void
		{
			level1.defaultTextFormat = inactiveFormat;
			level2.defaultTextFormat = inactiveFormat;
			level3.defaultTextFormat = inactiveFormat;
			switch(currentLevel)
			{
				case 1:
					level1.defaultTextFormat = activeFormat;
					break;
				case 2:
					level2.defaultTextFormat = activeFormat;
					break;
				case 3:
					level3.defaultTextFormat = activeFormat;
					break;
			}
		}

		private function setCardLevels(levels:Vector.<CardLevel>):void
		{
			for(var i:uint = 0; i<levels.length; i++)
			{
				switch(i)
				{
					case 0:
						level1total = levels[0].limit;
						break;
					case 1:
						level2total = levels[1].limit;
						break;
					case 2:
						level3total = levels[2].limit;
						break;
				}
			}
		}

		private function setWordLevels(levels:Vector.<WordLevel>):void
		{
			for(var i:uint = 0; i<levels.length; i++)
			{
				switch(i)
				{
					case 0:
						level1total = levels[0].limit;
						break;
					case 1:
						level2total = levels[1].limit;
						break;
					case 2:
						level3total = levels[2].limit;
						break;
				}
			}
		}

		private function setSoupLevels(levels:Vector.<SoupLevel>):void
		{
			for(var i:uint = 0; i<levels.length; i++)
			{
				switch(i)
				{
					case 0:
						if(levels.length>0 && levels[0].soups.length>0)
							level1total = levels[0].soups[0].responses.length;
						break;
					case 1:
						if(levels.length>1 && levels[1].soups.length>0)
							level2total = levels[1].soups[0].responses.length;
						break;
					case 2:
						if(levels.length>2 && levels[2].soups.length>0)
							level3total = levels[2].soups[0].responses.length;
						break;
				}
			}
		}
		
		public function setSoupLevel(levels:Vector.<SoupLevel>, levelIndex:uint, responseTotal:uint):void
		{
			switch(levelIndex)
			{
				case 0:
					level1total = responseTotal;
					level1.text = "0/"+level1total;
					break;
				case 1:
					level2total = responseTotal;
					level2.text = "0/"+level2total;
					break;
				case 2:
					level3total = responseTotal;
					level3.text = "0/"+level3total;
					break;
			}
		}
		
		public function showCorrect(correct:Boolean):void
		{
			if(correct)
			{
				showGreen();
				playCorrectSound();
			} else {
				showRed();
				playIncorrectSound();
			}
		}

		private function showGreen():void
		{
			switch(currentLevel)
			{
				case 1:
					indicator1.showGreen();
					break;
				case 2:
					indicator2.showGreen();
					break;
				case 3:
					indicator3.showGreen();
					break;
			}
		}
		
		private function showRed():void
		{
			switch(currentLevel)
			{
				case 1:
					indicator1.showRed();
					break;
				case 2:
					indicator2.showRed();
					break;
				case 3:
					indicator3.showRed();
					break;
			}
		}

		private function initSound():void
		{
			soundChannel = new SoundChannel();

			incorrectSound = new Sound();
			incorrectSound.load(new URLRequest(incorrectSoundPath));
			incorrectSound.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
			correctSound = new Sound();
			correctSound.load(new URLRequest(correctSoundPath));
			correctSound.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
		}
		
		private function onIOError(evt:IOErrorEvent):void
		{
			trace("ProgressControl.Sound.IOError: "+ evt.text);
		}		
		
		private function playIncorrectSound():void
		{
			soundChannel = incorrectSound.play();
		}

		private function playCorrectSound():void
		{
			soundChannel = correctSound.play();
		}
	}
}