package com.interfactus.lw
{
	import flash.text.TextFormat;
	
public final class Assets extends Object
{
	/*[Embed(source="assets/css/swf/skin.swf", symbol="Button_upSkin")]
	public var Button_upSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_overSkin")]
	public var Button_overSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_downSkin")]
	public var Button_downSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_disabledSkin")]
	public var Button_disabledSkin:Class;
	
	/**
	 * Videos Controls Buttons
	 **************************/
	/*[Embed(source="assets/css/swf/skin.swf", symbol="Button_Play_upSkin")]
    public var Button_Play_upSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_Play_overSkin")]
    public var Button_Play_overSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_Play_downSkin")]
    public var Button_Play_downSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_Play_disabledSkin")]
    public var Button_Play_disabledSkin:Class;*/
    
	//[Embed(source="assets/css/swf/skin.swf", symbol="Button_Pause")]
    //public var PauseButton:Class;
	[Embed(source="assets/css/swf/video_player.swf", symbol="pauseButtonSkin")]
    public var PauseButton_upSkin:Class;
	[Embed(source="assets/css/swf/video_player.swf", symbol="pauseButtonSkin")]
    public var PauseButton_overSkin:Class;
	[Embed(source="assets/css/swf/video_player.swf", symbol="pauseButtonSkin")]
    public var PauseButton_downSkin:Class;
	[Embed(source="assets/css/swf/video_player.swf", symbol="pauseButtonSkin")]
    public var PauseButton_disabledSkin:Class;
    
	[Embed(source="assets/css/swf/video_player.swf", symbol="playButtonSkin")]
    public var PlayButton_upSkin:Class;
	[Embed(source="assets/css/swf/video_player.swf", symbol="playButtonSkin")]
    public var PlayButton_overSkin:Class;
	[Embed(source="assets/css/swf/video_player.swf", symbol="playButtonSkin")]
    public var PlayButton_downSkin:Class;
	[Embed(source="assets/css/swf/video_player.swf", symbol="playButtonSkin")]
    public var PlayButton_disabledSkin:Class;
    /*
	[Embed(source="assets/css/swf/video_player.swf", symbol="Button_FullScreen")]
    public var FullScreenButton:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_FullScreen_upSkin")]
    public var FullScreenButton_upSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_FullScreen_overSkin")]
    public var FullScreenButton_overSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_FullScreen_downSkin")]
    public var FullScreenButton_downSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_FullScreen_disabledSkin")]
    public var FullScreenButton_disabledSkin:Class;

	
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_Return")]
    public var ReturnButton:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_Return_upSkin")]
    public var ReturnButton_upSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_Return_overSkin")]
    public var ReturnButton_overSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_Return_downSkin")]
    public var ReturnButton_downSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_Return_disabledSkin")]
    public var ReturnButton_disabledSkin:Class;

    
	[Embed(source="assets/css/swf/skin.swf", symbol="CloseButtonUp")]
	public var CloseButton_upSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="CloseButtonOver")]
	public var CloseButton_overSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="CloseButtonDown")]
	public var CloseButton_downSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="CloseButtonDisabled")]
	public var CloseButton_disabledSkin:Class;
	
	[Embed(source="assets/css/swf/skin.swf", symbol="UpArrowButton_upSkin")]
	public var UpArrowButton_upSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="UpArrowButton_overSkin")]
	public var UpArrowButton_overSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="UpArrowButton_downSkin")]
	public var UpArrowButton_downSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="UpArrowButton_disabledSkin")]
	public var UpArrowButton_disabledSkin:Class;
	
	[Embed(source="assets/css/swf/skin.swf", symbol="DownArrowButton_upSkin")]
	public var DownArrowButton_upSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="DownArrowButton_overSkin")]
	public var DownArrowButton_overSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="DownArrowButton_downSkin")]
	public var DownArrowButton_downSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="DownArrowButton_disabledSkin")]
	public var DownArrowButton_disabledSkin:Class;
	
    /**
	 * Features Buttons
	 **************************/
	/*[Embed(source="assets/css/swf/skin.swf", symbol="Button_Comment_upSkin")]
    public var CommentButton_upSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_Comment_overSkin")]
    public var CommentButton_overSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_Comment_downSkin")]
    public var CommentButton_downSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_Comment_disabledSkin")]
    public var CommentButton_disabledSkin:Class;
    
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_Indicate_upSkin")]
    public var IndicateButton_upSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_Indicate_overSkin")]
    public var IndicateButton_overSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_Indicate_downSkin")]
    public var IndicateButton_downSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_Indicate_disabledSkin")]
    public var IndicateButton_disabledSkin:Class;
    
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_Share_upSkin")]
    public var ShareButton_upSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_Share_overSkin")]
    public var ShareButton_overSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_Share_downSkin")]
    public var ShareButton_downSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_Share_disabledSkin")]
    public var ShareButton_disabledSkin:Class;
    
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_Download_upSkin")]
    public var DownloadButton_upSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_Download_overSkin")]
    public var DownloadButton_overSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_Download_downSkin")]
    public var DownloadButton_downSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="Button_Download_disabledSkin")]
    public var DownloadButton_disabledSkin:Class;*/
    
    /**
    * Progress Slider Bar
    **************************/
    [Embed(source="assets/css/swf/skin.swf", symbol="SliderTrack_Skin")]
    public var SliderTrack_Skin:Class;
    [Embed(source="assets/css/swf/skin.swf", symbol="ProgressBar_Skin")]
    public var ProgressBar_Skin:Class;
    [Embed(source="assets/css/swf/skin.swf", symbol="SliderHighlight_Skin")]
    public var SliderHighlight_Skin:Class;
    [Embed(source="assets/css/swf/skin.swf", symbol="ProgressIndeterminateSkin")]
    public var ProgressIndeterminateSkin:Class;
    [Embed(source="assets/css/swf/skin.swf", symbol="SliderDisabled_Skin")]
    public var SliderDisabled_Skin:Class;
    
	[Embed(source="assets/css/swf/skin.swf", symbol="SliderThumb_upSkin")]
	public var SliderThumb_upSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="SliderThumb_overSkin")]
	public var SliderThumb_overSkin:Class;
	[Embed(source="assets/css/swf/skin.swf", symbol="SliderThumb_downSkin")]
	public var SliderThumb_downSkin:Class;
    [Embed(source="assets/css/swf/skin.swf", symbol="SliderThumb_disabledSkin")]
    public var SliderThumb_disabledSkin:Class;
    
    /**
    * Screen Icons
    **************************/
    [Embed(source="assets/css/swf/skin.swf", symbol="Buffering")]
    public var BufferingIcon:Class;
    /*
    [Embed(source="assets/css/swf/skin.swf", symbol="IconPlay_upSkin")]
    public var PlayScreenButton_upSkin:Class;
    [Embed(source="assets/css/swf/skin.swf", symbol="IconPlay_overSkin")]
    public var PlayScreenButton_overSkin:Class;
    [Embed(source="assets/css/swf/skin.swf", symbol="IconPlay_downSkin")]
    public var PlayScreenButton_downSkin:Class;
    [Embed(source="assets/css/swf/skin.swf", symbol="IconPlay_upSkin")]
    public var PlayScreenButton_disabledSkin:Class;*/
    
    public var h2:TextFormat;
	public var h3:TextFormat;
	public var h4:TextFormat;
	public var p:TextFormat;
	public var label:TextFormat;
	public var formItemLabel:TextFormat;
	public var buttonLabel:TextFormat;
	
	private function initStyle():void
	{
		
		h2 = new TextFormat();
		h2.font = "Verdana";
		h2.color = 0xFFFFFF;
		h2.size = 20; 
		h3 = new TextFormat();
		h3.font = "Verdana";
		h3.color = 0xFFFFFF;
		h3.size = 17;
		h4 = new TextFormat();
		h4.font = "Verdana";
		h4.color = 0xFFFFFF;
		h4.size = 14;
		p = new TextFormat();
		p.font = "Verdana";
		p.color = 0xFFFFFF;
		p.size = 10;
		label = new TextFormat();
		label.font = "Verdana";
		label.color = 0xFFFFFF;
		label.size = 8;
		formItemLabel = new TextFormat();
		formItemLabel.font = "Verdana";
		formItemLabel.align = "right";
		formItemLabel.color = 0x0b333c;
		formItemLabel.size = 10;
		buttonLabel = new TextFormat();
		buttonLabel.font = "Verdana";
		buttonLabel.color = 0x0b333c;
		buttonLabel.align = "center";
		buttonLabel.size = 10;
		buttonLabel.bold = true;
		
	}
    
    private static var assets : Assets;
    
    public static function getInstance() : Assets
	{
		if ( assets == null )
		{
			assets = new Assets();
			assets.initStyle();
	  	}
	  		
		return assets;
	}
	  
	public function Assets() 
	{	
	     if ( assets != null )
	     {
	     	throw new Error( "Only one Assets instance should be instantiated" );	
	     }
	     
	     
	     
	}
}
}