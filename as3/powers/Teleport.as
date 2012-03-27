package powers
{
	public class Teleport
	{
		private var _active:Boolean;
		
		public function Teleport() { }

		public function get active():Boolean 			{ return _active; }
		public function set active(value:Boolean):void 	{ _active = value; }
	}
}