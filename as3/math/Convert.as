package math
{
	public class Convert
	{
		public static const RAD1:Number = Math.PI / 180;
		
		/* radians = degrees * Math.PI/180 */
		public static function toRadians(degrees:Number):Number
		{
			return degrees * RAD1;
		}
		

		public static const RAD2:Number = 180 / Math.PI;
		
		/* degrees = radians * 180/Math.PI */
		public static function toDegrees(radians:Number):Number
		{
			return radians * RAD2;
		}
	}
}