package device
{
	import flash.events.Event;
	
	import flash.desktop.NativeApplication;
	import qnx.events.QNXApplicationEvent;
	import qnx.system.QNXApplication;
	
	public class Blackberry
	{
		private var game:DieAntsDie;
		
		public function Blackberry($game:DieAntsDie) {
			game = $game;
			
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onExit);
			QNXApplication.qnxApplication.addEventListener(QNXApplicationEvent.SWIPE_DOWN, showNativeMenu);	
		}
				
		private function onExit(event:Event):void {
			game.db.storeProgress();
			NativeApplication.nativeApplication.exit();
		}
		
		private function showNativeMenu(e:QNXApplicationEvent):void {
			game.views.showMenu();
		}
	}
}