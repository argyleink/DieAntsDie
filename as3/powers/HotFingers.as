package powers
{
	import flash.display.MovieClip;
	import flash.events.TouchEvent;

	public class HotFingers extends MovieClip
	{
		private var game:DieAntsDie;
		public var active:Boolean;
		public var flameActive:Boolean;
		public var prompting:Boolean;
		private var timesActivated:uint;
		
		public var counter:uint;
		public var killed:uint;
		public var antsToKill:uint = 6;
		public var timeToKill:uint = 4;
		private var lengthOfActivation:uint = 3;
		
		private var strikeArea:strike_area = new strike_area();
		public var icon:hot_fingers_icon = new hot_fingers_icon();
		
		public function HotFingers($game:DieAntsDie) { 
			game = $game; 
			strikeArea.y = game.$.stageHeight;
			icon.x = game.$.stageWidth-10-icon.width;
			icon.y = 8;
		}
		
		public function tick():void {
			counter++;
			
			if(active && counter > lengthOfActivation && !prompting) 	{ off(); 		reset(); }
			if(killed >= antsToKill && !prompting) 						{ prompt();  	reset(); }
			if(counter > timeToKill && !prompting) 						{ reset(); }
		}
		
		public function kill():void { killed++; }
		
		private function prompt():void { 
			prompting = true;
			showStrikeArea();
			strikeArea.addEventListener(TouchEvent.TOUCH_BEGIN, strikeMatch);			
			trace('listening for ignite gesture');
		}
		
		private function strikeMatch(e:TouchEvent):void {
			trace('ignited');
			strikeArea.addEventListener(TouchEvent.TOUCH_END, hidePromptHandler);
		}
		private function hidePromptHandler(e:TouchEvent):void {
			on();
			hidePrompt();
		}
		public function hidePrompt():void {
			reset();
			prompting = false;
			if(game._soundEnabled) game.soundEffects.sizzleMatch();
			game.disableTouchKilling();
			game.enableHotFingers();
			strikeArea.removeEventListener(TouchEvent.TOUCH_END, hidePrompt);
			strikeArea.removeEventListener(TouchEvent.TOUCH_BEGIN, strikeMatch);
			hideStrikeArea();
		}
		
		public function on():void  { 
			active = true; 
			game.$.addChild(icon);
			game.views.transitions.hotFingers.play();
			timesActivated++;
			if(game._soundEnabled) game.soundEffects.strikeMatch();
		}
		public function off():void {
			trace('lost hotfingers');
			if(prompting) hidePrompt();
			active = false;	
			flameActive = false;
			game.views.transitions.hotFingers.playReverse();
			game.$.removeChild(icon);
			reset();
			game.disableHotFingers();
			game.enableTouchKilling();
		}
		public function reset():void {
			counter = 0;
			killed = 0;
		}
		
		private function showStrikeArea():void { 
			game.$.addChild(strikeArea); 
		}
		private function hideStrikeArea():void {
			if(timesActivated >= 2) { strikeArea.prompt.swipe_prompt.visible = 0; strikeArea.prompt.prompt_bg.visible = 0; }
			game.$.removeChild(strikeArea);  
		}
	}
}