// Class: ConnAmf
// Autor: Davi Luiz Guides
// Data: 30/02/06
package com.interfactus.lw.server {

import flash.net.NetConnection;
import flash.net.ObjectEncoding;
public class ConnAmf extends NetConnection {
	public function ConnAmf(gatewayURL:String)
	{
		objectEncoding = ObjectEncoding.AMF3;
		connect(gatewayURL);
	}
	public function AppendToGatewayUrl(append:String):void
	{
	}
	public function AddHeader():void
	{
		
	}
	public function ReplaceGatewayUrl(append:String):void
	{
	}
}
}