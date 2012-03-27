package storage
{
	import DieAntsDie;
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.events.Event;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	public class SQL_Database
	{
		private var sqlc:SQLConnection = new SQLConnection();
		private var sqls:SQLStatement = new SQLStatement();
		private var game:DieAntsDie;
		private var queryState:String = "just_opened";
		
		public function sqlInit($game:DieAntsDie):void
		{
			game = $game;
			
			var db:File = File.applicationStorageDirectory.resolvePath("DieAntsDie.db");
			sqlc.openAsync(db);
			
			sqlc.addEventListener(SQLEvent.OPEN, db_opened);
			sqlc.addEventListener(SQLErrorEvent.ERROR, error);
			sqls.addEventListener(SQLErrorEvent.ERROR, error);
			sqls.addEventListener(SQLEvent.RESULT, result);			
		}
		
		private function db_opened(e:SQLEvent):void {
			sqls.sqlConnection = sqlc;
			getGameData();
			//deleteDB();
		}
		
		private function createDB():void {
			queryState = "db_create";
			
			sqls.text = "CREATE TABLE IF NOT EXISTS DieAntsDie " +
						"( " +
							"id INTEGER PRIMARY KEY AUTOINCREMENT, " +
							"level UINT, " +
							"score UINT, " +
							"kills UINT, " +
							"queens UINT, " +
							"killspeed UINT, " +
							"difficulty TEXT(10), " +
							"sound UINT, " +
							"guts UINT " +
						");";
			sqls.execute();
		}
		
		private function doInitialInserts():void {
			queryState = "fill_db";
			
			sqls.text = "INSERT INTO DieAntsDie " +
						"VALUES ( " +
							"NULL, " +
							"0, " +
							"0, " +
							"0, " +
							"0, " +
							"0, " +
							"'medium', " +
							"1, " +
							"1 " +
						");";
			sqls.execute();
		}
		
		public function storeProgress():void {
			sqls.text = "UPDATE DieAntsDie SET " +
						"level = "		+game.curLevel+", " +
						"score = "		+game.score+", " +
						"kills = "		+game.totalKills+", " +
						"queens = "		+game.queenKills+", " +
						"killspeed = "	+game.killSpeed+" " +
						"WHERE id = 1;";
			sqls.execute();
		}
		
		public function storeGameData():void {
			if(game._soundEnabled == true) var s:uint = 1; else var sound:uint = 0;
			if(game._gutsEnabled == true)  var g:uint = 1; else var guts:uint = 0;
			
			sqls.text = "UPDATE DieAntsDie SET " +
						"difficulty='"+game._difficulty+"', " +
						"sound="		+s+", " +
						"guts="		+g+" WHERE id = 1;";
			sqls.execute();
		}
		
		public function getGameData():void {
			if(queryState != "just_opened") queryState = "game_data"; 
			sqls.text = "SELECT * " +
						"FROM DieAntsDie " +
						"WHERE id = 1;";
			sqls.execute();
		}
		
		public function deleteDB():void {
			sqls.text = "DROP TABLE DieAntsDie;";
			sqls.execute();
			trace('table deleted');
		}
		
		private function result(e:SQLEvent):void
		{
			var data:Array = sqls.getResult().data;
			trace(queryState);
			
			if		(queryState == "just_opened") {
				if(!data || data == null) 		queryState = "no_db";
				else if(data[0].queens != null) queryState = "game_data";
				else if(data[0].kills != null)  saveOldGameInfo(data);
			}
			else if (queryState == "spit_db") 	trace(data);
			
			if	    (queryState == "no_db") 			createDB();
			else if	(queryState == "db_create")	 	  { doInitialInserts(); trace('game database created successfully'); }
			else if (queryState == "fill_db")		  { getGameData(); trace('initial inserts complete'); }
			else if (queryState == "db_old") 			giveDatabaseUpdates();			
			else if (queryState == "updates_complete")  getGameData();
			else if (data != null && data[0].level != null && data[0].score != null && data[0].kills != null && data[0].queens != null && data[0].killspeed != null) {	
				syncGameData(data);
			}
			else if(data != null && queryState == "game_data") syncGameData(data); 
		}
		
		private function error(e:SQLErrorEvent):void
		{
			trace(e.error);
			if(queryState == "just_opened") 	createDB(); // they have no DB for this game
			else if(queryState == "db_create")	spitDBForMe();
		}
		
		private function syncGameData(data:Array):void {
			game.curLevel = 		data[0].level;
			game.score = 			data[0].score;
			game.totalKills = 		data[0].kills;
			game.queenKills = 		data[0].queens;
			game.killSpeed = 		data[0].killspeed;
			game._difficulty = 		data[0].difficulty;
			game._soundEnabled =	data[0].sound;
			game._gutsEnabled = 	data[0].guts;
			
			game.views.home.updateDynamicFields();
			game.returningPlayer = true;
			queryState = "game_updated";
		}
		
		private function giveDatabaseUpdates():void {
			if(!x) var x:uint = 0;
			
			switch (x) {
				case 0:
					sqls.text = 
					"CREATE TABLE DieAntsDie(" +
						"id INTEGER PRIMARY KEY AUTOINCREMENT, " +
						"level UINT, " +
						"score UINT, " +
						"kills UINT, " +
						"queens UINT, " +
						"killspeed UINT, " +
						"difficulty TEXT(10), " +
						"sound UINT, " +
						"guts UINT " +
					");";
					queryState = "new_db";
					break;
				case 1:
					sqls.text = "INSERT INTO DieAntsDie ( level,score,kills ) " +
								"VALUES ( "+
								game.curLevel+"," +
								game.score+"," +
								game.totalKills+" );"; //set with values pulled earlier
					queryState = "updates_complete";
					break;
			}
			x++;
			sqls.execute();
		}
		
		private function saveOldGameInfo(data:Array):void {
			queryState = "db_old";
			
			game.curLevel = 	data[0].level;
			game.score = 		data[0].score;
			game.totalKills = 	data[0].kills;
		}
		
		private function spitDBForMe():void {
			queryState = "spit_db";
			sqls.text = "SELECT * FROM DieAntsDie;";
			sqls.execute();
		}
	}
}