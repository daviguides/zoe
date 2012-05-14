package com.interfactus.zoe.controls
{
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.ui.Keyboard;

public class AutoComplete extends TextField {
    private var txt:String;
    private var dict:Object;
    private var paused:Boolean = false;

    public function AutoComplete(t:String = "", w:uint = 200, h:uint = 20) {
        init(t);
        draw(w, h);
    }

    private function init(t:String):void {
        txt = t;
        dict = new Object();
        this.addEventListener(Event.CHANGE, changeListener);
        this.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
    }

    private function draw(w:uint, h:uint):void {
        this.border = true;
        this.background = true;
        this.type = TextFieldType.INPUT;
        this.height = h;
        this.width = w;
        this.text = txt;
    }

    public function addToDictionary(str:String):void {
        var strParts:Array = str.split("");
        strParts.push(new String());
        insert(strParts, dict);
    }

    private function insert(parts:Array, page:Object):void {
        if(parts[0] == undefined) {
            return;
        }

        var letter:String = parts[0];

        if(!page[letter]){
            page[letter] = new Object();
        }
        insert(parts.slice(1, parts.length), page[letter]);
    }

    private function getSuggestion(arr:Array):String {
        var suggestion:String = "";
        var len:uint = arr.length;
        var tmpDict:Object = dict;

        if(len < 1) {
            return suggestion;
        }

        var letter:String;
        for(var i:uint; i < len; i++) {
            letter = arr[i];
            if(tmpDict[letter.toUpperCase()] && tmpDict[letter.toLowerCase()]) {
                var upperTmpDict:Object = tmpDict[letter.toUpperCase()];
                var lowerTmpDict:Object = tmpDict[letter.toLowerCase()];
                tmpDict = mergeDictionaries(lowerTmpDict, upperTmpDict);
            }
            else if(tmpDict[letter.toUpperCase()]) {
                tmpDict = tmpDict[letter.toUpperCase()];
            }
            else if(tmpDict[letter.toLowerCase()]){
                tmpDict = tmpDict[letter.toLowerCase()];
            }
            else {
                return suggestion;
            }
        }

        var loop:Boolean = true;
        while(loop) {
            loop = false;
            for(var l:String in tmpDict) {
                if(shouldContinue(tmpDict)) {
                    suggestion += l;
                    tmpDict = tmpDict[l];
                    loop = true;
                    break;
                }
            }
        }

        return suggestion;
    }

    private function mergeDictionaries(lowerCaseDict:Object, upperCaseDict:Object):Object {
        var tmpDict:Object = new Object();

        for(var j:String in lowerCaseDict) {
            tmpDict[j] = lowerCaseDict[j];
        }

        for(var k:String in upperCaseDict) {
            if(tmpDict[k] != undefined && upperCaseDict[k] != undefined) {
                tmpDict[k] = mergeDictionaries(tmpDict[k], upperCaseDict[k]);
            }
            else {
                tmpDict[k] = upperCaseDict[k];
            }
        }
        return tmpDict;
    }

    private function shouldContinue(tmpDict:Object):Boolean {
        var count:Number = 0;
        for(var k:String in tmpDict) {
            if(count > 0) {
                return false;
            }
            count++;
        }
        return true;
    }

    private function changeListener(e:Event):void {
        if(!paused) {
            complete();
        }
    }

    private function keyDownListener(e:KeyboardEvent):void {
        if(e.keyCode == Keyboard.BACKSPACE || e.keyCode == Keyboard.DELETE) {
            paused = true;
        }
        else {
            paused = false;
        }
    }

    private function complete():void {
        var str:String = text.substr(0, caretIndex);
        var strParts:Array = str.split("");
        this.text = str;
        this.text += getSuggestion(strParts);
        setSelection(caretIndex, this.text.length);
    }        
} 
}