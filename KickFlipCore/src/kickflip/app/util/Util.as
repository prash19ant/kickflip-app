package kickflip.app.util
{
	import kickflip.app.util.logger.Log;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.utils.describeType;
	
	import mx.utils.StringUtil;

	public class Util
	{
		public static function random(min:Number, max:Number):Number
		{
			return min + Math.random() * (max - min);
		}
		
		public static function stringToDate(txt:String):Date
		{
			var date:Date = null;
			try {
				var year:Number = txt.split("-")[0];
				var month:Number = txt.split("-")[1];
				var day:Number = txt.split("-")[2].split("T")[0];
				var hours:Number = 0;
				var minutes:Number = 0;
				var seconds:Number = 0;
				if(txt.length>10)
				{
					hours = txt.split("T")[1].split(":")[0];
					minutes = txt.split("T")[1].split(":")[1];
					seconds = txt.split("T")[1].split(":")[2];
				}
				date = new Date(year,(month-1),day, hours, minutes, seconds);
			} catch(err:Error){
				Log.Error("Utils.stringToDate Error > " + err.message +" ("+txt+")");
				throw new Error("Utils.stringToDate Error > " + err); 
			}
			return date;
		}
		
		public static function shuffleVectorSort( a:Object, b:Object ):int
		{
			return Math.floor( Math.random() * 3 - 1 );
		}
		
		public static function drawStar(graphics:Graphics, innerRadius:Number, outerRadius:Number, amountCorners:int, angleOffset:Number=0):void
		{
			/*
			var angleStep:Number = Math.PI/amountCorners;
			var angle:Number = angleOffset;
			with(graphics)
			{
			for(var idx:int = 0; idx<amountCorners; ++idx, angle += angleStep)
			{
			if(idx == 0)
			{
			moveTo(
			Math.cos( angle ) * innerRadius,
			Math.sin( angle ) * innerRadius
			);
			}
			else
			{
			lineTo(
			Math.cos( angle ) * innerRadius,
			Math.sin( angle ) * innerRadius
			);
			}
			angle += angleStep;
			lineTo(
			Math.cos( angle ) * outerRadius,
			Math.sin( angle ) * outerRadius
			);
			}
			}*/
		}
		
		public static function translate(source:Object, target:Object):Object
		{
			var sourceXMLAccessor:XMLList = describeType(source)..variable;
			for each(var key:String in describeType(target)..variable.@name)
			{
				if(typeof(target[key]) == "object")
				{
					target[key] = source[key];
				} else {
					if(itemExist(sourceXMLAccessor, key))
					{
						target[key] = source[key];
					}
				}
			}
			return target;
		}
		
		private static function itemExist(sourceXMLAccessor:XMLList, itemName:String):Boolean
		{
			return sourceXMLAccessor.(@name==itemName).length()>0;
		}
		
		public static function removeAccent(chaine:String):String 
		{
			var accent:String =     "ÀÁÂÃÄÅàáâãäåÒÓÔÕÖØòóôõöøÈÉÊËèéêëÌÍÎÏìíîïÙÚÛÜùúûüÿÇç";
			var sansAccent:String = "AAAAAAaaaaaaOOOOOOooooooEEEEeeeeIIIIiiiiUUUUuuuuyCc";
			
			var listSansAccent:Array = sansAccent.split("");
			var listAccent:Array = accent.split("");
			
			for(var i:uint=0; i<accent.length; i++) 
			{
				chaine = chaine.split(listAccent[i].toString()).join(listSansAccent[i].toString());
			}
			return chaine;
		}
		
		public static function mergeXMLlists(list1:XMLList, list2:XMLList):XMLList
		{
			var items:XML = <xml/>;
			
			var item:XML;
			for each (item in list1)
			items.appendChild(item);
			
			for each (item in list2)
			items.appendChild(item);
			
			return items.children();
		}
	}
}