


//com.greensock.plugins.BezierPlugin

package com.greensock.plugins
{
	import com.greensock.TweenLite;
	import flash.geom.Point;
	
	public class BezierPlugin extends TweenPlugin
	{
		
		public static const API:Number = 2;
		protected static const _RAD2DEG:Number = (180 / Math.PI);//57.2957795130823
		protected static var _r1:Array = [];
		protected static var _r2:Array = [];
		protected static var _r3:Array = [];
		protected static var _corProps:Object = {};
		
		protected var _startRatio:int;
		protected var _beziers:Object;
		protected var _length:Number;
		protected var _autoRotate:Array;
		protected var _s2:Number;
		protected var _lengths:Array;
		protected var _round:Object;
		protected var _curSeg:Array;
		protected var _prec:Number;
		protected var _segCount:int;
		protected var _timeRes:int;
		protected var _li:Number;
		protected var _func:Object;
		protected var _l1:Number;
		protected var _l2:Number;
		protected var _target:Object;
		protected var _props:Array;
		protected var _si:Number;
		protected var _initialRotations:Array;
		protected var _s1:Number;
		protected var _segments:Array;
		
		public function BezierPlugin()
		{
			super("bezier");
			this._overwriteProps.pop();
			this._func = {};
			this._round = {};
		}
		
		protected static function _parseLengthData(_arg_1:Object, _arg_2:uint = 6):Object
		{
			var _local_3:String;
			var _local_4:int;
			var _local_5:int;
			var _local_6:Number;
			var _local_7:Array = [];
			var _local_8:Array = [];
			var _local_9:Number = 0;
			var _local_10:Number = 0;
			var _local_11:int = (_arg_2 - 1);
			var _local_12:Array = [];
			var _local_13:Array = [];
			for (_local_3 in _arg_1)
			{
				_addCubicLengths(_arg_1[_local_3], _local_7, _arg_2);
			}
			;
			_local_5 = _local_7.length;
			_local_4 = 0;
			while (_local_4 < _local_5)
			{
				_local_9 = (_local_9 + Math.sqrt(_local_7[_local_4]));
				_local_6 = (_local_4 % _arg_2);
				_local_13[_local_6] = _local_9;
				if (_local_6 == _local_11)
				{
					_local_10 = (_local_10 + _local_9);
					_local_6 = ((_local_4 / _arg_2) >> 0);
					_local_12[_local_6] = _local_13;
					_local_8[_local_6] = _local_10;
					_local_9 = 0;
					_local_13 = [];
				}
				;
				_local_4++;
			}
			;
			return ({"length": _local_10, "lengths": _local_8, "segments": _local_12});
		}
		
		public static function bezierThrough(_arg_1:Array, _arg_2:Number = 1, _arg_3:Boolean = false, _arg_4:Boolean = false, _arg_5:String = "x,y,z", _arg_6:Object = null):Object
		{
			var _local_7:Array;
			var _local_8:int;
			var _local_9:String;
			var _local_10:int;
			var _local_11:Array;
			var _local_12:int;
			var _local_13:Number;
			var _local_14:Boolean;
			var _local_15:Object;
			var _local_16:Object = {};
			var _local_17:Object = ((_arg_6) || (_arg_1[0]));
			_arg_5 = (("," + _arg_5) + ",");
			if ((_local_17 is Point))
			{
				_local_7 = ["x", "y"];
			}
			else
			{
				_local_7 = [];
				for (_local_9 in _local_17)
				{
					_local_7.push(_local_9);
				}
				;
			}
			;
			if (_arg_1.length > 1)
			{
				_local_15 = _arg_1[(_arg_1.length - 1)];
				_local_14 = true;
				_local_8 = _local_7.length;
				while (--_local_8 > -1)
				{
					_local_9 = _local_7[_local_8];
					if (Math.abs((_local_17[_local_9] - _local_15[_local_9])) > 0.05)
					{
						_local_14 = false;
						break;
					}
					;
				}
				;
				if (_local_14)
				{
					_arg_1 = _arg_1.concat();
					if (_arg_6)
					{
						_arg_1.unshift(_arg_6);
					}
					;
					_arg_1.push(_arg_1[1]);
					_arg_6 = _arg_1[(_arg_1.length - 3)];
				}
				;
			}
			;
			_r1.length = (_r2.length = (_r3.length = 0));
			_local_8 = _local_7.length;
			while (--_local_8 > -1)
			{
				_local_9 = _local_7[_local_8];
				_corProps[_local_9] = (!(_arg_5.indexOf((("," + _local_9) + ",")) === -1));
				_local_16[_local_9] = _parseAnchors(_arg_1, _local_9, _corProps[_local_9], _arg_6);
			}
			;
			_local_8 = _r1.length;
			while (--_local_8 > -1)
			{
				_r1[_local_8] = Math.sqrt(_r1[_local_8]);
				_r2[_local_8] = Math.sqrt(_r2[_local_8]);
			}
			;
			if ((!(_arg_4)))
			{
				_local_8 = _local_7.length;
				while (--_local_8 > -1)
				{
					if (_corProps[_local_9])
					{
						_local_11 = _local_16[_local_7[_local_8]];
						_local_12 = (_local_11.length - 1);
						_local_10 = 0;
						while (_local_10 < _local_12)
						{
							_local_13 = ((_local_11[(_local_10 + 1)].da / _r2[_local_10]) + (_local_11[_local_10].da / _r1[_local_10]));
							_r3[_local_10] = (((_r3[_local_10]) || (0)) + (_local_13 * _local_13));
							_local_10++;
						}
						;
					}
					;
				}
				;
				_local_8 = _r3.length;
				while (--_local_8 > -1)
				{
					_r3[_local_8] = Math.sqrt(_r3[_local_8]);
				}
				;
			}
			;
			_local_8 = _local_7.length;
			_local_10 = ((_arg_3) ? 4 : 1);
			while (--_local_8 > -1)
			{
				_local_9 = _local_7[_local_8];
				_local_11 = _local_16[_local_9];
				_calculateControlPoints(_local_11, _arg_2, _arg_3, _arg_4, _corProps[_local_9]);
				if (_local_14)
				{
					_local_11.splice(0, _local_10);
					_local_11.splice((_local_11.length - _local_10), _local_10);
				}
				;
			}
			;
			return (_local_16);
		}
		
		private static function _addCubicLengths(_arg_1:Array, _arg_2:Array, _arg_3:uint = 6):void
		{
			var _local_4:Number;
			var _local_5:Number;
			var _local_6:Number;
			var _local_7:Number;
			var _local_8:Number;
			var _local_9:Number;
			var _local_10:Number;
			var _local_11:int;
			var _local_12:Number;
			var _local_13:Segment;
			var _local_14:int;
			var _local_15:Number = (1 / _arg_3);
			var _local_16:int = _arg_1.length;
			while (--_local_16 > -1)
			{
				_local_13 = _arg_1[_local_16];
				_local_6 = _local_13.a;
				_local_7 = (_local_13.d - _local_6);
				_local_8 = (_local_13.c - _local_6);
				_local_9 = (_local_13.b - _local_6);
				_local_4 = (_local_5 = 0);
				_local_11 = 1;
				while (_local_11 <= _arg_3)
				{
					_local_10 = (_local_15 * _local_11);
					_local_12 = (1 - _local_10);
					_local_4 = (_local_5 - (_local_5 = ((((_local_10 * _local_10) * _local_7) + ((3 * _local_12) * ((_local_10 * _local_8) + (_local_12 * _local_9)))) * _local_10)));
					_local_14 = (((_local_16 * _arg_3) + _local_11) - 1);
					_arg_2[_local_14] = (((_arg_2[_local_14]) || (0)) + (_local_4 * _local_4));
					_local_11++;
				}
				;
			}
			;
		}
		
		protected static function _parseAnchors(_arg_1:Array, _arg_2:String, _arg_3:Boolean, _arg_4:Object):Array
		{
			var _local_5:int;
			var _local_6:int;
			var _local_7:Number;
			var _local_8:Number;
			var _local_9:Number;
			var _local_10:Object;
			var _local_11:Array = [];
			if (_arg_4)
			{
				_arg_1 = [_arg_4].concat(_arg_1);
				_local_6 = _arg_1.length;
				while (--_local_6 > -1)
				{
					if (typeof(_local_10 = _arg_1[_local_6][_arg_2]) === "string")
					{
						if (_local_10.charAt(1) === "=")
						{
							_arg_1[_local_6][_arg_2] = (_arg_4[_arg_2] + Number((_local_10.charAt(0) + _local_10.substr(2))));
						}
						;
					}
					;
				}
				;
			}
			;
			_local_5 = (_arg_1.length - 2);
			if (_local_5 < 0)
			{
				_local_11[0] = new Segment(_arg_1[0][_arg_2], 0, 0, _arg_1[((_local_5 < -1) ? 0 : 1)][_arg_2]);
				return (_local_11);
			}
			;
			_local_6 = 0;
			while (_local_6 < _local_5)
			{
				_local_7 = _arg_1[_local_6][_arg_2];
				_local_8 = _arg_1[(_local_6 + 1)][_arg_2];
				_local_11[_local_6] = new Segment(_local_7, 0, 0, _local_8);
				if (_arg_3)
				{
					_local_9 = _arg_1[(_local_6 + 2)][_arg_2];
					_r1[_local_6] = (((_r1[_local_6]) || (0)) + ((_local_8 - _local_7) * (_local_8 - _local_7)));
					_r2[_local_6] = (((_r2[_local_6]) || (0)) + ((_local_9 - _local_8) * (_local_9 - _local_8)));
				}
				;
				_local_6++;
			}
			;
			_local_11[_local_6] = new Segment(_arg_1[_local_6][_arg_2], 0, 0, _arg_1[(_local_6 + 1)][_arg_2]);
			return (_local_11);
		}
		
		public static function cubicToQuadratic(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Array
		{
			var _local_5:Object = {"a": _arg_1};
			var _local_6:Object = {};
			var _local_7:Object = {};
			var _local_8:Object = {"c": _arg_4};
			var _local_9:Number = ((_arg_1 + _arg_2) / 2);
			var _local_10:Number = ((_arg_2 + _arg_3) / 2);
			var _local_11:Number = ((_arg_3 + _arg_4) / 2);
			var _local_12:Number = ((_local_9 + _local_10) / 2);
			var _local_13:Number = ((_local_10 + _local_11) / 2);
			var _local_14:Number = ((_local_13 - _local_12) / 8);
			_local_5.b = (_local_9 + ((_arg_1 - _local_9) / 4));
			_local_6.b = (_local_12 + _local_14);
			_local_5.c = (_local_6.a = ((_local_5.b + _local_6.b) / 2));
			_local_6.c = (_local_7.a = ((_local_12 + _local_13) / 2));
			_local_7.b = (_local_13 - _local_14);
			_local_8.b = (_local_11 + ((_arg_4 - _local_11) / 4));
			_local_7.c = (_local_8.a = ((_local_7.b + _local_8.b) / 2));
			return ([_local_5, _local_6, _local_7, _local_8]);
		}
		
		public static function quadraticToCubic(_arg_1:Number, _arg_2:Number, _arg_3:Number):Object
		{
			return (new Segment(_arg_1, (((2 * _arg_2) + _arg_1) / 3), (((2 * _arg_2) + _arg_3) / 3), _arg_3));
		}
		
		protected static function _calculateControlPoints(_arg_1:Array, _arg_2:Number = 1, _arg_3:Boolean = false, _arg_4:Boolean = false, _arg_5:Boolean = false):void
		{
			var _local_6:int;
			var _local_7:Number;
			var _local_8:Number;
			var _local_9:Number;
			var _local_10:Segment;
			var _local_11:Number;
			var _local_12:Number;
			var _local_13:Number;
			var _local_14:Number;
			var _local_15:Array;
			var _local_16:Number;
			var _local_17:Number;
			var _local_18:Number;
			var _local_20:int;
			var _local_19:int = (_arg_1.length - 1);
			var _local_21:Number = _arg_1[0].a;
			_local_6 = 0;
			while (_local_6 < _local_19)
			{
				_local_10 = _arg_1[_local_20];
				_local_7 = _local_10.a;
				_local_8 = _local_10.d;
				_local_9 = _arg_1[(_local_20 + 1)].d;
				if (_arg_5)
				{
					_local_16 = _r1[_local_6];
					_local_17 = _r2[_local_6];
					_local_18 = ((((_local_17 + _local_16) * _arg_2) * 0.25) / ((_arg_4) ? 0.5 : ((_r3[_local_6]) || (0.5))));
					_local_11 = (_local_8 - ((_local_8 - _local_7) * ((_arg_4) ? (_arg_2 * 0.5) : ((_local_16 !== 0) ? (_local_18 / _local_16) : 0))));
					_local_12 = (_local_8 + ((_local_9 - _local_8) * ((_arg_4) ? (_arg_2 * 0.5) : ((_local_17 !== 0) ? (_local_18 / _local_17) : 0))));
					_local_13 = (_local_8 - (_local_11 + ((((_local_12 - _local_11) * (((_local_16 * 3) / (_local_16 + _local_17)) + 0.5)) / 4) || (0))));
				}
				else
				{
					_local_11 = (_local_8 - (((_local_8 - _local_7) * _arg_2) * 0.5));
					_local_12 = (_local_8 + (((_local_9 - _local_8) * _arg_2) * 0.5));
					_local_13 = (_local_8 - ((_local_11 + _local_12) / 2));
				}
				;
				_local_11 = (_local_11 + _local_13);
				_local_12 = (_local_12 + _local_13);
				_local_10.c = (_local_14 = _local_11);
				if (_local_6 != 0)
				{
					_local_10.b = _local_21;
				}
				else
				{
					_local_10.b = (_local_21 = (_local_10.a + ((_local_10.c - _local_10.a) * 0.6)));
				}
				;
				_local_10.da = (_local_8 - _local_7);
				_local_10.ca = (_local_14 - _local_7);
				_local_10.ba = (_local_21 - _local_7);
				if (_arg_3)
				{
					_local_15 = cubicToQuadratic(_local_7, _local_21, _local_14, _local_8);
					_arg_1.splice(_local_20, 1, _local_15[0], _local_15[1], _local_15[2], _local_15[3]);
					_local_20 = (_local_20 + 4);
				}
				else
				{
					_local_20++;
				}
				;
				_local_21 = _local_12;
				_local_6++;
			}
			;
			_local_10 = _arg_1[_local_20];
			_local_10.b = _local_21;
			_local_10.c = (_local_21 + ((_local_10.d - _local_21) * 0.4));
			_local_10.da = (_local_10.d - _local_10.a);
			_local_10.ca = (_local_10.c - _local_10.a);
			_local_10.ba = (_local_21 - _local_10.a);
			if (_arg_3)
			{
				_local_15 = cubicToQuadratic(_local_10.a, _local_21, _local_10.c, _local_10.d);
				_arg_1.splice(_local_20, 1, _local_15[0], _local_15[1], _local_15[2], _local_15[3]);
			}
			;
		}
		
		public static function _parseBezierData(_arg_1:Array, _arg_2:String, _arg_3:Object = null):Object
		{
			var _local_4:Number;
			var _local_5:Number;
			var _local_6:Number;
			var _local_7:Number;
			var _local_8:Array;
			var _local_9:Array;
			var _local_10:int;
			var _local_11:int;
			var _local_12:int;
			var _local_13:String;
			var _local_14:int;
			var _local_15:Object;
			var _local_19:*;
			_arg_2 = ((_arg_2) || ("soft"));
			var _local_16:Object = {};
			var _local_17:int = ((_arg_2 === "cubic") ? 3 : 2);
			var _local_18:* = (_arg_2 === "soft");
			if (((_local_18) && (_arg_3)))
			{
				_arg_1 = [_arg_3].concat(_arg_1);
			}
			;
			if (((_arg_1 == null) || (_arg_1.length < (_local_17 + 1))))
			{
				throw(new Error("invalid Bezier data"));
			}
			;
			if ((_arg_1[1] is Point))
			{
				_local_9 = ["x", "y"];
			}
			else
			{
				_local_9 = [];
				for (_local_13 in _arg_1[0])
				{
					_local_9.push(_local_13);
				}
				;
			}
			;
			_local_10 = _local_9.length;
			while (--_local_10 > -1)
			{
				_local_13 = _local_9[_local_10];
				_local_16[_local_13] = (_local_8 = []);
				_local_14 = 0;
				_local_12 = _arg_1.length;
				_local_11 = 0;
				while (_local_11 < _local_12)
				{
					_local_4 = ((_arg_3 == null) ? _arg_1[_local_11][_local_13] : (((typeof(_local_15 = _arg_1[_local_11][_local_13]) === "string") && (_local_15.charAt(1) === "=")) ? (_arg_3[_local_13] + Number((_local_15.charAt(0) + _local_15.substr(2)))) : Number(_local_15)));
					if (_local_18)
					{
						if (_local_11 > 1)
						{
							if (_local_11 < (_local_12 - 1))
							{
								_local_19 = _local_14++;
								_local_8[_local_19] = ((_local_4 + _local_8[(_local_14 - 2)]) / 2);
							}
							;
						}
						;
					}
					;
					_local_19 = _local_14++;
					_local_8[_local_19] = _local_4;
					_local_11++;
				}
				;
				_local_12 = ((_local_14 - _local_17) + 1);
				_local_14 = 0;
				_local_11 = 0;
				while (_local_11 < _local_12)
				{
					_local_4 = _local_8[_local_11];
					_local_5 = _local_8[(_local_11 + 1)];
					_local_6 = _local_8[(_local_11 + 2)];
					_local_7 = ((_local_17 === 2) ? 0 : _local_8[(_local_11 + 3)]);
					_local_19 = _local_14++;
					_local_8[_local_19] = ((_local_17 === 3) ? new Segment(_local_4, _local_5, _local_6, _local_7) : new Segment(_local_4, (((2 * _local_5) + _local_4) / 3), (((2 * _local_5) + _local_6) / 3), _local_6));
					_local_11 = (_local_11 + _local_17);
				}
				;
				_local_8.length = _local_14;
			}
			;
			return (_local_16);
		}
		
		override public function _kill(_arg_1:Object):Boolean
		{
			var _local_2:String;
			var _local_3:int;
			var _local_4:Array = this._props;
			for (_local_2 in this._beziers)
			{
				if ((_local_2 in _arg_1))
				{
					delete this._beziers[_local_2];
					delete this._func[_local_2];
					_local_3 = _local_4.length;
					while (--_local_3 > -1)
					{
						if (_local_4[_local_3] === _local_2)
						{
							_local_4.splice(_local_3, 1);
						}
						;
					}
					;
				}
				;
			}
			;
			return (super._kill(_arg_1));
		}
		
		override public function setRatio(_arg_1:Number):void
		{
			var _local_2:int;
			var _local_3:Number;
			var _local_4:int;
			var _local_5:String;
			var _local_6:Segment;
			var _local_7:Number;
			var _local_8:Number;
			var _local_9:int;
			var _local_10:Array;
			var _local_11:Array;
			var _local_12:Array;
			var _local_13:Segment;
			var _local_14:Number;
			var _local_15:Number;
			var _local_16:Number;
			var _local_17:Number;
			var _local_18:Number;
			var _local_19:Number;
			var _local_24:*;
			var _local_20:int = this._segCount;
			var _local_21:Object = this._func;
			var _local_22:Object = this._target;
			var _local_23:* = (!(_arg_1 === this._startRatio));
			if (this._timeRes == 0)
			{
				_local_2 = ((_arg_1 < 0) ? 0 : ((_arg_1 >= 1) ? (_local_20 - 1) : ((_local_20 * _arg_1) >> 0)));
				_local_7 = ((_arg_1 - (_local_2 * (1 / _local_20))) * _local_20);
			}
			else
			{
				_local_10 = this._lengths;
				_local_11 = this._curSeg;
				_arg_1 = (_arg_1 * this._length);
				_local_4 = this._li;
				if (((_arg_1 > this._l2) && (_local_4 < (_local_20 - 1))))
				{
					_local_9 = (_local_20 - 1);
					do
					{
					} while (((_local_4 < _local_9) && ((this._l2 = _local_10[++_local_4]) <= _arg_1)));
					this._l1 = _local_10[(_local_4 - 1)];
					this._li = _local_4;
					this._curSeg = (_local_11 = this._segments[_local_4]);
					this._s2 = _local_11[(this._s1 = (this._si = 0))];
				}
				else
				{
					if (((_arg_1 < this._l1) && (_local_4 > 0)))
					{
						do
						{
						} while (((_local_4 > 0) && ((this._l1 = _local_10[--_local_4]) >= _arg_1)));
						if (((_local_4 === 0) && (_arg_1 < this._l1)))
						{
							this._l1 = 0;
						}
						else
						{
							_local_4++;
						}
						;
						this._l2 = _local_10[_local_4];
						this._li = _local_4;
						this._curSeg = (_local_11 = this._segments[_local_4]);
						this._s1 = ((_local_11[((this._si = (_local_11.length - 1)) - 1)]) || (0));
						this._s2 = _local_11[this._si];
					}
					;
				}
				;
				_local_2 = _local_4;
				_arg_1 = (_arg_1 - this._l1);
				_local_4 = this._si;
				if (((_arg_1 > this._s2) && (_local_4 < (_local_11.length - 1))))
				{
					_local_9 = (_local_11.length - 1);
					do
					{
					} while (((_local_4 < _local_9) && ((this._s2 = _local_11[++_local_4]) <= _arg_1)));
					this._s1 = _local_11[(_local_4 - 1)];
					this._si = _local_4;
				}
				else
				{
					if (((_arg_1 < this._s1) && (_local_4 > 0)))
					{
						do
						{
						} while (((_local_4 > 0) && ((this._s1 = _local_11[--_local_4]) >= _arg_1)));
						if (((_local_4 === 0) && (_arg_1 < this._s1)))
						{
							this._s1 = 0;
						}
						else
						{
							_local_4++;
						}
						;
						this._s2 = _local_11[_local_4];
						this._si = _local_4;
					}
					;
				}
				;
				_local_7 = ((_local_4 + ((_arg_1 - this._s1) / (this._s2 - this._s1))) * this._prec);
			}
			;
			_local_3 = (1 - _local_7);
			_local_4 = this._props.length;
			while (--_local_4 > -1)
			{
				_local_5 = this._props[_local_4];
				_local_6 = this._beziers[_local_5][_local_2];
				_local_8 = (((((_local_7 * _local_7) * _local_6.da) + ((3 * _local_3) * ((_local_7 * _local_6.ca) + (_local_3 * _local_6.ba)))) * _local_7) + _local_6.a);
				if (this._round[_local_5])
				{
					_local_8 = ((_local_8 + ((_local_8 > 0) ? 0.5 : -0.5)) >> 0);
				}
				;
				if (_local_21[_local_5])
				{
					_local_24 = _local_22;
					var _local_25:* = _local_24;
					(_local_25[_local_5](_local_8));
				}
				else
				{
					_local_22[_local_5] = _local_8;
				}
				;
			}
			;
			if (this._autoRotate != null)
			{
				_local_12 = this._autoRotate;
				_local_4 = _local_12.length;
				while (--_local_4 > -1)
				{
					_local_5 = _local_12[_local_4][2];
					_local_18 = ((_local_12[_local_4][3]) || (0));
					_local_19 = ((_local_12[_local_4][4] == true) ? 1 : _RAD2DEG);
					_local_6 = this._beziers[_local_12[_local_4][0]][_local_2];
					_local_13 = this._beziers[_local_12[_local_4][1]][_local_2];
					_local_14 = (_local_6.a + ((_local_6.b - _local_6.a) * _local_7));
					_local_16 = (_local_6.b + ((_local_6.c - _local_6.b) * _local_7));
					_local_14 = (_local_14 + ((_local_16 - _local_14) * _local_7));
					_local_16 = (_local_16 + (((_local_6.c + ((_local_6.d - _local_6.c) * _local_7)) - _local_16) * _local_7));
					_local_15 = (_local_13.a + ((_local_13.b - _local_13.a) * _local_7));
					_local_17 = (_local_13.b + ((_local_13.c - _local_13.b) * _local_7));
					_local_15 = (_local_15 + ((_local_17 - _local_15) * _local_7));
					_local_17 = (_local_17 + (((_local_13.c + ((_local_13.d - _local_13.c) * _local_7)) - _local_17) * _local_7));
					_local_8 = ((_local_23) ? ((Math.atan2((_local_17 - _local_15), (_local_16 - _local_14)) * _local_19) + _local_18) : this._initialRotations[_local_4]);
					if (_local_21[_local_5])
					{
						_local_24 = _local_22;
						_local_25 = _local_24;
						(_local_25[_local_5](_local_8));
					}
					else
					{
						_local_22[_local_5] = _local_8;
					}
					;
				}
				;
			}
			;
		}
		
		override public function _onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
		{
			var _local_4:String;
			var _local_5:Boolean;
			var _local_6:int;
			var _local_7:int;
			var _local_8:Array;
			var _local_9:Object;
			var _local_10:Object;
			this._target = _arg_1;
			var _local_11:Object = ((_arg_2 is Array) ? {"values": _arg_2} : _arg_2);
			this._props = [];
			this._timeRes = ((_local_11.timeResolution == null) ? 6 : int(_local_11.timeResolution));
			var _local_12:Array = ((_local_11.values) || ([]));
			var _local_13:Object = {};
			var _local_14:Object = _local_12[0];
			var _local_15:Object = ((_local_11.autoRotate) || (_arg_3.vars.orientToBezier));
			this._autoRotate = ((_local_15) ? ((_local_15 is Array) ? (_local_15 as Array) : [["x", "y", "rotation", ((_local_15 === true) ? 0 : Number(_local_15))]]) : null);
			if ((_local_14 is Point))
			{
				this._props = ["x", "y"];
			}
			else
			{
				for (_local_4 in _local_14)
				{
					this._props.push(_local_4);
				}
				;
			}
			;
			_local_6 = this._props.length;
			while (--_local_6 > -1)
			{
				_local_4 = this._props[_local_6];
				this._overwriteProps.push(_local_4);
				_local_5 = (this._func[_local_4] = (_arg_1[_local_4] is Function));
				_local_13[_local_4] = ((_local_5) ? _arg_1[(((_local_4.indexOf("set")) || (!(("get" + _local_4.substr(3)) in _arg_1))) ? _local_4 : ("get" + _local_4.substr(3)))]() : _arg_1[_local_4]);
				if ((!(_local_9)))
				{
					if (_local_13[_local_4] !== _local_12[0][_local_4])
					{
						_local_9 = _local_13;
					}
					;
				}
				;
			}
			;
			this._beziers = ((((!(_local_11.type === "cubic")) && (!(_local_11.type === "quadratic"))) && (!(_local_11.type === "soft"))) ? bezierThrough(_local_12, ((isNaN(_local_11.curviness)) ? 1 : _local_11.curviness), false, (_local_11.type === "thruBasic"), ((_local_11.correlate) || ("x,y,z")), _local_9) : _parseBezierData(_local_12, _local_11.type, _local_13));
			this._segCount = this._beziers[_local_4].length;
			if (this._timeRes)
			{
				_local_10 = _parseLengthData(this._beziers, this._timeRes);
				this._length = _local_10.length;
				this._lengths = _local_10.lengths;
				this._segments = _local_10.segments;
				this._l1 = (this._li = (this._s1 = (this._si = 0)));
				this._l2 = this._lengths[0];
				this._curSeg = this._segments[0];
				this._s2 = this._curSeg[0];
				this._prec = (1 / this._curSeg.length);
			}
			;
			if ((_local_8 == this._autoRotate))
			{
				this._initialRotations = [];
				if ((!(_local_8[0] is Array)))
				{
					this._autoRotate = (_local_8 = [_local_8]);
				}
				;
				_local_6 = _local_8.length;
				while (--_local_6 > -1)
				{
					_local_7 = 0;
					while (_local_7 < 3)
					{
						_local_4 = _local_8[_local_6][_local_7];
						this._func[_local_4] = ((_arg_1[_local_4] is Function) ? _arg_1[(((_local_4.indexOf("set")) || (!(("get" + _local_4.substr(3)) in _arg_1))) ? _local_4 : ("get" + _local_4.substr(3)))] : false);
						_local_7++;
					}
					;
					_local_4 = _local_8[_local_6][2];
					this._initialRotations[_local_6] = ((this._func[_local_4]) ? this._func[_local_4]() : this._target[_local_4]);
				}
				;
			}
			;
			this._startRatio = ((_arg_3.vars.runBackwards) ? 1 : 0);
			return (true);
		}
		
		override public function _roundProps(_arg_1:Object, _arg_2:Boolean = true):void
		{
			var _local_3:Array = this._overwriteProps;
			var _local_4:int = _local_3.length;
			while (--_local_4 > -1)
			{
				if ((((_local_3[_local_4] in _arg_1) || ("bezier" in _arg_1)) || ("bezierThrough" in _arg_1)))
				{
					this._round[_local_3[_local_4]] = _arg_2;
				}
				;
			}
			;
		}
	
	}
}//package com.greensock.plugins

class Segment
{
	
	public var a:Number;
	public var c:Number;
	public var b:Number;
	public var d:Number;
	public var da:Number;
	public var ca:Number;
	public var ba:Number;
	
	public function Segment(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number)
	{
		this.a = _arg_1;
		this.b = _arg_2;
		this.c = _arg_3;
		this.d = _arg_4;
		this.da = (_arg_4 - _arg_1);
		this.ca = (_arg_3 - _arg_1);
		this.ba = (_arg_2 - _arg_1);
	}

}

