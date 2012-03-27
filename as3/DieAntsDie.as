package
{
	import ants.Ant;
	import ants.AntGod;
	
	import device.Android;
	import device.Blackberry;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Timer;
	
	import powers.HotFingers;
	import powers.Teleport;
	
	import sounds.Effects;
	
	import states.Manager;
	import states.Views;
	
	import storage.SQL_Database;
	
	public class DieAntsDie extends MovieClip
	{
		public var STAGEX_CENTER:Number;
		public var STAGEY_CENTER:Number;
		
		public var score:uint;
		public var curLevel:uint;
		public var levels:uint = 70;
		public var totalKills:uint;
		public var queenKills:uint;
		public var killSpeed:uint;
		public var _difficulty:String;
		public var _soundEnabled:Boolean;
		public var _gutsEnabled:Boolean;
		public var returningPlayer:Boolean;
		public var just_started:Boolean = true;
		
		public var db:SQL_Database;
		public var state:String = "start";
		public var $:Stage;
		public var views:Views;
		public var antGod:AntGod;
		public var hotFingers:HotFingers;
		public var teleport:Teleport;
		public var soundEffects:Effects = new Effects();
		
		public var timer:Timer = new Timer(1000); //level timer
		public var failed:Boolean;
		public var won:Boolean;
		public var kills:uint;
		public var hits:uint;
		public var level_hits:uint;
		public var level_misses:uint;
		public var misses:uint;
		public var hit_ratio:uint;
		public var ant:Sprite = new big_ant_flat_;
		public var antsDead:Array = new Array;
		public var deadAnt:Ant;
		public var newAntKill:Boolean;
		public var antPool:Array;
		
//  DEVICES:comment in the desired device  //
		private var blackberry:Blackberry;
//		private var android:Android = new Android(this);
		
		public var antsToWin:uint = 4;
		public var time:uint = antsToWin * 1.5;
		public var timeToBeat:uint = antsToWin * 1.3;
		
		public function DieAntsDie($stage:Stage, $db:SQL_Database) {
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			$ = $stage;
			STAGEX_CENTER = $.fullScreenWidth/2;
			STAGEY_CENTER = $.fullScreenHeight/2;
			
			db = $db;
			blackberry = new Blackberry(this);
			antGod = new AntGod(this);
			views = new Views(this);
			views.transitions = new Manager(this);
			hotFingers = new HotFingers(this);
			teleport = new Teleport();
			views.transitions.registerHotFingersAnimation();
			state = "home";
			views.home.showYourself();
		}
			
		public function startGame(e:MouseEvent):void {
			views.hideStartScreen();
			newGame();
		}
		
		public function NewGame(e:MouseEvent):void {
			if(views.menu_show && state != "pause") {
				views.home.$.continue_btn.removeEventListener(MouseEvent.CLICK, startGame);
				views.home.$.newgame_btn.removeEventListener(MouseEvent.CLICK, NewGame);
				views.menu_show = false;
				curLevel = 0;
				views.home.cleanUpCrap();
				views.transitions.levelChangeOutDelay.gotoAndStop(1); 
				views.transitions.failLevel.gotoAndStop(1);
				views.transitions.newGameToLevel.play();
				if(state != "home") clearOldLevel();
			}
			else if(failed) {
				$.removeEventListener(MouseEvent.MOUSE_DOWN, NewGame);
				$.removeEventListener(MouseEvent.MOUSE_DOWN, NewGame);
				views.transitions.levelChangeOutDelay.gotoAndStop(1); 
				views.transitions.failLevel.gotoAndStop(1);
				clearOldLevel();
			}
			else if(won) {
				$.removeEventListener(MouseEvent.MOUSE_DOWN, NewGame); 
				
				clearOldLevel();
				won = false;
			}
			
			newGame();
		}
		public function newGame():void {
			if(curLevel == 0) setupBaseVariables();
			views.level.alpha = 0;
			views.showLevel();
		}
		public function setupBaseVariables():void {
			curLevel = 0;
			score = 0;
			addPoints(0);
			kills = 0;
			totalKills = 0;
			views.killboard.txt.text = "Kills: 0";
			
			views.warstats.hits.text = "hits @50";
			views.warstats.hits_.text = "+00";
			views.warstats.misses.text = "misses @75";
			views.warstats.misses_.text = "-00";
			views.warstats.hit_percent.text = "hit%";
			views.warstats.hit_percent_.text = "+00";
		}
		public function rnum(low:Number=0, high:Number=1):Number {
			return Math.floor(Math.random() * (1+high-low)) + low;
		}
		
		//+++++++++++++++    LEVEL STUFF   +++++++++++++++++++
		
		public function addPoints(points:uint):void {
			score += points;
			//views.scoreboard.score.txt.text = ""+score;
		}
		public function losePoints(points:uint):void {
			score -= points;
			//views.scoreboard.score.txt.text = ""+score;
		}
		
		public function hideStats(e:MouseEvent):void {
			views.transitions.levelChangeOutDelay.play();
			$.removeEventListener(MouseEvent.MOUSE_DOWN, hideStats);
		}
		public function showNextLevel():void {				
			views.level.alpha = 1;
			views.fail_bg.alpha = 1;
			views.warstats.alpha = 0;
			views.sub_text.alpha = 0;
			views.levelTimer.alpha = 0;
			if(hotFingers.prompting) hotFingers.hidePrompt();
			views.level.play();
		}
		public function startNextLevel():void {
			if(curLevel >= levels) { youWon(); }
			if(curLevel == 0) { curLevel = 1; }
			
			timeToBeat = antsToWin * 0.90;
			time = antsToWin * 1.5;
			
			if(antsToWin == 1) { time = 10; }
			else if(antsToWin == 2) { time = 11; }
			
			views.levelTimer.time.timeLeft.text = time.toString();
			timer.start();
			views.bgs.alpha = 1;
			
			//views.scoreboard.alpha = 1;
			views.level.alpha = 0;
			views.transitions.levelChangeOutDelay.gotoAndStop(1); 
			views.transitions.failLevel.gotoAndStop(1);
			
			if(views.sub_text.alpha != 0) { views.sub_text.alpha = 0; }
			
			antGod.makeAnts();
			trace('made the ants');
		}
		public function clearOldLevel():void {
			while(views.splats.numChildren > 0) {
				views.splats.removeChildAt(0);
			}
			antGod.putAntsOffStage();
			antGod.stopAllAnts();
			kills = 0;
			level_hits = 0;
			level_misses = 0;
		}
		public function fail():void {
			$.removeEventListener(MouseEvent.MOUSE_DOWN, antDie);
			$.addEventListener(MouseEvent.MOUSE_DOWN, NewGame);
			views.sub_text.level.visible = false;
			views.sub_text.level_message.text = "tap to get revenge!";
			views.transitions.failLevel.play();
			views.level_fail.play();
			failed = true;
			timer.stop();
		}
		public function passLevel():void {
			views.warstats.hits.text = ""+level_hits.toString()+" hits @50";
			views.warstats.hits_.text = "+"+(level_hits*50).toString();
			addPoints(level_hits*50);
			views.warstats.misses.text = ""+level_misses.toString()+" misses @75";
			views.warstats.misses_.text = "-"+(level_misses*75).toString();
			losePoints(level_misses*75);
			hit_ratio = Math.round((level_hits/(level_hits+level_misses)) * 100);
			
			if(hit_ratio > 85) {
				views.warstats.hit_percent.text = "hit%: "+hit_ratio.toString()+" = All hail the Smash Master!";
				views.warstats.hit_percent_.text = "+1000";
				addPoints(1000);
			}
			else if(hit_ratio >70) {
				views.warstats.hit_percent.text = "hit%: "+hit_ratio.toString()+" = You're a Real Killer.";
				views.warstats.hit_percent_.text = "+700";
				addPoints(700);
			}
			else if(hit_ratio >60) {
				views.warstats.hit_percent.text = "hit%: "+hit_ratio.toString()+" = You're kickin butt.";
				views.warstats.hit_percent_.text = "+600";
				addPoints(500);
			}
			else if(hit_ratio >50) {
				views.warstats.hit_percent.text = "hit%: "+hit_ratio.toString()+" = Not bad.";
				views.warstats.hit_percent_.text = "+500";
				addPoints(500);
			}
			else if(hit_ratio >40) {
				views.warstats.hit_percent.text = "hit%: "+hit_ratio.toString()+" = Meh.";
				views.warstats.hit_percent_.text = "+400";
				addPoints(500);
			}
			else if(hit_ratio >30) {
				views.warstats.hit_percent.text = "hit%: "+hit_ratio.toString()+" = Dude.. really?";
				views.warstats.hit_percent_.text = "+300";
				addPoints(500);
			}
			else if(hit_ratio >20) {
				views.warstats.hit_percent.text = "hit%: "+hit_ratio.toString()+" = You could be worse..";
				views.warstats.hit_percent_.text = "+200";
				addPoints(200);
			}
			else {
				views.warstats.hit_percent.text = "hit%: "+hit_ratio.toString()+" = Ummm...";
				views.warstats.hit_percent_.text = "+0";
			}
			if(time < timeToBeat-(antsToWin*2)) {
				views.warstats.s1.text = "Time Completion Speed Bonus";
				views.warstats.s1_.text = "+500";
				addPoints(500);
			}
			
			//determine kill speed per minute
			var temp_killSpeed:uint = (60/time)*kills;
			views.warstats.s2.text = "Ant Kills/Minute";
			views.warstats.s2_.text = temp_killSpeed.toString();
			//determine average
			killSpeed = (temp_killSpeed + killSpeed) / 2;
						
			
			views.transitions.levelChangeIn.gotoAndStop(1);
			views.transitions.levelChangeOutDelay.gotoAndStop(1);
			views.transitions.failLevel.gotoAndStop(0);
			timer.stop();
			views.levelTimer.time.timeLeft.text = "";
			clearOldLevel();
			
			if (curLevel == levels) {
				youWon(); 
			}
			else views.showLevel();
			
			db.storeProgress();
		}
		public function checkCompletion():void {
			if(kills == antsToWin) {
				passLevel();
				if(hotFingers.active) hotFingers.off();
				timer.stop();
			}
			else if(curLevel > 1 && kills <= antsToWin) {
				deadAnt.summonFromTheGrave();
			}
			
			/*if(kills >= 50 && kills <= 70)	teleport.active = true;
			else 							teleport.active = false;*/
		}
		public function onTimer(e:TimerEvent):void {
			if(time == 0) fail();
			else {
				time--;
				hotFingers.tick();
				if(time <= 10) {
					views.levelTimer.visible = true;
					views.levelTimer.time.timeLeft.text = time.toString();
				}
				else if(views.levelTimer.visible) views.levelTimer.visible = false;		
			}
		}
		
		public function youWon():void {
			$.removeEventListener(MouseEvent.MOUSE_DOWN, antDie);
			$.addEventListener(MouseEvent.MOUSE_DOWN, NewGame);
			views.level_fail.txt.text = "you win";
			views.sub_text.level_message.text = "killer job. play again?";
			views.transitions.failLevel.play();
			won = true;
			timer.stop();
		}
		
		public function antDie(e:TouchEvent):void {
			newAntKill = false;
			
			if (e.target is Ant) { 
				deadAnt = e.target as Ant;
				newAntKill = true;
			}
			else if	(e.target.parent is Ant) { 
				deadAnt = e.target.parent as Ant;
				newAntKill = true; 
			} 
			else if	(!hotFingers.active) 		{ 
				level_misses++; 								
				newAntKill = false;  
			}
			
			if(newAntKill) {
				antGod.kill_ant(deadAnt, e.stageX, e.stageY);
				addKill();
				if(_soundEnabled) soundEffects.killSound();
				level_hits++;
				addPoints(500);
				checkCompletion();
			}
			
		}
		
		public function addKill():void {
			kills++;	
			hotFingers.kill();
			totalKills++;
			views.killboard.txt.text = "Kills: "+totalKills;
		}
		
		public function enableTouchKilling():void { 
			$.addEventListener(TouchEvent.TOUCH_BEGIN, antDie); 
		}
		public function disableTouchKilling():void { 
			$.removeEventListener(TouchEvent.TOUCH_BEGIN, antDie); 
		}
		public function enableHotFingers():void { 
			$.addEventListener(TouchEvent.TOUCH_OVER, antDie); 
		}
		public function disableHotFingers():void { 
			$.removeEventListener(TouchEvent.TOUCH_OVER, antDie); 
		}

		public function set difficulty(value:String):void {
			_difficulty = value;
			db.storeGameData();
			if(antPool != null) antGod.adjustAntSize();
		}

		public function set soundEnabled(value:Boolean):void {
			_soundEnabled = value;
			db.storeGameData();
		}

		public function set gutsEnabled(value:Boolean):void {
			_gutsEnabled = value;
			db.storeGameData();
		}
		
		public function gestureMode():void { 
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
		}
		public function touchMode():void { 
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT; 
		}
	}
	
}