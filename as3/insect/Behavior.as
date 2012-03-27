package insect
{
	import flash.events.Event;
	import ants.Ant;

	public class Behavior
	{
		protected var ant:Ant;
		protected var x:Number = 0;
		protected var y:Number = 0;
		
		public function Behavior(ant:Ant)
		{
			this.ant = ant;
		}
		
		public function setPoint(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}

		public function act(event:Event):void
		{
			// template method, override for specific behavior
			ant.stop(); // stop the enterframe madness if this method is not overriden.
		}
		
	}
}