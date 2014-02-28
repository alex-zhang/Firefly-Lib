package com.fireflyLib.errors
{
    /** An AbstractClassError is thrown when you attempt to create an instance of an abstract 
     *  class. */
    public class AbstractClassError extends Error
    {
        /** Creates a new AbstractClassError object. */
        public function AbstractClassError(message:*="", id:*=0)
        {
            super(message, id);
        }
    }
}