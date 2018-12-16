


//com.greensock.plugins.TransformMatrixPlugin

package com.greensock.plugins
{
	import com.greensock.TweenLite;
	import flash.geom.Matrix;
	import flash.geom.Transform;
	
	public class TransformMatrixPlugin extends TweenPlugin
	{
		
		public static const API:Number = 2;
		private static const _DEG2RAD:Number = (Math.PI / 180);//0.0174532925199433
		
		protected var _dChange:Number;
		protected var _txStart:Number;
		protected var _cStart:Number;
		protected var _matrix:Matrix;
		protected var _tyStart:Number;
		protected var _aStart:Number;
		protected var _angleChange:Number = 0;
		protected var _transform:Transform;
		protected var _aChange:Number;
		protected var _bChange:Number;
		protected var _tyChange:Number;
		protected var _txChange:Number;
		protected var _cChange:Number;
		protected var _dStart:Number;
		protected var _bStart:Number;
		
		public function TransformMatrixPlugin()
		{
			super("transformMatrix,x,y,scaleX,scaleY,rotation,width,height,transformAroundPoint,transformAroundCenter");
		}
		
		override public function setRatio(_arg_1:Number):void
		{
			var _local_2:Number;
			var _local_3:Number;
			var _local_4:Number;
			var _local_5:Number;
			this._matrix.a = (this._aStart + (_arg_1 * this._aChange));
			this._matrix.b = (this._bStart + (_arg_1 * this._bChange));
			this._matrix.c = (this._cStart + (_arg_1 * this._cChange));
			this._matrix.d = (this._dStart + (_arg_1 * this._dChange));
			if (this._angleChange)
			{
				_local_2 = Math.cos((this._angleChange * _arg_1));
				_local_3 = Math.sin((this._angleChange * _arg_1));
				_local_4 = this._matrix.a;
				_local_5 = this._matrix.c;
				this._matrix.a = ((_local_4 * _local_2) - (this._matrix.b * _local_3));
				this._matrix.b = ((_local_4 * _local_3) + (this._matrix.b * _local_2));
				this._matrix.c = ((_local_5 * _local_2) - (this._matrix.d * _local_3));
				this._matrix.d = ((_local_5 * _local_3) + (this._matrix.d * _local_2));
			}
			;
			this._matrix.tx = (this._txStart + (_arg_1 * this._txChange));
			this._matrix.ty = (this._tyStart + (_arg_1 * this._tyChange));
			this._transform.matrix = this._matrix;
		}
		
		override public function _onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
		{
			var _local_4:Number;
			var _local_5:Number;
			var _local_6:Number;
			var _local_7:Number;
			var _local_8:Number;
			var _local_9:Number;
			var _local_10:Number;
			var _local_11:Number;
			var _local_12:Number;
			var _local_13:Number;
			this._transform = (_arg_1.transform as Transform);
			this._matrix = this._transform.matrix;
			var _local_14:Matrix = this._matrix.clone();
			this._txStart = _local_14.tx;
			this._tyStart = _local_14.ty;
			this._aStart = _local_14.a;
			this._bStart = _local_14.b;
			this._cStart = _local_14.c;
			this._dStart = _local_14.d;
			if (("x" in _arg_2))
			{
				this._txChange = ((typeof(_arg_2.x) == "number") ? (_arg_2.x - this._txStart) : Number(_arg_2.x.split("=").join("")));
			}
			else
			{
				if (("tx" in _arg_2))
				{
					this._txChange = (_arg_2.tx - this._txStart);
				}
				else
				{
					this._txChange = 0;
				}
				;
			}
			;
			if (("y" in _arg_2))
			{
				this._tyChange = ((typeof(_arg_2.y) == "number") ? (_arg_2.y - this._tyStart) : Number(_arg_2.y.split("=").join("")));
			}
			else
			{
				if (("ty" in _arg_2))
				{
					this._tyChange = (_arg_2.ty - this._tyStart);
				}
				else
				{
					this._tyChange = 0;
				}
				;
			}
			;
			this._aChange = (("a" in _arg_2) ? (_arg_2.a - this._aStart) : 0);
			this._bChange = (("b" in _arg_2) ? (_arg_2.b - this._bStart) : 0);
			this._cChange = (("c" in _arg_2) ? (_arg_2.c - this._cStart) : 0);
			this._dChange = (("d" in _arg_2) ? (_arg_2.d - this._dStart) : 0);
			if (((((((((("rotation" in _arg_2) || ("shortRotation" in _arg_2)) || (("scale" in _arg_2) && (!(_arg_2 is Matrix)))) || ("scaleX" in _arg_2)) || ("scaleY" in _arg_2)) || ("skewX" in _arg_2)) || ("skewY" in _arg_2)) || ("skewX2" in _arg_2)) || ("skewY2" in _arg_2)))
			{
				_local_6 = Math.sqrt(((_local_14.a * _local_14.a) + (_local_14.b * _local_14.b)));
				if (_local_6 == 0)
				{
					_local_14.a = (_local_6 = 0.0001);
				}
				else
				{
					if (((_local_14.a < 0) && (_local_14.d > 0)))
					{
						_local_6 = -(_local_6);
					}
					;
				}
				;
				_local_7 = Math.sqrt(((_local_14.c * _local_14.c) + (_local_14.d * _local_14.d)));
				if (_local_7 == 0)
				{
					_local_14.d = (_local_7 = 0.0001);
				}
				else
				{
					if (((_local_14.d < 0) && (_local_14.a > 0)))
					{
						_local_7 = -(_local_7);
					}
					;
				}
				;
				_local_8 = Math.atan2(_local_14.b, _local_14.a);
				if (((_local_14.a < 0) && (_local_14.d >= 0)))
				{
					_local_8 = (_local_8 + ((_local_8 <= 0) ? Math.PI : -(Math.PI)));
				}
				;
				_local_9 = (Math.atan2(-(this._matrix.c), this._matrix.d) - _local_8);
				_local_10 = _local_8;
				if (("shortRotation" in _arg_2))
				{
					_local_12 = (((_arg_2.shortRotation * _DEG2RAD) - _local_8) % (Math.PI * 2));
					if (_local_12 > Math.PI)
					{
						_local_12 = (_local_12 - (Math.PI * 2));
					}
					else
					{
						if (_local_12 < -(Math.PI))
						{
							_local_12 = (_local_12 + (Math.PI * 2));
						}
						;
					}
					;
					_local_10 = (_local_10 + _local_12);
				}
				else
				{
					if (("rotation" in _arg_2))
					{
						_local_10 = ((typeof(_arg_2.rotation) == "number") ? (_arg_2.rotation * _DEG2RAD) : ((Number(_arg_2.rotation.split("=").join("")) * _DEG2RAD) + _local_8));
					}
					;
				}
				;
				_local_11 = (("skewX" in _arg_2) ? ((typeof(_arg_2.skewX) == "number") ? (Number(_arg_2.skewX) * _DEG2RAD) : ((Number(_arg_2.skewX.split("=").join("")) * _DEG2RAD) + _local_9)) : 0);
				if (("skewY" in _arg_2))
				{
					_local_13 = ((typeof(_arg_2.skewY) == "number") ? (_arg_2.skewY * _DEG2RAD) : ((Number(_arg_2.skewY.split("=").join("")) * _DEG2RAD) - _local_9));
					_local_10 = (_local_10 + (_local_13 + _local_9));
					_local_11 = (_local_11 - _local_13);
				}
				;
				if (_local_10 != _local_8)
				{
					if ((("rotation" in _arg_2) || ("shortRotation" in _arg_2)))
					{
						this._angleChange = (_local_10 - _local_8);
						_local_10 = _local_8;
					}
					else
					{
						_local_14.rotate((_local_10 - _local_8));
					}
					;
				}
				;
				if (("scale" in _arg_2))
				{
					_local_4 = (Number(_arg_2.scale) / _local_6);
					_local_5 = (Number(_arg_2.scale) / _local_7);
					if (typeof(_arg_2.scale) != "number")
					{
						_local_4 = (_local_4 + 1);
						_local_5 = (_local_5 + 1);
					}
					;
				}
				else
				{
					if (("scaleX" in _arg_2))
					{
						_local_4 = (Number(_arg_2.scaleX) / _local_6);
						if (typeof(_arg_2.scaleX) != "number")
						{
							_local_4 = (_local_4 + 1);
						}
						;
					}
					;
					if (("scaleY" in _arg_2))
					{
						_local_5 = (Number(_arg_2.scaleY) / _local_7);
						if (typeof(_arg_2.scaleY) != "number")
						{
							_local_5 = (_local_5 + 1);
						}
						;
					}
					;
				}
				;
				if (_local_11 != _local_9)
				{
					_local_14.c = (-(_local_7) * Math.sin((_local_11 + _local_10)));
					_local_14.d = (_local_7 * Math.cos((_local_11 + _local_10)));
				}
				;
				if (("skewX2" in _arg_2))
				{
					if (typeof(_arg_2.skewX2) == "number")
					{
						_local_14.c = Math.tan((0 - (_arg_2.skewX2 * _DEG2RAD)));
					}
					else
					{
						_local_14.c = (_local_14.c + Math.tan((0 - (Number(_arg_2.skewX2) * _DEG2RAD))));
					}
					;
				}
				;
				if (("skewY2" in _arg_2))
				{
					if (typeof(_arg_2.skewY2) == "number")
					{
						_local_14.b = Math.tan((_arg_2.skewY2 * _DEG2RAD));
					}
					else
					{
						_local_14.b = (_local_14.b + Math.tan((Number(_arg_2.skewY2) * _DEG2RAD)));
					}
					;
				}
				;
				if (((_local_4) || (_local_4 == 0)))
				{
					_local_14.a = (_local_14.a * _local_4);
					_local_14.b = (_local_14.b * _local_4);
				}
				;
				if (((_local_5) || (_local_5 == 0)))
				{
					_local_14.c = (_local_14.c * _local_5);
					_local_14.d = (_local_14.d * _local_5);
				}
				;
				this._aChange = (_local_14.a - this._aStart);
				this._bChange = (_local_14.b - this._bStart);
				this._cChange = (_local_14.c - this._cStart);
				this._dChange = (_local_14.d - this._dStart);
			}
			;
			return (true);
		}
	
	}
}//package com.greensock.plugins

