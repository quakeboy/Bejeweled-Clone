package com.autogems
{
	import flash.geom.Point;
	
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
		private var tween1:Tween;
		
		public static const GEM_TOUCHED:String = "GemTouched";
		public static const GEM_SWIPED:String = "GemSwiped";
		public static const GEM_MOVED:String = "GemMoved";
		
		public static const DISAPPEAR_DELAY:Number = 0.5;
		public static const MOVE_DELAY:Number = 0.2;
		
		private var holder:Sprite = new Sprite();
		
		private function randomNumber(min:Number, max:Number):Number 
		{
			return Math.floor(Math.random() * (1 + max - min) + min);
		}
		
		public function revive():void
		{
			this.alpha = holder.alpha = 1.0;
			this.marked = false;
			this.randomize();
			this.scaleX = this.scaleY = this.holder.scaleX = this.holder.scaleY = 1;
		}
		
		public function Gem()
		{
			super();
			
			var game:AutoGemsGame = AutoGemsGame.instance();
			
			gemTextures = new Array(
				game.getAssetMgr().getTexture("gem1"),
				game.getAssetMgr().getTexture("gem2"),
				game.getAssetMgr().getTexture("gem3"),
				game.getAssetMgr().getTexture("gem4"),
				game.getAssetMgr().getTexture("gem5"),
				game.getAssetMgr().getTexture("gem6"));
			
			addChild(holder);
				
			img = new Image(gemTextures[0]);
			holder.addChild(img);
			img.x = -img.width/2;
			img.y = -img.height/2;
			holder.x = img.width/2;
			holder.y = img.height/2;
			
			this.alpha = 0;
			
			tween = new Tween(this, DISAPPEAR_DELAY, Transitions.EASE_IN);
			tween.fadeTo(1);
			Starling.juggler.add(tween);
			
			tween1 = new Tween(this, DISAPPEAR_DELAY, Transitions.EASE_OUT);
			
			
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			
			//init gem to random type and set correct texture
			this.gemType = randomNumber(0, 5);
			if (this.gemType == 6) trace ("fuck");

		}
		
		private var lastTouchX:Number, lastTouchY:Number;
		private const delta:int = 40;
		private var direction:Point = new Point();
		private var swiped:Boolean = false;
		
		public function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			
			if (touch && touch.phase == TouchPhase.BEGAN)
			{
				swiped = false;
				lastTouchX = touch.globalX;
				lastTouchY = touch.globalY;
				
				this.dispatchEventWith(GEM_TOUCHED);
			}
			else if (!swiped && touch && touch.phase == TouchPhase.MOVED)
			{
				var dX:Number = touch.globalX - lastTouchX; 
				var dY:Number = touch.globalY - lastTouchY;
				
				//now check if a certain delta has been crossed on X or Y axis
				if (Math.abs(dX) > delta)
				{
					this.dispatchEventWith(GEM_SWIPED, false, new Point( (dX>0?1:-1), 0));
					swiped = true;
				}
				else if (Math.abs(dY) > delta)
				{
					this.dispatchEventWith(GEM_SWIPED, false, new Point(0, (dY>0?1:-1)));
					swiped = true;
				}
				
				
			}
		}
		
		public function moveTo(x:Number, y:Number, needCallback:Boolean = false):void
		{
			tween = new Tween(this, MOVE_DELAY, Transitions.EASE_IN);
			tween.moveTo(x, y);
			tween.fadeTo(1);
			if (needCallback) tween.onComplete = animationComplete;
			Starling.juggler.add(tween);
		}
		
		private function animationComplete():void
		{
			this.dispatchEventWith(GEM_MOVED);
		}
		
		public function disappear():Gem
		{
			//first grow and then shrink + fade
			tween = new Tween(holder, DISAPPEAR_DELAY, Transitions.EASE_IN);
			tween.scaleTo(1.1);
			
			tween1 = new Tween(holder, DISAPPEAR_DELAY, Transitions.EASE_OUT);
			tween1.scaleTo(1);
			tween1.fadeTo(0);
			tween.nextTween = tween1;
			
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
			if (this.gemType == 5) 
				this.gemType = 0;
			else 
				this.gemType++;
		}
		
		public function randomize():void
		{
			//1 in 16 chance for the wild card gem
			this.gemType = randomNumber(0, 5);		
			if (this.gemType == 6) trace ("fuck");
		}
	}
}