package com.interfactus.zoe.containers
{
public class ViewStack extends Container
{
    private var _selectedIndex:int = -1;
    private var proposedSelectedIndex:int = -1;
    private var initialSelectedIndex:int = -1;
    private var lastIndex:int = -1;
    
    public function ViewStack()
	{
		super();
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

        if (lastIndex != -1 && lastIndex < numChildren)
        {
            var currentChild:Container = Container(getChildAt(lastIndex));

            currentChild.visible = false; // Hide the current child
        }
    }
		
}
}