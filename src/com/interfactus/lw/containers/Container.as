package com.interfactus.lw.containers
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Loader;
import flash.display.Sprite;

import com.interfactus.lw.core.UIComponent;

public class Container extends UIComponent
{
	private var _data:Object;
	
	protected var contentPane:Sprite = null;
	
	protected var _numChildren:int = 0;
	
	private var _creatingContentPane:Boolean = false;
    public function get creatingContentPane():Boolean
    {
        return _creatingContentPane;
    }
    public function set creatingContentPane(value:Boolean):void
    {
        _creatingContentPane = value;
    }
	
    override public function get numChildren():int
    {
        return contentPane ? contentPane.numChildren : _numChildren;
    }

    public function get data():Object
    {
        return _data;
    }
    
    public function set data(value:Object):void
    {
        _data = value;

        invalidateProperties();
    }
    
    override public function addChild(child:DisplayObject):DisplayObject
    {
		return addChildAt(child, numChildren);
    }
    
    override public function addChildAt(child:DisplayObject,
                                        index:int):DisplayObject
    {
        var formerParent:DisplayObjectContainer = child.parent;
        if (formerParent && !(formerParent is Loader))
            formerParent.removeChild(child);
            
        if (contentPane)
            contentPane.addChildAt(child, index);

        return child;
    }
    
    
    protected function createContentPane():void
    {
        if (contentPane)
            return;

        creatingContentPane = true;

        var n:int = numChildren;

        var newPane:Sprite = new Sprite();
        newPane.name = "contentPane";
        newPane.tabChildren = true;

        var childIndex:int;
        super.addChildAt(newPane, childIndex);

        contentPane = newPane;

        contentPane.visible = true;
    }
		
	public function Container()
	{
		super();
		createContentPane();
	}
	
}
}