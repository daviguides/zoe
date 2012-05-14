package com.interfactus.zoe.utils
{

import flash.net.SharedObject;

public class Session
{
	private static var so_Session:SharedObject = SharedObject.getLocal("TV");
	
	public static function get data():Object
	{
		if( so_Session.data.Session == undefined ) {
			so_Session.data.Session = new Object;
		} 
		return so_Session.data.Session;
	}
	
	public static function set data(value:Object):void
	{
		if( so_Session.data.Session == undefined ) {
			so_Session.data.Session = new Object;
			so_Session.data.Session = value;
		} else {
			so_Session.data.Session = value;
		}
	}
	/*
	public static var browserManager:IBrowserManager;
	
	public static function initBrowserManager():void
	{
		if(browserManager==null){
			browserManager = BrowserManager.getInstance();
			browserManager.init();
			browserManager.addEventListener(BrowserChangeEvent.BROWSER_URL_CHANGE, parseURL);
		}
	}
	
	public static function parseURL():void
	{
		initBrowserManager();
	    var state:Object = URLUtil.stringToObject(browserManager.fragment);
		if (state.vid != undefined) {
			//new VideoEvent(VideoEvent.GET, '',uint(state.vid)).dispatch();
        }
	}
	
	public static function updateURL(selectedVideo:Object):void
    {
        var state:Object = {};
        state.vid = selectedVideo.id;
        browserManager.setTitle('Vflow WebTV Demo - '+selectedVideo.name);
		var s:String = URLUtil.objectToString(state);
		browserManager.setFragment(s);
    }*/
}
}
