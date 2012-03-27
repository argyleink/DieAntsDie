package insect
{
	import flash.events.Event;
	
	import math.Convert;
	import ants.Ant;
	
	public class WalkTo extends Behavior
	{
		public function WalkTo(ant:Ant)
		{
			super(ant);
		}
		
		
		override public function act(event:Event):void
		{
			var dx:Number = x - ant.x;
			var dy:Number = y - ant.y;
			var distance:Number = Math.sqrt(dx * dx + dy * dy);
			
			if(distance < 10)
				return ant.wander();
			
			// get direction towards point
			var radians:Number = Math.atan2(dy, dx);
			ant.x += Math.cos(radians) * ant.speed; // move by vx
			ant.y += Math.sin(radians) * ant.speed; // move by vy
			ant.rotation = Convert.toDegrees(radians) + 90;// / (Math.PI / 180); // convert to degrees
		}
	}
}