package states
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	public class Home extends MovieClip
	{
		private var game:DieAntsDie;
		public var $:HomeScreen;
		
		public function Home($game:DieAntsDie)
		{
			game = $game;
			
			$ = new HomeScreen();
			//showYourself();
		}
		
		public function updateDynamicFields():void {
			$.total_ants_killed.text = game.totalKills.toString();
			$.queens_killed.text = game.curLevel.toString();
			$.kills_per_minute.text = game.killSpeed.toString();
			
			if(game.curLevel >= game.levels) game.curLevel = game.levels-1;
			
			if(game.curLevel > 0) {
				$.progress_bar.gauge.alpha = 1;
				$.progress_bar.gauge.width = (game.curLevel / game.levels) * 585;
				if($.progress_bar.gauge.width > 577) $.progress_bar.gauge.width = 577;
				$.continue_btn.mouseEnabled = true;
				$.continue_btn.alpha = 1;
			}
			else {
				$.progress_bar.tip.alpha = 0;
				$.continue_btn.mouseEnabled = false;
				$.continue_btn.alpha = .4;
			}
			
			if(game.curLevel == game.levels) $.progress_bar.tip.alpha = 1;
			
			if(game._difficulty != "") {
				difficultiesOff();
				
				switch (game._difficulty) {
					case "easy":
						$.easy_toggle.gotoAndStop('on'); 
						break;
					case "medium":
						$.medium_toggle.gotoAndStop('on'); 
						break;
					case "hard":
						$.hard_toggle.gotoAndStop('on'); 
						break;
				}
			}
			
			if(game._soundEnabled) $.sound_toggle.gotoAndStop('on'); else $.sound_toggle.gotoAndStop('off');
			if(game._gutsEnabled)  $.guts_toggle.gotoAndStop('on');  else $.guts_toggle.gotoAndStop('off');
		}
		
		private function continueGame(e:MouseEvent):void { game.startGame(e); }
		private function newGame(e:MouseEvent):void 	 { game.NewGame(e); }
		
		private function add$EventListeners():void {
			$.easy_toggle.addEventListener(MouseEvent.CLICK, toggleEasy);
			$.medium_toggle.addEventListener(MouseEvent.CLICK, toggleMedium);
			$.hard_toggle.addEventListener(MouseEvent.CLICK, toggleHard);
			$.sound_toggle.addEventListener(MouseEvent.CLICK, toggleSound);
			$.guts_toggle.addEventListener(MouseEvent.CLICK, toggleGuts);
			$.continue_btn.addEventListener(MouseEvent.CLICK, continueGame);
			$.newgame_btn.addEventListener(MouseEvent.CLICK, newGame);
		}		
		private function remove$EventListeners():void {
			$.easy_toggle.removeEventListener(MouseEvent.CLICK, toggleEasy);
			$.medium_toggle.removeEventListener(MouseEvent.CLICK, toggleMedium);
			$.hard_toggle.removeEventListener(MouseEvent.CLICK, toggleHard);
			$.sound_toggle.removeEventListener(MouseEvent.CLICK, toggleSound);
			$.guts_toggle.removeEventListener(MouseEvent.CLICK, toggleGuts);
			$.continue_btn.removeEventListener(MouseEvent.CLICK, continueGame);
			$.newgame_btn.removeEventListener(MouseEvent.CLICK, newGame);
		}
		public function disableGamePlayButtons():void {
			$.continue_btn.removeEventListener(MouseEvent.CLICK, continueGame);
			$.newgame_btn.removeEventListener(MouseEvent.CLICK, newGame);
		}
		public function enableGamePlayButtons():void {
			$.continue_btn.addEventListener(MouseEvent.CLICK, continueGame);
			$.newgame_btn.addEventListener(MouseEvent.CLICK, newGame);
		}
		
		private function toggleEasy(e:MouseEvent):void { 
			difficultiesOff();			
			$.easy_toggle.gotoAndPlay('on'); 
			game.difficulty = "easy";
		}
		private function toggleMedium(e:MouseEvent):void { 
			difficultiesOff();			
			$.medium_toggle.gotoAndPlay('on');
			game.difficulty = "medium";
		}
		private function toggleHard(e:MouseEvent):void { 
			difficultiesOff();			
			$.hard_toggle.gotoAndPlay('on');
			game.difficulty = "hard";
		}
		private function difficultiesOff():void {
			if($.easy_toggle.currentFrameLabel == 'on') 	$.easy_toggle.gotoAndPlay('off');
			if($.medium_toggle.currentFrameLabel == 'on') 	$.medium_toggle.gotoAndPlay('off');
			if($.hard_toggle.currentFrameLabel == 'on') 	$.hard_toggle.gotoAndPlay('off');
		}
		
		private function toggleSound(e:MouseEvent):void { 
			if($.sound_toggle.currentFrameLabel == 'on') {
				$.sound_toggle.gotoAndPlay('off');
				game.soundEnabled = false;
			}
			else {
				$.sound_toggle.gotoAndPlay('on');
				game.soundEnabled = true;
			}
		}
		private function toggleGuts(e:MouseEvent):void { 
			if($.guts_toggle.currentFrameLabel == 'on') {
				$.guts_toggle.gotoAndPlay('off');
				game.gutsEnabled = false;
				while(game.views.splats.numChildren > 0) {
					game.views.splats.removeChildAt(0);
				}
			}
			else {
				$.guts_toggle.gotoAndPlay('on');
				game.gutsEnabled = true;
			}
		}
		
		public function cleanUpCrap():void {			
			remove$EventListeners();
			removeChild($);
		}
		public function showYourself():void {
			addChild($);
			updateDynamicFields();
			add$EventListeners();
		}
		public function toggleBackButton(t:Boolean):void {
			if (t) {
				$.menu_back_btn.addEventListener(MouseEvent.MOUSE_DOWN, backButton);
				$.menu_back_btn.visible = true;
			} else {
				$.menu_back_btn.removeEventListener(MouseEvent.MOUSE_DOWN, backButton);
				$.menu_back_btn.visible = false;
			}
		}
		private function backButton(e:MouseEvent):void { game.views.showMenu(); }
	}
}