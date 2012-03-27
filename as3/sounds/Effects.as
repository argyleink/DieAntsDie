package sounds
{
	import flash.media.SoundChannel;
	
	public class Effects
	{
		private var sound_channel:SoundChannel;		
		private var farts:Array;
		
		private var killsound1:KillSound1 = new KillSound1;
		private var killsound2:KillSound2 = new KillSound2;
		private var killsound3:KillSound3 = new KillSound3;
		private var killsound4:KillSound4 = new KillSound4;
		private var killsound5:KillSound5 = new KillSound5;
		private var killsound6:KillSound6 = new KillSound6;
		private var killsound7:KillSound7 = new KillSound7;
		private var killsound8:KillSound8 = new KillSound8;
		private var killsound9:KillSound9 = new KillSound9;
		private var killsound10:KillSound10 = new KillSound10;
		private var killsound11:KillSound11 = new KillSound11;
		private var killsound12:KillSound12 = new KillSound12;
		private var match:matchStrike = new matchStrike;
		private var sizzzle:sizzle = new sizzle;
		
		public function Effects()
		{			
			farts = new Array(
				killsound1,
				killsound2,
				killsound3,
				killsound4,
				killsound5,
				killsound6,
				killsound7,
				killsound8,
				killsound9,
				killsound10,
				killsound11,
				killsound12
			);
		}
		
		public function killSound():void {
			sound_channel = farts[rnum()].play();
		}
		
		public function strikeMatch():void {
			sound_channel = match.play();
		}
		public function sizzleMatch():void {
			sound_channel = sizzzle.play();
		}
		
		public function rnum():Number {
			var high:Number = farts.length-1
			return Math.floor(Math.random() * (1+high-0)) + 0;
		}
	}
}