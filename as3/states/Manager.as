package states
{
	import com.boostworthy.animation.easing.Transitions;
	import com.boostworthy.animation.rendering.RenderMethod;
	import com.boostworthy.animation.sequence.Timeline;
	import com.boostworthy.animation.sequence.tweens.Tween;
	import com.boostworthy.core.Global;
	import com.boostworthy.events.AnimationEvent;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	
	public class Manager
	{
		private var game:DieAntsDie;
		
		public var levelChangeIn:Timeline = new Timeline();
		public var levelChangeOutDelay:Timeline = new Timeline();
		public var levelChangeBGOut:Timeline = new Timeline();
		public var failLevel:Timeline = new Timeline();
		public var newGameToLevel:Timeline = new Timeline();
		public var hotFingers:Timeline = new Timeline();
		
		public function Manager($game:DieAntsDie) {
			game = $game;
			
			setupLevelChangeIn();
			setupLevelChangeDelay();
			setupFailLevel();
			setupNewGameAnimation();
			setupLevelTimer();
			
			game.views.level_fail.alpha = 0;
			game.views.sub_text.alpha = 0;
			game.views.fail_bg.alpha = 0;
			
			levelChangeBGOut.addTween(new Tween(game.views.fail_bg, "alpha", 0, 0, 15, Transitions.DEFAULT_TRANSITION));
		}
		
		public function setupLevelChangeIn():void {
			//game.views.killboard.alpha = 1;
			//game.views.warstats.alpha = 1;
			game.views.scoreboard.alpha = 0;
			game.views.levelTimer.alpha = 0;
			game.views.sub_text.alpha = 1;
			
			levelChangeIn.addEventListener(AnimationEvent.FINISH, levelInFinish);
			
			levelChangeIn.addTween(new Tween(game.views.sub_text, "alpha", 1, 0, 10, Transitions.DEFAULT_TRANSITION));
			levelChangeIn.addTween(new Tween(game.views.fail_bg, "alpha", 1, 0, 5, Transitions.DEFAULT_TRANSITION));
			levelChangeIn.addTween(new Tween(game.views.levelTimer, "alpha", 0, 0, 5, Transitions.DEFAULT_TRANSITION));
		}
		
		public function setupLevelChangeDelay():void {
			levelChangeOutDelay.addEventListener(AnimationEvent.FINISH, startNextLevel);
			levelChangeOutDelay.addEventListener(AnimationEvent.START, showNextLevel);
			
			levelChangeOutDelay.addTween(new Tween(game.views.levelTimer, "alpha", 1, 0, 60, Transitions.DEFAULT_TRANSITION));
		}
		
		public function setupFailLevel():void {
			failLevel.addTween(new Tween(game.views.level_fail, "alpha", 1, 0, 15, Transitions.DEFAULT_TRANSITION));
			failLevel.addTween(new Tween(game.views.sub_text, "alpha", 1, 0, 15, Transitions.DEFAULT_TRANSITION));
			failLevel.addTween(new Tween(game.views.fail_bg, "alpha", 1, 0, 15, Transitions.DEFAULT_TRANSITION));
		}
		
		public function setupNewGameAnimation():void {
			newGameToLevel.addTween(new Tween(game.views.sub_text, 'alpha', 1, 0, 10, Transitions.DEFAULT_TRANSITION));
			newGameToLevel.addTween(new Tween(game.views.level, 'alpha', 1, 0, 10, Transitions.DEFAULT_TRANSITION));
		}
		
		public function showBG(e:AnimationEvent):void {
			//if(!game.views.menu_show) game.views.fail_bg.alpha = 0;
			//game.views.new_game.addEventListener(MouseEvent.CLICK, game.NewGame);
		}
		
		public function setupLevelTimer():void {
			game.timer.addEventListener(TimerEvent.TIMER, game.onTimer);
			game.views.levelTimer.time.timeLeft.text = "";
		}
		
		public function levelInFinish(e:AnimationEvent):void {
			game.$.addEventListener(MouseEvent.MOUSE_DOWN, game.hideStats);
		}
		
		public function showNextLevel(e:AnimationEvent):void {
			game.showNextLevel();
		}
		public function startNextLevel(e:AnimationEvent):void {
			game.startNextLevel();
			game.views.levelTimer.alpha = 1;
			//game.views.fail_bg.alpha = 0;
			levelChangeBGOut.play();
		}
		public function registerHotFingersAnimation():void {
			hotFingers.addTween(new Tween(game.hotFingers.icon, "x", game.$.stageWidth-10-game.hotFingers.icon.width, 0, 15, Transitions.ELASTIC_IN));
		}
	}
}