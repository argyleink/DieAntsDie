package states
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	
	public class Views
	{
		private var game:DieAntsDie;
		public var transitions:Manager;
		
		public var menu_show:Boolean;
		
		public var home:Home;
		public var white_bg:whitebg = new whitebg();
		public var bgs:app_backgrounds = new app_backgrounds();
		public var fail_bg:fail_background = new fail_background();
		public var killboard:killCount = new killCount();
		public var level:levelText = new levelText();
		public var scoreboard:scoreBoard = new scoreBoard();		
		public var highscore:Boolean;
		public var sub_text:level_sub_text = new level_sub_text();
		public var level_fail:levelfailed = new levelfailed();
		public var warstats:hits_text = new hits_text();
		public var levelTimer:levelCounter = new levelCounter();
		public var splats:splatBox = new splatBox();
		
		public function Views($game:DieAntsDie) {
			game = $game;			
			
			white_bg.width = game.$.fullScreenWidth;
			white_bg.height = game.$.fullScreenHeight;
			game.$.addChild(white_bg);	
				
			bgs.mouseEnabled = false;
			bgs.mouseChildren = false;
			bgs.x = game.STAGEX_CENTER;
			bgs.y = game.STAGEY_CENTER;
			if(game.$.fullScreenWidth > 1200) {
				bgs.scaleX = bgs.scaleY = 1280 / bgs.width;
			}
			game.$.addChild(bgs);
			
			fail_bg.mouseEnabled = false;
			fail_bg.mouseChildren = false;
			fail_bg.x = game.STAGEX_CENTER;
			fail_bg.y = game.STAGEY_CENTER;
			fail_bg.width = game.$.fullScreenWidth;
			fail_bg.height = game.$.fullScreenHeight;
			game.$.addChild(fail_bg);
			
			/* Intro */	
			home = new Home(game);
			home.$.menu_back_btn.visible = false;
			
			level.x = game.STAGEX_CENTER;
			level.y = game.STAGEY_CENTER;
			game.$.addChild(level);			
			
			level_fail.x = game.STAGEX_CENTER;
			level_fail.y = game.STAGEY_CENTER-20;
			game.$.addChild(level_fail);			
			
			sub_text.x = game.STAGEX_CENTER;
			sub_text.y = game.STAGEY_CENTER-10;
			game.$.addChild(sub_text);			
			
			killboard.x = 20;
			killboard.y = 10;
			game.$.addChild(killboard);			
			
			scoreboard.x = game.$.fullScreenWidth + 20; //-20 to bring back in
			scoreboard.y = 10;
			game.$.addChild(scoreboard);			
			
			warstats.x = game.$.fullScreenWidth - 20;
			warstats.y = 20;
			game.$.addChild(warstats);			
			
			levelTimer.x = 20;
			levelTimer.y = 10;
			levelTimer.visible = false;
			game.$.addChild(levelTimer);
			
			splats.mouseEnabled = false;
			splats.mouseChildren = false;
			game.$.addChild(splats);
			
			game.$.addChild(home);
			menu_show = true;
			
			bgs.alpha = 0;
			fail_bg.alpha = 0;
			level_fail.alpha = 0;
			killboard.alpha = 0; 
			level.alpha = 0;
			sub_text.alpha = 0;
			scoreboard.alpha = 0;
			warstats.alpha = 0;
		}
		
		public function showMenu():void {
			if(menu_show) {
				game.state = "playing";
				menu_show = false;
				home.$.newgame_btn.visible = true;
				home.$.continue_btn.visible = true;
				home.enableGamePlayButtons();
				home.toggleBackButton(false);
				home.cleanUpCrap();
				game.timer.start();
				
				game.enableTouchKilling();
			} else {
				game.disableTouchKilling();
				
				home.$.newgame_btn.visible = false;
				home.$.continue_btn.visible = false;
				game.state = "paused";
				menu_show = true;
				game.$.addChild(home);
				home.showYourself();
				home.toggleBackButton(true);
				home.disableGamePlayButtons();
				game.timer.stop();
			}
		}
		
		public function showLevel():void {
			if(game.failed) {
				game.failed = false;
				level_fail.gotoAndStop(1);
				transitions.levelChangeOutDelay.play();
				bgs.gotoAndStop(game.curLevel);
			}
			else {
				if(game.returningPlayer && game.curLevel != 0) game.returningPlayer = false;
				if(bgs.alpha == 0) bgs.alpha = 1;
				
				if(!game.just_started) {
					game.curLevel++;
				} else {
					if(game.curLevel == 0) game.curLevel = 1;
					game.just_started = false;
				}
				game.antsToWin = (game.curLevel * 3) + 4;
				levelTimer.time.timeLeft.text = "";
				if(!sub_text.level.visible) sub_text.level.visible = true;
				sub_text.level.text = "LEVEL "+game.curLevel;
				sub_text.level_message.text = "squish "+game.antsToWin+" ants to win";					
				if(game.curLevel == 1) 				sub_text.level_message.text = "use your fingers to squish the ants, \nbefore time runs out \ntap the screen to start";
				if(game.curLevel == 2) 				sub_text.level_message.text = "squish em when they stop \ntap the screen to start";
				if(game.curLevel == 3) 				sub_text.level_message.text = "get Firey Finger Tips for squishing \n"+game.hotFingers.antsToKill+" ants in "+game.hotFingers.timeToKill+" seconds";
				if(game.curLevel == 7) 				sub_text.level_message.text = "Firey Finger Tips allows 4 fingers \ncan handle 4 fingers at once";
				if(game.curLevel == game.levels) 	sub_text.level_message.text = "final LEVEL";
				bgs.gotoAndStop(game.curLevel);
				transitions.levelChangeIn.play();
				menu_show = false;
				game.state = "tap to start";
			}
		}
		
		public function hideStartScreen():void {
			bgs.alpha = 1;			
			home.cleanUpCrap();
		}
	}
}