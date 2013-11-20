package flipviw.app.control
{
	import flipviw.app.manager.FontManager;
	import cesvi.quiz.manager.InputStyleManager;
	import cesvi.quiz.manager.SkinStyleManager;
	import cesvi.quiz.model.InputStyle;
	
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;

	public class LabelInput extends Sprite
	{
		public static var defaultLabelWidth:uint = 120;
		public static var defaultLabelHeight:uint = 40;
		public static var defaultInputWidth:uint = 180;
		public static var defaultInputHeight:uint = 40;
		public static var defaultInputOrientation:uint = inputOrientationRight;
		public static var inputOrientationRight:uint = 0;
		public static var inputOrientationLeft:uint = 1;
		public static var inputOrientationBottom:uint = 2;
		public static var textInputType:uint = 0;
		public static var comboBoxType:uint = 1;
		public static var checkBoxType:uint = 2;
		public static var defaultStyle:InputStyle = InputStyleManager.instance.defaultStyle;
		public static function clearStyle():void
		{ 
			defaultStyle = InputStyleManager.instance.defaultStyle; 
			defaultLabelWidth = 120;
			defaultLabelHeight = 40;
			defaultInputWidth = 180;
			defaultInputHeight = 40;
			defaultInputOrientation = inputOrientationRight;
		}
		
		public var labelWidth:uint = defaultLabelWidth;
		public var labelHeight:uint = defaultLabelHeight;
		public var inputWidth:uint = defaultInputWidth;
		public var inputHeight:uint = defaultInputHeight;
		public var inputOrientation:uint = defaultInputOrientation;
		public var type:uint = textInputType;
		public var textAlignLabel:String = "";
		
		private var buildMap:Dictionary;
		private var valueInputMap:Dictionary;
		public var label:Label;
		public var inputTextBox:TextInput;
		public var inputComboBox:ComboBox;
		public var inputCheckBox:CheckBoxControl;
		private var labelText:String;
		public var labelOnly:Boolean = false;
		public var maxChars:uint = 400;
		public var displayAsPassword:Boolean = false;
		public var style:InputStyle;
		public var onFocusIn:Signal = new Signal();
		public var onFocusOut:Signal = new Signal();
		
		public function LabelInput(labelText:String, style:InputStyle = null)
		{
			this.labelText = labelText;
			this.style = style == null ? defaultStyle : style;
			setMaps();
		}
		
		private function setMaps():void
		{
			buildMap = new Dictionary();
			buildMap[textInputType] = buildTextInput;
			buildMap[comboBoxType] = buildComboBox;
			buildMap[checkBoxType] = buildCheckBox;
			
			valueInputMap = new Dictionary();
			valueInputMap[textInputType] = getTextInputValue;
			valueInputMap[comboBoxType] = getComboBoxValue;
			valueInputMap[checkBoxType] = getCheckBoxValue;
		}
		
		public function display():void
		{
			var gapx:uint = 15;
			var posx:uint = 0;
			var textAlign:String = inputOrientation == inputOrientationRight ? "right" : "left";
			textAlign = textAlignLabel == "" ? textAlign : textAlignLabel;
			label = new Label(labelText, style, labelWidth, labelHeight, textAlign);
			addChild(label);
			label.x = posx; posx += label.width+gapx;
			
			if(labelOnly)
				return;
			
			var sprite:Sprite = buildMap[type]();
			setPosition(posx, sprite);
		}
		
		private function setPosition(posx:uint, sprite:Sprite):void
		{
			switch(inputOrientation)
			{
				case inputOrientationRight:
				{
					sprite.x = posx;
					break;
				}
				case inputOrientationLeft:
				{
					label.x = sprite.width + 5;
					label.y = sprite.height/2 - label.height/2;
					break;
				}
				case inputOrientationBottom:
				{
					sprite.y = label.y + labelHeight + 10;
					break;
				}
				default:
				{
					sprite.x = posx;
					break;
				}
			}
		}
		
		private function buildTextInput():Sprite
		{
			inputTextBox = new TextInput(style, inputWidth, inputHeight);
			inputTextBox.maxChars = maxChars;
			inputTextBox.displayAsPassword = displayAsPassword;
			inputTextBox.textInput
			inputTextBox.onFocusIn.add(function():void{ onFocusIn.dispatch() });
			inputTextBox.onFocusOut.add(function():void{ onFocusOut.dispatch() });
			inputTextBox.display();
			addChild(inputTextBox);
			return inputTextBox;
		}
		
		private function buildComboBox():Sprite
		{
			inputComboBox = new ComboBox();
			inputComboBox.width = inputWidth;
			inputComboBox.height = inputHeight;
			
			var format:TextFormat = new TextFormat();
			format.size = 16;
			format.color = 0xffffff;
			format.font = FontManager.instance.TradeGothicLgCn;
			var format2:TextFormat = new TextFormat();
			format2.size = 16;
			format2.color = 0xffffff;
			format2.font = FontManager.instance.TradeGothicLgCn;
			inputComboBox.textField.setStyle("textFormat", format);
			inputComboBox.textField.setStyle("embedFonts", true);
			inputComboBox.dropdown.rowHeight = 30;
			inputComboBox.dropdown.setRendererStyle("textFormat", format2);
			inputComboBox.dropdown.setRendererStyle("embedFonts", true);

			SkinStyleManager.instance.stylizeComboBox(inputComboBox);
			addChild(inputComboBox);
			return inputComboBox;
		}
		
		private function buildCheckBox():Sprite
		{
			inputCheckBox = new CheckBoxControl(style);
			inputCheckBox.appWidth = inputHeight;
			inputCheckBox.appHeight = inputHeight;
			inputCheckBox.display();
			addChild(inputCheckBox);
			inputOrientation = inputOrientationLeft;
			return inputCheckBox;
		}
		
		public function get textInput():TextField
		{
			return inputTextBox.textInput;
		}
		
		private var _isValid:Boolean = true;
		public function get isValid():Boolean { return _isValid; }
		public function set isValid(value:Boolean):void
		{ 
			_isValid = value;
			invalided = !value;
		}
		private function set invalided(value:Boolean):void
		{
			if(inputTextBox == null)
				return;
			inputTextBox.invalided = value;
		}
		
		private function getTextInputValue():String
		{
			var result:String = "";
			if(inputTextBox != null)
			{
				result = inputTextBox.textInput.text;
			}
			return result;		
		}
		private function getComboBoxValue():String
		{
			var result:String = "";
			if(inputComboBox != null)
			{
				result = inputComboBox.selectedLabel;
			}
			return result;		
		}
		private function getCheckBoxValue():String
		{
			var result:String = "";
			if(inputCheckBox != null)
			{
				result = inputCheckBox.checked ? "1" : "0";
			}
			return result;
		}

		public function getValue():String
		{
			return valueInputMap[type]();
		}
	}
}