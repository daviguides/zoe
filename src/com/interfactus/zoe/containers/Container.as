package com.interfactus.zoe.containers
{
import com.interfactus.zoe.core.UIComponent;
import com.interfactus.zoe.core.Zoe;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Loader;
import flash.display.Sprite;

public class Container extends UIComponent
{
    protected function createContentPane():void
    {
        if (contentPane)
            return;

        creatingContentPane = true;
		
		backgroundSkin = new Sprite();
		
		super.addChild(backgroundSkin);

        var n:int = numChildren;

        var newPane:Sprite = new Sprite();
        newPane.name = "contentPane";
        newPane.tabChildren = true;

        super.addChild(newPane);
		
		children = new Array();
        contentPane = newPane;

        contentPane.visible = true;
    }
		
	public function Container()
	{
		super();
		createContentPane();
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
		
		children.push(child);
		
		return child;
	}
	
	override public function getChildAt(index:int):DisplayObject
	{
		return contentPane.getChildAt(index);
	}
	
	public function removeAllChildren():void
	{
		for (var i:uint=0; i<contentPane.numChildren ; i++)
		{
			//removeChildAt(i);
		}
	}
	
	private var _data:Object;
	
	protected var contentPane:Object = null;
	public var children:Array = [];
	
	protected var _numChildren:int = 0;
	
	private var _creatingContentPane:Boolean = false;
	protected var backgroundSkin:Sprite;
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
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	{
		for (var i:uint=0; i<contentPane.numChildren ; i++)
		{
			var child:DisplayObject = getChildAt(i);
			child.x = unscaledWidth/2 - child.width/2;
			child.y = unscaledHeight/2 - child.height/2;
		}
	}
	
}
}