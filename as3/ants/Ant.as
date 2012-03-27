package ants
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	
	import insect.Behavior;
	import insect.Die;
	import insect.RunAway;
	import insect.WalkTo;
	import insect.Wander;
	
	public class Ant extends MovieClip
	{
		public var speed:Number = 8 + Math.random() * 12;
		
		protected var currentBehavior:Behavior;
		protected var _wander:WalkTo;
		protected var _walkTo:WalkTo;
		protected var _runAway:RunAway;
		//protected var _die:Die;
		protected var _bug:big_ant_flat_;
		protected var _chillen:Boolean;
		protected var _dead:Boolean;
		
		public function Ant($sWidth:uint, $sHeight:uint)
		{
			_wander = new Wander(this,$sWidth,$sHeight);
			_walkTo = new WalkTo(this);
			_runAway = new RunAway(this);
			//_die = new Die(this);
			_bug = new big_ant_flat_;
			_bug.cacheAsBitmap = true;
			mouseChildren = false;
			addChild(_bug);
		}
		
		public function ChillOut():void {
			stop();
			_chillen = true;
		}
		
		public function wander():void
		{
			stop();
			_chillen = false;
			_dead = false;
			currentBehavior = _wander;
			addEventListener(Event.ENTER_FRAME, currentBehavior.act);
		}
		
		public function walkToPoint(x:Number, y:Number):void
		{
			stop();
			_walkTo.setPoint(x, y);
			currentBehavior = _walkTo;
			addEventListener(Event.ENTER_FRAME, currentBehavior.act);
		}
		
		public function runFromPoint(x:Number, y:Number):void
		{
			stop();
			_runAway.setPoint(x, y);
			currentBehavior = _runAway;
			addEventListener(Event.EXIT_FRAME, currentBehavior.act);
		}
		
		public function removeBody():void {
			removeChild(_bug);
		}
		
		public function die():void
		{
			stop();
			_dead = true;
		}
		public function get bug():big_ant_flat_ {
			return _bug;
		}
		public function get dead():Boolean {
			return _dead;
		}
		public function get chillen():Boolean {
			return _chillen;
		}
		public function summonFromTheGrave():void {
			_dead = false;
			speed = 7 + Math.random() * 13;
			wander();
		}
		
		
		override public function stop():void
		{
			currentBehavior && removeEventListener(Event.ENTER_FRAME, currentBehavior.act);
			if(hasEventListener(Event.EXIT_FRAME)) removeEventListener(Event.EXIT_FRAME, currentBehavior.act);
		}
	}
}