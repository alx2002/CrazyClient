// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.greensock.easing.Ease

package com.greensock.easing
{
    public class Ease 
    {

        protected static var _baseParams:Array = [0, 0, 1, 1];

        protected var _p1:Number;
        protected var _p2:Number;
        protected var _func:Function;
        protected var _params:Array;
        protected var _p3:Number;
        public var _power:int;
        public var _calcEnd:Boolean;
        public var _type:int;

        public function Ease(_arg_1:Function=null, _arg_2:Array=null, _arg_3:Number=0, _arg_4:Number=0)
        {
            this._func = _arg_1;
            this._params = ((_arg_2) ? _baseParams.concat(_arg_2) : _baseParams);
            this._type = _arg_3;
            this._power = _arg_4;
        }

        public function getRatio(_arg_1:Number):Number
        {
            var _local_2:Number;
            if (this._func != null)
            {
                this._params[0] = _arg_1;
                return (this._func.apply(null, this._params));
            };
            _local_2 = ((this._type == 1) ? (1 - _arg_1) : ((this._type == 2) ? _arg_1 : ((_arg_1 < 0.5) ? (_arg_1 * 2) : ((1 - _arg_1) * 2))));
            if (this._power == 1)
            {
                _local_2 = (_local_2 * _local_2);
            }
            else
            {
                if (this._power == 2)
                {
                    _local_2 = (_local_2 * (_local_2 * _local_2));
                }
                else
                {
                    if (this._power == 3)
                    {
                        _local_2 = (_local_2 * ((_local_2 * _local_2) * _local_2));
                    }
                    else
                    {
                        if (this._power == 4)
                        {
                            _local_2 = (_local_2 * (((_local_2 * _local_2) * _local_2) * _local_2));
                        };
                    };
                };
            };
            return ((this._type == 1) ? (1 - _local_2) : ((this._type == 2) ? _local_2 : ((_arg_1 < 0.5) ? (_local_2 / 2) : (1 - (_local_2 / 2)))));
        }


    }
}//package com.greensock.easing

