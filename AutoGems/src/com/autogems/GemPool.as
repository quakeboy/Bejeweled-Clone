package com.autogems
{
	public class GemPool
	{
		private var gems:Vector.<Gem>;
		private var counter:int = 0;
		
		public function GemPool(max:int)
		{
			gems = new Vector.<Gem>;
			gems.length = max;
			gems.fixed = true;
		}
		
		public function addGem(gem:Gem):void
		{
			gems[counter++] = gem;
		}
		
		public function getGem():Gem
		{
			return gems[--counter];
		}
	}
}