package ants
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import flash.display.MovieClip;
	
	public class AntObserver
	{
		protected var scareRadius:Number = 150;
		protected var _ants:Array;
		protected var dispatcher:IEventDispatcher;
		
		
		public function AntObserver(dispatcher:IEventDispatcher)
		{
			this.dispatcher = dispatcher;
			dispatcher.addEventListener(MouseEvent.MOUSE_DOWN, clickHandler);
		}
		
		
		public function set ants(value:Array):void
		{
			_ants = value;
		}
		
		
		protected function clickHandler(event:MouseEvent):void
		{
			var target:DisplayObject = DisplayObject(event.target);
			
			var stageX:Number = event.stageX;
			var stageY:Number = event.stageY;
			
			for(var a:uint = 0; a < _ants.length; a++)
			{
				var ant:Ant = _ants[a];
				if(ant.dead == false && ant.chillen == false) {
					var dx:Number = Math.abs(ant.x - stageX);
					var dy:Number = Math.abs(ant.y - stageY);
					
					var hyp:Number = Math.sqrt(dx * dx + dy * dy);
					if(hyp < scareRadius) ant.runFromPoint(stageX, stageY);
				}
				
			}
		}
		protected function smooshedHandler(event:AntEvent):void
		{
			var ant:MovieClip = event.target as MovieClip;
		}
		public function push(bug:*):void {
			_ants.push(bug);
		}
	}
}