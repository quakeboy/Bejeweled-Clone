package com.autogems
{
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class Gem extends Sprite
	{
		private var img:Image;
		private var gemTextures:Array;
		private var tween:Tween;
		
		public static const GEM_TOUCHED:String = "GemTouched";
		
		public static const DISAPPEAR_DELAY:Number = 0.5;
		public static const MOVE_DELAY:Number = 0.5;
		
		private function randomNumber(min:Number, max:Number):Number 
		{
			return Math.floor(Math.random() * (1 + max - min) + min);
		}
		
		public function revive():void
		{
			this.alpha = 1.0;
			this.marked = false;
			this.randomize();
		}
		
		public function Gem()
		{
			super();
			
			var game:AutoGemsGame = AutoGemsGame.instance();
			
			gemTextures = new Array(
				game.getAssetMgr().getTexture("gem1"),
				game.getAssetMgr().getTexture("gem2"),
				game.getAssetMgr().getTexture("gem3"),
				game.getAssetMgr().getTexture("gem4"));
			
			img = new Image(gemTextures[0]);
			addChild(img);
			
			this.alpha = 0;
			
			tween = new Tween(this, DISAPPEAR_DELAY, Transitions.EASE_IN);
			tween.fadeTo(1);
			Starling.juggler.add(tween);
			
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			
			//init gem to random type and set correct texture
			this.gemType = randomNumber(0, 3);
		}
		
		public function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);

			if (touch && touch.phase == TouchPhase.BEGAN)
				this.dispatchEventWith(GEM_TOUCHED);
		}
		
		public function moveTo(x:Number, y:Number):void
		{
			tween.reset(this, MOVE_DELAY, Transitions.EASE_IN);
			tween.moveTo(x, y);
			tween.fadeTo(1);
			Starling.juggler.add(tween);
		}
		
		public function disappear():Gem
		{
			tween.reset(this, DISAPPEAR_DELAY, Transitions.EASE_OUT);
			tween.fadeTo(0);
			Starling.juggler.add(tween);
			this.marked = true;
			
			return this;
		}
		
		//================   properties type, row and col ==================
		
		private var _marked:Boolean = false;
		public function get marked():Boolean { return _marked; }
		
		public function set marked(value:Boolean):void
		{
			if (_marked == value)
				return;
			_marked = value;
		}
		
		
		
		private var _gemType:int;
		public function get gemType():int { return _gemType; }
		
		public function set gemType(value:int):void
		{
			if (_gemType == value)
				return;
			
			_gemType = value;
			
			if (_gemType < gemTextures.length)
				img.texture = gemTextures[_gemType] as Texture;
		}
		
		private var _row:int;
		public function get row():int { return _row; }
		
		public function set row(value:int):void
		{
			if (_row == value)
				return;
			_row = value;
		}
		
		private var _col:int;
		public function get col():int { return _col; }
		
		public function set col(value:int):void
		{
			if (_col == value)
				return;
			_col = value;
		}
		
		public function cycle():void
		{
			if (this.gemType == 2 || this.gemType == 3) 
				this.gemType = 0;
			else 
				this.gemType++;
		}
		
		public function randomize():void
		{
			//1 in 16 chance for the wild card gem
			this.gemType = randomNumber(0, 3);
			
			if (this.gemType == 3)
				this.gemType = randomNumber(0, 3);
		}
	}
}