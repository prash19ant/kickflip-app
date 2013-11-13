package flippub.app.setting.parser
{
	import icbc.nav.entity.Content;
	import icbc.nav.entity.Tip;

	public class ContentParser extends Parser
	{
		private static const CONTENT_IMAGE:String = "image"; 
		private static const CONTENT_PATH:String = "path"; 
		private static const CONTENT_TEXT:String = "text"; 
		private static const CONTENT_TIPS:String = "tips"; 
		private static const CONTENT_TIP:String = "tip"; 
		private static const TIP_NAME:String = "name"; 
		private static const TIP_TEXT:String = "text"; 
		private static const TIP_X:String = "x"; 
		private static const TIP_Y:String = "y"; 
		
		public function ContentParser(xmlData:XML)
		{
			content = buildContent(xmlData["content"]);
		}
		
		private var _content:Content = null;
		public function get content():Content { return _content; }
		public function set content(value:Content):void
		{
			_content = value;
		}
		
		private function buildContent(node:XMLList):Content
		{
			var item:Content = new Content();
			item.image = node[CONTENT_IMAGE].@[CONTENT_PATH];
			item.text = node[CONTENT_TEXT];
			item.tips = buildTips(node[CONTENT_TIPS]);
			return item;
		}
		
		private function buildTips(nodes:XMLList):Vector.<Tip>
		{
			var list:Vector.<Tip> = new Vector.<Tip>();
			for each(var node:XML in nodes[CONTENT_TIP])
			{
				list.push(buildTip(node));
			}
			return list;
		}			

		private function buildTip(node:XML):Tip
		{
			var item:Tip = new Tip();
			item.name = node.@[TIP_NAME];
			item.x = int(node.@[TIP_X]);
			item.y = int(node.@[TIP_Y]);
			item.image = node["image"].@["path"];
			return item;
		}
	}
}