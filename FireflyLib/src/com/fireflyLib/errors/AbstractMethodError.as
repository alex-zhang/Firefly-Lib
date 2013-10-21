package com.fireflyLib.errors
{
    /** An AbstractMethodError is thrown when you attempt to call an abstract method. */
	public class AbstractMethodError extends Error
    {
		/** Creates a new AbstractMethodError object. */
        public function AbstractMethodError(message:*="", id:*=0)
        {
            super(message, id);
        }
    }
}