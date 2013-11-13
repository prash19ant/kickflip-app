package flippub.app.data
{
	import flippub.app.AppGlobal;
	import flippub.app.StatusCode;
	import flippub.app.control.Alert;
	import flippub.app.model.ServiceResponse;
	import flippub.app.translator.ServiceTranslator;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.getQualifiedClassName;
	
	import org.osflash.signals.Signal;

	public class AppData
	{
		public static const JOB_GET:String = "GET";
		public static const JOB_SAVE:String = "SAVE";
		public static const JOB_SETALL:String = "SETALL";
		public static const JOB_REMOVE:String = "REMOVE";
		
		private var service:String = "";
		public var job:String = "";
		private var url:String = "";
		
		public var dataComplete:Signal = new Signal(ServiceResponse);
		
		public function AppData()
		{
			this.url = AppGlobal.DataServiceEndPoint;
		}
		
		public function load(caller:Object, job:String, request:Object = null, method:String = null):void
		{
			setServiceName(caller);
			this.job = job;
			var loader:URLLoader = new URLLoader();
			addListeners(loader);
			
			var urlRequest:URLRequest = new URLRequest();
			if(request)
			{
				var reqdata:URLVariables = new URLVariables();
				var mainJson:String = JSON.stringify(request, deflate);
				reqdata.main = mainJson;
				urlRequest.data = reqdata;
			}
			urlRequest.method = method != null ? method : getMethodByJob();
			urlRequest.url = getUrlByService();
			
			loader.load(urlRequest);
		}
		
		public function login(userName:String, userPass:String):void
		{
			var loader:URLLoader = new URLLoader();
			addLoginListeners(loader);
			
			var reqdata:URLVariables = new URLVariables();
			reqdata.userName = userName;
			reqdata.userPass = userPass;
			reqdata.source = "CesviClient";
			var request:URLRequest = new URLRequest();
			request.data = reqdata;
			request.method = URLRequestMethod.POST;
			request.url = AppGlobal.LoginEndPoint;
			
			loader.load(request);
		}
		
		private function addListeners(dispatcher:EventDispatcher):void
		{
			if(!dispatcher.hasEventListener(Event.COMPLETE))
				dispatcher.addEventListener(Event.COMPLETE, dataLoaded);
			if(!dispatcher.hasEventListener(IOErrorEvent.IO_ERROR))
				dispatcher.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		private function removeListeners(dispatcher:EventDispatcher):void
		{
			dispatcher.removeEventListener(Event.COMPLETE, dataLoaded);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		private function addLoginListeners(dispatcher:EventDispatcher):void
		{
			if(!dispatcher.hasEventListener(Event.COMPLETE))
				dispatcher.addEventListener(Event.COMPLETE, dataLoginLoaded);
			if(!dispatcher.hasEventListener(IOErrorEvent.IO_ERROR))
				dispatcher.addEventListener(IOErrorEvent.IO_ERROR, onLoginIOError);
		}
		
		private function removeLoginListeners(dispatcher:EventDispatcher):void
		{
			dispatcher.removeEventListener(Event.COMPLETE, dataLoginLoaded);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, onLoginIOError);
		}
		
		private function dataLoaded(evt:Event):void
		{
			removeListeners(evt.target as URLLoader);
			
			var data:String = URLLoader(evt.target).data;
			var response:ServiceResponse = ServiceTranslator.translate(data);
			
			if(response.status.code != StatusCode.OK)
			{
				Alert.show(response.status.message);
			}
			dataComplete.dispatch(response);
		}
		
		private function dataLoginLoaded(evt:Event):void
		{
			removeLoginListeners(evt.target as URLLoader);
			dataComplete.dispatch(ServiceTranslator.translate(URLLoader(evt.target).data));
		}
		
		private function onIOError(evt:IOErrorEvent):void
		{
			removeLoginListeners(evt.target as URLLoader);
			Alert.show(evt.text);
			AppGlobal.endWait();
		}		
		
		private function onLoginIOError(evt:IOErrorEvent):void
		{
			removeListeners(evt.target as URLLoader);
			var response:ServiceResponse = new ServiceResponse();
			response.status.code = StatusCode.ERROR;
			response.status.message = evt.text; 
			dataComplete.dispatch(response);
		}		
		
		private function setServiceName(value:Object):void
		{
			service = getQualifiedClassName(value).split("::")[1];
		}
		
		private function getUrlByService():String
		{
			return url +"/"+ service +"/"+ getUriByJob();
		}
		
		private function getUriByJob():String
		{
			var uri:String;
			switch(job)
			{
				case JOB_GET:
				{
					uri = "";
					break;
				}
				case JOB_SAVE:
				{
					uri = JOB_SAVE.toLowerCase();
					break;
				}
				case JOB_REMOVE:
				{
					uri = JOB_REMOVE.toLowerCase();
					break;
				}
				default:
				{
					uri = job;
					break;
				}
			}
			return uri;
		}
		
		private function getMethodByJob():String
		{
			var returned:String;
			switch(job)
			{
				case JOB_SAVE:
				case JOB_REMOVE:
				{
					returned = URLRequestMethod.POST;
					break;
				}
				default:
				{
					returned = URLRequestMethod.GET;
					break;
				}
			}
			return returned;
		}
		
		protected function deflate( key:String, value:* ):*
		{
			return ( key.toUpperCase() == "eventDispatcher".toUpperCase() ) ? undefined : value;
		}
	}
}