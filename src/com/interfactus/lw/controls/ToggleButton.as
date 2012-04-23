package com.interfactus.lw.controls
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	import com.interfactus.lw.core.UIComponent;

public class ToggleButton extends UIComponent
{
	private var sizeChanged:Boolean = false;
	private var _height:Number=0;
	override public function set height(value:Number):void
	{
		_height=value;
		sizeChanged = true;
		invalidateDisplayList();
	}
	
	override public function get height():Number
	{
		return _height;
	}
	
	private var _width:Number=0;
	override public function set width(value:Number):void
	{
		_width=value;
		sizeChanged = true;
		invalidateDisplayList();
	}
	
	override public function get width():Number
	{
		return _width;
	}
	
	public function ToggleButton()
	{
		super();
		mouseEnabled = true;
	}
	
	private var _enabled:Boolean = true;
    private var enabledChanged:Boolean = false;
    public function get enabled():Boolean
    {
    	return _enabled;
    }
    public function set enabled(value:Boolean):void
    {
    	_enabled = value;
    	this.mouseEnabled = value;
    	enabledChanged = true;
    	
    	invalidateDisplayList();
    }
    
    private var unselectedButton:Button;
	private var selectedButton:Button;
	
	private var _unselectedStyleName:String;
	private var _selectedStyleName:String;
	
	public function set unselectedStyleName(value:String):void
	{
		_unselectedStyleName = value;
		//unselectedButton.visible = !_selected;
	}
	
	public function set selectedStyleName(value:String):void
	{
		_selectedStyleName = value;
		//selectedButton.visible = _selected;
	}
	
    override protected function createChildren():void
    {
    	unselectedButton = new Button();
    	unselectedButton.styleName = _unselectedStyleName;
    	selectedButton = new Button();
    	selectedButton.styleName =  _selectedStyleName;
		
		unselectedButton.addEventListener(MouseEvent.CLICK, clickHandler);
		selectedButton.addEventListener(MouseEvent.CLICK, clickHandler);
    	
    	addChild(unselectedButton);
    	addChild(selectedButton);
    	selectedButton.visible = false;
    	_width = unselectedButton.width;
    	_height = unselectedButton.height;
		
		super.createChildren();
    }
    
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
    	if(enabledChanged){
			selectedButton.enabled = _enabled;
			unselectedButton.enabled = _enabled;
		}
    }
	
	private function clickHandler(event:MouseEvent):void
	{
		selected = !_selected;
	}
	
	private var _selected:Boolean = false;
	
    public function get selected():Boolean
    {
        return _selected;
    }

    /**
     *  @private
     */
    public function set selected(value:Boolean):void
    {
        if (_selected != value)
        {
            _selected = value;
            selectedButton.visible = _selected;
			unselectedButton.visible = !_selected;
        }
    }
}
}