package insect
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import ants.Ant;
	
	public class Wander extends WalkTo
	{
		protected var framesToWalk:Number = 90 * Math.random() + 30;
		protected var frames:Number = 0;
		protected var wanderDistance:Number = 45;
		protected var _ant:Ant;
		protected var _width:uint;
		protected var _height:uint;
		
		public function Wander(ant:Ant,$sWidth:uint,$sHeight:uint)
		{
			super(ant);
			_width = $sWidth - 10;
			_height = $sHeight - 10;
			setRandomishPoint();
		}
		
		protected function setRandomishPoint():void
		{
			setPoint(Math.random() * _width, Math.random() * _height);
		}
		
		override public function act(event:Event):void
		{
			_ant = event.target as Ant;
			if(!_ant.dead) {
				frames++;
	
				if(frames >= framesToWalk)
				{
					frames = 0;
					
					framesToWalk = 60 * Math.random() + 10;
					setRandomishPoint();
				}
				
				super.act(event);
			}
			else _ant.die();
		}
	}
}