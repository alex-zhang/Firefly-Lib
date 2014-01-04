package com.fireflyLib.debug
{
    import com.fireflyLib.utils.GlobalPropertyBag;
    import com.fireflyLib.utils.MathUtil;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.system.System;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;
    import flash.ui.Keyboard;
    
    /**
     * Console UI, which shows console log activity in-game, and also accepts input from the user.
     */
    public class LogViewer extends Sprite implements ILogAppender
    {
        protected var mMessageQueue:Array = [];
        protected var mMaxLength:uint = 200000;
        protected var mTruncating:Boolean = false;
        
        protected var mWidth:uint = 500;
        protected var mHeight:uint = 150;
        
        protected var mConsoleHistory:Array = [];
        protected var mHistoryIndex:uint = 0;
        
        protected var mOutputBitmap:Bitmap = new Bitmap();
        protected var mInput:TextField;
        
        protected var mTabCompletionPrefix:String = "";
        protected var mTabCompletionCurrentStart:int = 0;
        protected var mTabCompletionCurrentEnd:int = 0;
        protected var mTabCompletionCurrentOffset:int = 0;
		
        protected var mGlyphCache:GlyphCache = new GlyphCache();

        protected var mBottomLineIndex:int = int.MAX_VALUE;
        protected var mLogCache:Array = [];
        protected var mConsoleDirty:Boolean = true;
        
        public function LogViewer():void
        {
            layout();
            addListeners();
			
			name = "Console";
			
            Console.registerCommand("copy", onBitmapDoubleClick, "Copy the console to the clipboard.");
			Console.registerCommand("clear", onClearCommand, "Clears the console history.");
        }
        
        protected function layout():void
        {
            if(!mInput) createInputField();
            
            resize();
            
            mOutputBitmap.name = "ConsoleOutput";
            addEventListener(MouseEvent.CLICK, onBitmapClick);
            addEventListener(MouseEvent.DOUBLE_CLICK, onBitmapDoubleClick);
            
            addChild(mOutputBitmap);
            addChild(mInput);
            
            graphics.clear();
            graphics.beginFill(0x0, .5);
			graphics.drawRect(0, 0, mWidth+1, mHeight);
            graphics.endFill();

            // Necessary for click listeners.
            mouseEnabled = true;
            doubleClickEnabled = true;
            
            mConsoleDirty = true;
        }
        
        protected function addListeners():void
        {
            mInput.addEventListener(KeyboardEvent.KEY_DOWN, onInputKeyDownHandler, false, 1, true);
			mInput.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        }
        
        protected function removeListeners():void
        {
            mInput.removeEventListener(KeyboardEvent.KEY_DOWN, onInputKeyDownHandler);
			mInput.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
        }
		
        protected function onBitmapClick(me:MouseEvent):void
        {
            // Give focus to input.
			GlobalPropertyBag.stage.focus = mInput;
        }
        
        protected function onBitmapDoubleClick(me:MouseEvent = null):void
        {
            // Put everything into a monster string.
            var logString:String = "";
            for(var i:int=0; i<mLogCache.length; i++)
			{
                logString += mLogCache[i].text + "\n";
			}
            
            // Copy content.
            System.setClipboard(logString);
            
            Logger.print(this, "Copied console contents to clipboard.");
        }
        
        /**
         * Wipe the displayed console output.
         */
		protected function onClearCommand():void
		{
            mLogCache = [];
            mBottomLineIndex = -1;
            mConsoleDirty = true;
		}
        
        protected function resize():void
        {
            mOutputBitmap.x = 5;
            mOutputBitmap.y = 0;
            mInput.x = 5;
            
            if(stage)		
            {
                mWidth = stage.stageWidth - 1;
                mHeight = (stage.stageHeight / 3) * 2;
            }
            
            // Resize display surface.
            Profiler.enter("LogViewer_resizeBitmap");
			
			if(mOutputBitmap.bitmapData)
			{
				mOutputBitmap.bitmapData.dispose();
			}
			mOutputBitmap.bitmapData = new BitmapData(mWidth - 10, mHeight - 30, true, 0x0);
            
			Profiler.exit("LogViewer_resizeBitmap");
            
            mInput.height = 18;
            mInput.width = mWidth-10;
            
            mInput.y = mOutputBitmap.height + 7;

            mConsoleDirty = true;
        }

        protected function createInputField():TextField
        {
            mInput = new TextField();
            mInput.type = TextFieldType.INPUT;
            mInput.border = true;
            mInput.borderColor = 0xCCCCCC;
            mInput.multiline = false;
            mInput.wordWrap = false;
            mInput.condenseWhite = false;
            var format:TextFormat = mInput.getTextFormat();
			format.font = "Consolas";
            format.size = 12;
            format.color = 0xFFFFFF;
            mInput.setTextFormat(format);
            mInput.defaultTextFormat = format;
			mInput.name = "ConsoleInput";
            
            return mInput;
        }
        
        protected function setHistory(old:String):void
        {
            mInput.text = old;
//            PBE.callLater(function():void { mInput.setSelection(mInput.length, mInput.length); });
			mInput.setSelection(mInput.length, mInput.length); 
        }
        
        protected function onInputKeyDownHandler(event:KeyboardEvent):void
        {
            // If this was a non-tab input, clear tab completion state.
            if(event.keyCode != Keyboard.TAB && event.keyCode != Keyboard.SHIFT)
            {
                mTabCompletionPrefix = mInput.text;
                mTabCompletionCurrentStart = -1;
                mTabCompletionCurrentOffset = 0;
            }

            if(event.keyCode == Keyboard.ENTER)
            {
                // Execute an entered command.
                if(mInput.text.length <= 0)
				{
					// display a blank line
					addLogMessage("CMD", ">", mInput.text);
					return;
				}
                
                // If Enter was pressed, process the command
                processCommand();
            }
            else if (event.keyCode == Keyboard.UP)
            {
                // Go to previous command.
                if(mHistoryIndex > 0)
                {
                    setHistory(mConsoleHistory[--mHistoryIndex]); 
                }
                else if (mConsoleHistory.length > 0)
                {
                    setHistory(mConsoleHistory[0]);
                }
                
                event.preventDefault();
            }
            else if(event.keyCode == Keyboard.DOWN)
            {
                // Go to next command.
                if(mHistoryIndex < mConsoleHistory.length-1)
                {
                    setHistory(mConsoleHistory[++mHistoryIndex]); 
                }
                else if (mHistoryIndex == mConsoleHistory.length-1)
                {
                    mInput.text = "";
                }
                
                event.preventDefault();
            }
            else if(event.keyCode == Keyboard.PAGE_UP)
            {
                // Page the console view up.
                if(mBottomLineIndex == int.MAX_VALUE)
                    mBottomLineIndex = mLogCache.length - 1;
                
                mBottomLineIndex -= getScreenHeightInLines() - 2;
                
                if(mBottomLineIndex < 0)
                    mBottomLineIndex = 0;
            }
            else if(event.keyCode == Keyboard.PAGE_DOWN)
            {
                // Page the console view down.
                if(mBottomLineIndex != int.MAX_VALUE)
                {
                    mBottomLineIndex += getScreenHeightInLines() - 2;
                    
                    if(mBottomLineIndex + getScreenHeightInLines() >= mLogCache.length)
                        mBottomLineIndex = int.MAX_VALUE;                    
                }
            }
            else if(event.keyCode == Keyboard.TAB)
            {
                // We are doing tab searching.
                var list:Array = Console.getCommandList();
                
                // Is this the first step?
                var isFirst:Boolean = false;
                if(mTabCompletionCurrentStart == -1)
                {
                    mTabCompletionPrefix = mInput.text.toLowerCase();
                    mTabCompletionCurrentStart = int.MAX_VALUE;
                    mTabCompletionCurrentEnd = -1;

                    for(var i:int=0; i<list.length; i++)
                    {
                        // If we found a prefix match...
                        if(list[i].name.substr(0, mTabCompletionPrefix.length).toLowerCase() == mTabCompletionPrefix)
                        {
                            // Note it.
                            if(i < mTabCompletionCurrentStart)
                                mTabCompletionCurrentStart = i;
                            if(i > mTabCompletionCurrentEnd)
                                mTabCompletionCurrentEnd = i;

                            isFirst = true;
                        }
                    }
                    
                    mTabCompletionCurrentOffset = mTabCompletionCurrentStart;
                }
                
                // If there is a match, tab complete.
                if(mTabCompletionCurrentEnd != -1)
                {
                    // Update offset if appropriate.
                    if(!isFirst)
                    {
                        if(event.shiftKey)
                            mTabCompletionCurrentOffset--;
                        else
                            mTabCompletionCurrentOffset++;
                        
                        // Wrap the offset.
                        if(mTabCompletionCurrentOffset < mTabCompletionCurrentStart)
                        {
                            mTabCompletionCurrentOffset = mTabCompletionCurrentEnd;
                        }
                        else if(mTabCompletionCurrentOffset > mTabCompletionCurrentEnd)
                        {
                            mTabCompletionCurrentOffset = mTabCompletionCurrentStart;
                        }
                    }

                    // Get the match.
                    var potentialMatch:String = list[mTabCompletionCurrentOffset].name;
                    
                    // Update the text with the current completion, caret at the end.
                    mInput.text = potentialMatch;
                    mInput.setSelection(potentialMatch.length + 1, potentialMatch.length + 1);
                }
                
                // Make sure we keep focus. TODO: This is not ideal, it still flickers the yellow box.
//                var oldfr:* = stage.stageFocusRect;
//                stage.stageFocusRect = false;
//                PBE.callLater(function():void {
//                    stage.focus = mInput;
//                    stage.stageFocusRect = oldfr;
//                });
            }
            else if(event.keyCode == Console.hotKeyCode)
            {
                // Hide the console window, have to check here due to 
                // propagation stop at end of function.
                parent.removeChild(this);
                deactivate();
            }
            
            mConsoleDirty = true;
            
            // Keep console input from propagating up to the stage and messing up the game.
            event.stopImmediatePropagation();
        }
		
		protected function enterFrameHandler(event:Event):void
		{
			// Don't draw if we are clean or invisible.
			if(mConsoleDirty == false || parent == null) return;
			mConsoleDirty = false;
			
			Profiler.enter("LogViewer.redrawLog");
			
			// Figure our visible range.
			var lineHeight:int = getScreenHeightInLines() - 1;
			var startLine:int = 0;
			var endLine:int = 0;
			
			if(mBottomLineIndex == int.MAX_VALUE)
			{
				startLine = MathUtil.clamp(mLogCache.length - lineHeight, 0, int.MAX_VALUE);
			}
			else
			{
				startLine = MathUtil.clamp(mBottomLineIndex - lineHeight, 0, int.MAX_VALUE);
			}
			
			endLine = MathUtil.clamp(startLine + lineHeight, 0, mLogCache.length - 1);
			
			startLine--;
			
			// Wipe it.
			var bd:BitmapData = mOutputBitmap.bitmapData;
			bd.fillRect(bd.rect, 0x0);
			
			// Draw lines.
			for(var i:int=endLine; i>=startLine; i--)
			{
				// Skip empty.
				if(!mLogCache[i])
					continue;
				
				mGlyphCache.drawLineToBitmap(mLogCache[i].text, 0, mOutputBitmap.height - (endLine+1-i)*mGlyphCache.getLineHeight(), mLogCache[i].color, mOutputBitmap.bitmapData);
			}
			
			Profiler.exit("LogViewer.redrawLog");
		}
        
        protected function processCommand():void
        {
            addLogMessage("CMD", ">", mInput.text);
            Console.processLine(mInput.text);
            mConsoleHistory.push(mInput.text);
            mHistoryIndex = mConsoleHistory.length;
            mInput.text = "";
            
            mConsoleDirty = true;
        }
        
        public function getScreenHeightInLines():int
        {
            var roundedHeight:int = mOutputBitmap.bitmapData.height;
            return Math.floor(roundedHeight / mGlyphCache.getLineHeight());
        }
        
        public function addLogMessage(level:String, loggerName:String, message:String):void
        {
            var color:String = LogColor.getColor(level);
            
            // Cut down on the logger level if verbosity requests.
            if(Console.verbosity < 2)
            {
                var dotIdx:int = loggerName.lastIndexOf("::");
                if(dotIdx != -1)
                    loggerName = loggerName.substr(dotIdx + 2);
            }
            
            // Split message by newline and add to the list.
            var messages:Array = message.split("\n");
            for each (var msg:String in messages)
            {
                var text:String = ((Console.verbosity > 0) ? level + ": " : "") + loggerName + " - " + msg;
                mLogCache.push({"color": parseInt(color.substr(1), 16), "text": text});
            }
            
            mConsoleDirty = true;
        }
        
        public function activate():void
        {
            layout();
            mInput.text = "";
            addListeners();
			GlobalPropertyBag.stage.focus = mInput;
        }
        
        public function deactivate():void
        {
            removeListeners();
			GlobalPropertyBag.stage.focus = null;
        }
		
		public function set restrict(value:String):void
		{
			mInput.restrict = value;
		}
		
		public function get restrict():String
		{
			return mInput.restrict;
		}
    }
}
