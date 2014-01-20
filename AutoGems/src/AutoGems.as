package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import starling.core.Starling;
	
	[SWF(width="640", height="640", frameRate="60", backgroundColor="#DDDDDD")]
	public class AutoGems extends Sprite
	{
		public function AutoGems()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init (e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);

			var starlingRoot:Starling = new Starling(StarlingGame, this.stage);
			starlingRoot.start();
		}
	}
}