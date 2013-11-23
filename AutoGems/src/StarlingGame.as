package
{
	import com.autogems.AutoGemsGame;
	import com.autogems.GemBoard;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class StarlingGame extends Sprite
	{	
		private var board:GemBoard = new GemBoard();
		private var startBtn:Button;
		private var stopBtn:Button;
		
		
		public function StarlingGame()
		{
			super();
			var game:AutoGemsGame = AutoGemsGame.instance();
			
			board = new GemBoard();
			board.addEventListener(GemBoard.NO_MATCH, noMatchAnymore);
			
			addChild(new Image(game.getAssetMgr().getTexture("bg")));
			addChild(board);
			
			startBtn = new Button(
				game.getAssetMgr().getTexture("start_btn_idle"),"",
				game.getAssetMgr().getTexture("start_btn_active"));
				
			stopBtn = new Button(
				game.getAssetMgr().getTexture("stop_btn_idle"),"",
				game.getAssetMgr().getTexture("stop_btn_active"));
			
			startBtn.x = 340;
			startBtn.y = 150;
			startBtn.addEventListener(Event.TRIGGERED, btnPressed);
			stopBtn.x = 340;
			stopBtn.y = 220;
			stopBtn.addEventListener(Event.TRIGGERED, btnPressed);
			
			addChild(startBtn);
			addChild(stopBtn);
			
			stopBtn.enabled = false;
		}
		
		private function noMatchAnymore(e:Event):void
		{
			startBtn.enabled = true;
			stopBtn.enabled = false;
		}
		
		private function btnPressed(e:Event):void
		{
			if (e.target == startBtn)
			{
				board.start();
				startBtn.enabled = false;
				stopBtn.enabled = true;
			}
			else if (e.target == stopBtn)
			{
				board.stop();
				startBtn.enabled = true;
				stopBtn.enabled = false;
			}
		}
	}
}