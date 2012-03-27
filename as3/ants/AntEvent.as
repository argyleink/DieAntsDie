package ants
{
	import flash.events.Event;

	public class AntEvent extends Event
	{
		/* Used to remove the ant from the AntObserver */
		public static const SMOOSHED:String = "smooshed";
		
		
		public function AntEvent(type:String)
		{
			super(type, true);
		}
		
	}
}