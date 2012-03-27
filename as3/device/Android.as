package device
{
	import flash.desktop.NativeApplication;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class Android
	{
		private var game:DieAntsDie;
		
		public function Android($game:DieAntsDie) {
			game = $game;
			
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onExit);
			game.$.addEventListener(KeyboardEvent.KEY_DOWN, checkKey); 			
		}
		
		function onExit(event:Event):void {
			game.db.storeProgress();
			NativeApplication.nativeApplication.exit();
		}
		
		function checkKey(e:KeyboardEvent):void { 
			if(e.keyCode == Keyboard.MENU || e.keyCode == Keyboard.ENTER)  { 
				game.views.showMenu();		 
			}
		}
	}
}