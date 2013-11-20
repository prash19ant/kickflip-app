package flipviw.app.manager
{
	import flipviw.app.AppGlobal;
	
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	public class ContextMenuManager
	{
		public static function getContextMenu():ContextMenu
		{
			var mainMenu:ContextMenu = new ContextMenu();
			var itemVer:ContextMenuItem = new ContextMenuItem("Versión "+ AppGlobal.VERSION);
			mainMenu.hideBuiltInItems();
			mainMenu.customItems.push(itemVer);
			return mainMenu;
		}
	}
}