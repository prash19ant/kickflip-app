package kickflip.app.translator
{
	import kickflip.app.util.Util;
	import kickflip.app.util.logger.Log;
	
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	public class Translator
	{
		protected static function translateFromObject(data:Object, className:String):Object
		{
			var instance:Object = null;
			try {
				var objectClass:Class = Class(getDefinitionByName(fixClassNamespace(className)))
				instance = new objectClass();
				if(data != null)
					matchInstance(instance, data);
			} catch(err:Error)
			{
				Log.Error("Translator.translateFromObject.Error > "+ err.message);
			}
			return instance;
		}
		
		private static function translateInstanceByClass(type:String, value:Object):Object
		{
			var className:String = fixClassNamespace(type);
			var objectClass:Class = Class(getDefinitionByName(className));
			var instance:Object = new objectClass();
			return instance;
		}
		
		private static function fixClassNamespace(className:String):String
		{
			var packageName:String = className.split("::")[0];
			var modelName:String = className.split("::")[1];
			modelName = modelName.substr(0,1).toUpperCase() + modelName.substr(1,modelName.length);
			return packageName +"."+ modelName;
		}
		
		private static function getDataKeyNonCaseSensitive(key:String, data:Object):String
		{
			var dataKey:String = key;
			for(var sourceKey:String in data)
			{
				if(key.toUpperCase() == sourceKey.toUpperCase())
				{
					dataKey = sourceKey;
				}
			}
			return dataKey;
		}
		
		public static function translateFromType(value:*, type:String):*
		{
			if(type.indexOf("::")>-1)
			{
				return translateFromObject(value,type);
			}
			switch (type.toLowerCase())
			{
				case "date":
				{
					return Util.stringToDate(value.toString());
				}
				case "int": case "int_8": case "int_16": case "int_32":
				{
					var intValue:int = value;
					return intValue;
				}
				case "uint": case "uint_8": case "uint_16": case "uint_32":
				{
					var uintValue:uint = value;
					return uintValue;
				}
				case "number": case "float": case "double":
				{
					var numberValue:Number = value;
					return numberValue;
				}
				case "boolean": case "bool":
				{
					var booleanValue:Boolean = value;
					if (String(value).toLowerCase() == "false" || String(value) == "0")
						booleanValue = false;
					
					if (String(value).toLowerCase() == "true" || String(value) == "1")
						booleanValue = true;
					
					return booleanValue;
				}
				case "array":
				{
					return value;
				}
				case "xml":
				{
					var xmlValue:XML = XML(value);
					return xmlValue;
				}
				case "object": case "obj":
				{
					var objValue:Object = value;
					return objValue;
				}
				case "string": case "char": case "varchar": case "text":
				default:
				{
					var stringValue:String = value;
					return stringValue;
				}
			}
			return value;
		}
		
		private static function matchInstance(instance:Object, data:Object):void
		{
			var info:XML = describeType(instance);
			var vars:XMLList = Util.mergeXMLlists(info..variable, info..accessor);
			for each(var props:XML in vars)
			{
				var key:String = props.@name;
				var dataKey:String = getDataKeyNonCaseSensitive(key, data);
				if(data[dataKey] == undefined)
					continue;
				if(props.@access == "readonly")
					continue;
				instance[key] = translateFromType(data[dataKey], props.@type);
			}
		}
	}
}