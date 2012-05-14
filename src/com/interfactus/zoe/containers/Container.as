package com.interfactus.zoe.containers
{
import com.interfactus.zoe.core.UIComponent;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Loader;
import flash.display.Sprite;

public class Container extends UIComponent
{
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
		
		children.push(child);

        return child;
    }
	
	public function removeAllChildren():void
	{
		for (var i:uint=0; i<contentPane.numChildren ; i++)
		{
			//removeChildAt(i);
		}
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
		
		children = new Array();
        contentPane = newPane;

        contentPane.visible = true;
    }
		
	public function Container()
	{
		super();
		createContentPane();
	}
	
	private var _data:Object;
	
	protected var contentPane:Sprite = null;
	public var children:Array = [];
	
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
}
}