package insect
{
	import flash.events.Event;
	
	import math.Convert;
	import ants.Ant;
	
	public class RunAway extends Behavior
	{
		protected var safeDistance:Number = 150;
		
		
		public function RunAway(ant:Ant)
		{
			super(ant);
		}
		
		
		override public function setPoint(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		override public function act(event:Event):void
		{
			var dx:Number = x - ant.x;
			var dy:Number = y - ant.y;
			var distance:Number = Math.sqrt(dx * dx + dy * dy);
			
			if(distance >= safeDistance) {
				ant.wander();
			}
			
			// get direction towards point, add Math.PI to point in opposite direction
			var radians:Number = Math.atan2(dy, dx) + Math.PI;
			ant.x += Math.cos(radians) * ant.speed; // move by vx
			ant.y += Math.sin(radians) * ant.speed; // move by vy
			ant.rotation = Convert.toDegrees(radians)+90;// / (Math.PI / 180); // convert to degrees
		}
		
	}
}