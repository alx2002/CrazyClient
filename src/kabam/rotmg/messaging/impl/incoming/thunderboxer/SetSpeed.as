﻿// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//kabam.rotmg.messaging.impl.incoming.thunderboxer.SetSpeed

package kabam.rotmg.messaging.impl.incoming.thunderboxer
{
    import kabam.rotmg.messaging.impl.incoming.IncomingMessage;
    import flash.utils.IDataInput;

    public class SetSpeed extends IncomingMessage 
    {

        public var spd:int;

        public function SetSpeed(_arg_1:uint, _arg_2:Function)
        {
            super(_arg_1, _arg_2);
        }

        override public function parseFromInput(_arg_1:IDataInput):void
        {
            this.spd = _arg_1.readInt();
        }

        override public function toString():String
        {
            return (formatToString("SETSPEED", "spd"));
        }


    }
}//package kabam.rotmg.messaging.impl.incoming.thunderboxer

