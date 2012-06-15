package com.interfactus.zoe.containers
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class ViewStack extends Container
	{
		private var _selectedIndex:int = -1;
		private var proposedSelectedIndex:int = -1;
		private var initialSelectedIndex:int = -1;
		private var lastIndex:int = -1;
		private var firstChildBlank:Boolean;
		
		public function ViewStack(firstChildBlank:Boolean=true) {
			this.firstChildBlank = firstChildBlank;
			if(firstChildBlank) {
				var blank:DisplayObject = new Sprite();
				super.addChild(blank);
				
				proposedSelectedIndex = 0;
				invalidateProperties();
			} else {
				proposedSelectedIndex = 0;
				invalidateProperties();
			}
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			if(!firstChildBlank && numChildren > 1)
				child.visible = false;
			else
				child.visible = false;
			
			if(child is IClose)
				(child as IClose).close.add(
					function():void{proposedSelectedIndex=0;invalidateProperties();});
			return super.addChild(child);
		}
		
		public function get selectedIndex():int
		{
			return proposedSelectedIndex == -1 ?
				_selectedIndex :
				proposedSelectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			if (value == selectedIndex)
				return;
			
			proposedSelectedIndex = value;
			invalidateProperties();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (proposedSelectedIndex != -1)
			{
				commitSelectedIndex(proposedSelectedIndex);
				proposedSelectedIndex = -1;
			}
		}
		
		protected function commitSelectedIndex(newIndex:int):void
		{
			if (numChildren == 0)
			{
				_selectedIndex = -1;
				return;
			}
			if (newIndex < 0)
				newIndex = 0;
			else if (newIndex > numChildren - 1)
				newIndex = numChildren - 1;
			
			lastIndex = _selectedIndex;
			
			if (newIndex == lastIndex)
				return;
			
			_selectedIndex = newIndex;
			
			if (initialSelectedIndex == -1)
				initialSelectedIndex = _selectedIndex;
			
			var listenForEffectEnd:Boolean = false;
			var currentChild:Sprite;
			
			if (lastIndex != -1 && lastIndex < numChildren)
			{
				currentChild = Sprite(getChildAt(lastIndex));
				
				currentChild.visible = false; // Hide the current child
			}
			
			if (_selectedIndex != -1 && _selectedIndex < numChildren)
			{
				currentChild = Sprite(getChildAt(_selectedIndex));
				
				currentChild.visible = true;
			}
		}
		
	}
}