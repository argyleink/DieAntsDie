package ants {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class AntGod extends MovieClip
	{
		protected var ants_:Array;
		protected var antObserver:AntObserver;
		protected var antPool:Array = [];
		protected var numAnts:uint;		
		protected var timeToRemoveBody:uint = 100;
		protected var game:DieAntsDie;
		
		public function AntGod($game:DieAntsDie) {
			game = $game;
		}
		
		public function createAntPool():Array
		{
			for(var i:int; i < 4; i++)
			{
				var ant:Ant = new Ant(game.$.fullScreenWidth+60,game.$.fullScreenHeight+60);
				ant.rotation = Math.random() * 360;
				
				ant.wander();
				//ant.cacheAsBitmapMatrix = new Matrix;
				
				game.$.addChild(ant);
				antPool.push(ant);
			}
			
			antObserver = new AntObserver(game.$);
			antObserver.ants = antPool;
			adjustAntSize();
			
			return antPool;
		}
		
		//+++++++++++++++    ANT STUFF   +++++++++++++++++++
		public function makeAnts():void {
			if(!game.antPool) { 
				game.antPool = createAntPool(); 
				putAntsOffStage(); 
			}
			else sendOutTheAnts();
			
			game.enableTouchKilling();
		}
		public function sendOutTheAnts():void {
			for each(var ant:Ant in game.antPool) {
				ant.wander();
			}
		}
		public function putAntsOffStage():void {
			for each(var ant:Ant in game.antPool) {
				if(Math.random() > 0.5) 	ant.x = game.rnum(-60, -60);
				else 						ant.x = game.rnum(game.$.fullScreenWidth+60, game.$.fullScreenWidth + 60)
				if(Math.random() > 0.5) 	ant.y = game.rnum(-60, -60);
				else 						ant.y = game.rnum(game.$.fullScreenHeight+60, game.$.fullScreenHeight + 60);
			}
		}
		public function stopAllAnts():void {
			for each(var ant:Ant in game.antPool) {
				ant.stop(); }
		}
		public function kill_ant(_deadAnt:Ant, _x:uint, _y:uint):void {
			if(game._gutsEnabled) {
				var splat:Sprite;
				if(game.hotFingers.active) 	splat = new ash_1();
				else 						splat = this.splat();
				splat.rotation = _deadAnt.rotation;
				splat.x = _deadAnt.x;
				splat.y = _deadAnt.y;
				splat.scaleX = splat.scaleY = _deadAnt.scaleX;
				game.views.splats.addChild(splat);
				splat.cacheAsBitmap = true;
			}
			if(!game.teleport.active && !game.hotFingers.active) {
				//throw parts around				
				var body:big_ant = new big_ant();
				
				body.x = _deadAnt.x;
				body.y = _deadAnt.y;
				body.scaleX = body.scaleY = _deadAnt.scaleX;
				body.rotation = _deadAnt.rotation;
				
				for(var x:uint = 0; x < body.numChildren; x++) {
					body.getChildAt(x).x = body.getChildAt(x).y = game.rnum(2,5);
					body.getChildAt(x).rotation = game.rnum(5,60);
				}
				
				game.views.splats.addChild(body);
				
				if	(game._gutsEnabled) body.cacheAsBitmap = true;
				else 					body.addEventListener(Event.ENTER_FRAME, gutsOffBodyRemoval);	
			}
			else if(game.hotFingers.active) {
				var ash:Sprite = new ash_1();
				ash.scaleX = ash.scaleY = _deadAnt.scaleX;
				ash.rotation = _deadAnt.rotation;				
				ash.x = _deadAnt.x;
				ash.y = _deadAnt.y;
				game.views.splats.addChild(ash);
				
				//if(!game.hotFingers.flameActive) {
					var flame:firepile_ = new firepile_();
					flame.rotation = _deadAnt.rotation;
					flame.x = _deadAnt.x;
					flame.y = _deadAnt.y;
					flame.scaleX = flame.scaleY = _deadAnt.scaleX;
					flame.play();
					game.hotFingers.flameActive = true;
					game.views.splats.addChild(flame);
				//}
				
				if	(game._gutsEnabled) ash.cacheAsBitmap = true;
				else 					ash.addEventListener(Event.ENTER_FRAME, gutsOffBodyRemoval);
			}
			else if (game.teleport) {
				var body:big_ant = new big_ant();
				
				body.x = _deadAnt.x;
				body.y = _deadAnt.y;
				body.scaleX = body.scaleY = _deadAnt.scaleX;
				body.rotation = _deadAnt.rotation;
				
				game.views.splats.addChild(body);
				
				if	(game._gutsEnabled) body.cacheAsBitmap = true;
				else 					body.addEventListener(Event.ENTER_FRAME, vaccuumEffect);
			}
			
			if(Math.random() > 0.5) _deadAnt.x = game.rnum(-30, -30);
			else _deadAnt.x = game.rnum(game.$.fullScreenWidth+30, game.$.fullScreenWidth + 30)
			if(Math.random() > 0.5) _deadAnt.y = game.rnum(-30, -30);
			else _deadAnt.y = game.rnum(game.$.fullScreenHeight+30, game.$.fullScreenHeight + 30);
		}
		
		public function gutsOffBodyRemoval(e:Event):void {
			if	   (timeToRemoveBody > 0) 	{ timeToRemoveBody--; }
			else if(timeToRemoveBody == 0)  {
				e.target.visible = false;
				timeToRemoveBody = 100;
				removeEventListener(Event.ENTER_FRAME, gutsOffBodyRemoval);
			}
		}
		
		public function vaccuumEffect(e:Event):void {
			if	   (e.target.width > 0) { 
				//e.target.x += (game.stage.mouseX - e.target.x) / 5;
				//e.target.y += (game.stage.mouseY - e.target.y) / 5;
				e.target.width *= e.target.height *= -.10;
			}
			else if(e.target.width == 0)  {
				e.target.visible = false;
				removeEventListener(Event.ENTER_FRAME, gutsOffBodyRemoval);
			}
		}
		
		public function splat():Sprite {
			var random:uint = Math.floor(Math.random()*(1+7-1))+1;
			var s:Sprite;
			
			switch(random) {
				case 1: s = new _splat1(); break;
				case 2: s = new _splat2(); break;
				case 3: s = new _splat3(); break;
				case 4: s = new _splat4(); break;
				case 5: s = new _splat5(); break;
				case 6: s = new _splat6(); break;
				case 7: s = new _splat7(); break;
			}
			
			return s;
		}
		
		public function adjustAntSize():void {
			for each(var ant:Ant in game.antPool) {
				switch (game._difficulty) {
					case "easy":
						ant.scaleX = ant.scaleY = 1;
						break;
					case "medium":
						ant.scaleX = ant.scaleY = 0.7;
						break;
					case "hard":
						ant.scaleX = ant.scaleY = 0.4;
						break;
				}
			}
		}
	}
}