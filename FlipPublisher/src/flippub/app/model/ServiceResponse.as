package flippub.app.model
{
	public class ServiceResponse
	{
		public var status:Status;
		public var errors:Array = [];
		public var result:Object = null;
		public var task:String = "";
		public var rawdata:Object = null;
		
		public function ServiceResponse(task:String = "")
		{
			status = new Status();
			this.task = task;
		}
	}
}