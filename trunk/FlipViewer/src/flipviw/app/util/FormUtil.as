package flipviw.app.util
{
	import flipviw.app.control.LabelInput;
	
	import flash.display.Sprite;
	
	import mx.utils.StringUtil;

	public class FormUtil
	{
		public static function isValidEmail(email:String):Boolean
		{
			var emailExpression:RegExp = /([a-z0-9._-]+?)@([a-z0-9.-]+)\.([a-z]{2,4})/;
			return emailExpression.test(email);
		}
		
		public static function checkAllValidInputControl(view:Sprite):Boolean
		{
			var isValid:Boolean = true;
			var index:uint = 0;
			while(isValid && index < view.numChildren)
			{
				var item:LabelInput = view.getChildAt(index) as LabelInput;
				if(item != null)
				{
					if(isValid)
						isValid = item.isValid;
				}
				index++;
			}
			return isValid;
		}
		
		public static function processValidation(validations:Array):void
		{
			var index:uint = 0;
			var isValid:Boolean = true;
			while(isValid && index < validations.length)
			{
				isValid = validations[index]();
				index++;
			}
		}
	}
}