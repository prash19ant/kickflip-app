package flippub.app.translator
{
	import flippub.app.model.ServiceResponse;
	
	import flash.utils.getQualifiedClassName;
	
	public class ServiceTranslator extends Translator
	{
		public static function translate(dataText:String):ServiceResponse
		{
			var data:Object = JSON.parse(dataText);
			var item:ServiceResponse = translateFromObject(data, getQualifiedClassName(ServiceResponse)) as ServiceResponse;
			item.rawdata = data["Result"];
			return item;
		}
	}
}