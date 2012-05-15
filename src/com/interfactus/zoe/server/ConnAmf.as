// Class: ConnAmf
// Autor: Davi Luiz Guides
// Data: 30/02/06
package com.interfactus.zoe.server {
	
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	public class ConnAmf extends NetConnection {
		public function ConnAmf()
		{
			objectEncoding = ObjectEncoding.AMF3;
		}
	}
}