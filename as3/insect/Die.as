package insect
{
	import flash.events.Event;
	import ants.Ant;
	
	public class Die extends Behavior
	{
		protected var frameCount:int;
		protected var frame:int = 0;
		
		public function Die(ant:Ant)
		{
			super(ant);
			
//			frameCount = ant.atomsAntMovieClip.animationTimelineInstanceName.totalFrames;
		}
		
		/**
		 * Default implmentation for testing.
		 */
		override public function act(event:Event):void
		{
			ant.stop();
			ant.parent && ant.parent.removeChild(ant);
		}
		
		
		/**
		 * Example of how to run a timeline animation from code (frame by frame).
		 */
//		override public function act(event:Event):void
//		{
//			frame++;
//			
//			// this is where you would invoke the writhe function on your asset
//			ant.atomsAntMovieClip.animationTimelineInstanceName.gotoAndStop(frame);
//			
//			if(frame == frameCount)
//			{
//				ant.stop();
//				ant.parent && ant.parent.removeChild(ant);
//			}
//		}
		
		
		/**
		 * Example of how to start a timeline animation and listen for its completion.
		 */
//		override public function act(event:Event):void
//		{
//			ant.stop();
//			
//			// this is where you would invoke the writhe function on your asset
//			ant.atomsAntMovieClip.animationTimelineInstanceName.addFrameScript(frameCount, notifyToRemoveAnt)
//			ant.atomsAntMovieClip.animationTimelineInstanceName.gotoAndPlay(1);
//		}
//		
//		protected function notifyToRemoveAnt():void
//		{
//			ant.parent && ant.parent.removeChild(ant);
//		}
	}
}