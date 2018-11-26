// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.greensock.plugins.TweenPlugin

package com.greensock.plugins
{
	import com.greensock.TweenLite;
	import com.greensock.core.PropTween;
	
	public class TweenPlugin
	{
		
		public static const version:String = "12.1.5";
		public static const API:Number = 2;
		
		public var _priority:int = 0;
		public var _overwriteProps:Array;
		public var _propName:String;
		protected var _firstPT:PropTween;
		
		public function TweenPlugin(_arg_1:String = "", _arg_2:int = 0)
		{
			this._overwriteProps = _arg_1.split(",");
			this._propName = this._overwriteProps[0];
			this._priority = ((_arg_2) || (0));
		}
		
		public static function activate(_arg_1:Array):Boolean
		{
			TweenLite._onPluginEvent = TweenPlugin._onTweenEvent;
			var _local_2:int = _arg_1.length;
			while (--_local_2 > -1)
			{
				if (_arg_1[_local_2].API == TweenPlugin.API)
				{
					TweenLite._plugins[new ((_arg_1[_local_2] as Class))()._propName] = _arg_1[_local_2];
				}
				;
			}
			;
			return (true);
		}
		
		private static function _onTweenEvent(_arg_1:String, _arg_2:TweenLite):Boolean
		{
			var _local_3:Boolean;
			var _local_4:PropTween;
			var _local_5:PropTween;
			var _local_6:PropTween;
			var _local_7:PropTween;
			var _local_8:PropTween = _arg_2._firstPT;
			if (_arg_1 == "_onInitAllProps")
			{
				while (_local_8)
				{
					_local_7 = _local_8._next;
					_local_4 = _local_5;
					while (((_local_4) && (_local_4.pr > _local_8.pr)))
					{
						_local_4 = _local_4._next;
					}
					;
					if ((_local_8._prev == ((_local_4) ? _local_4._prev : _local_6)))
					{
						_local_8._prev._next = _local_8;
					}
					else
					{
						_local_5 = _local_8;
					}
					;
					if ((_local_8._next == _local_4))
					{
						_local_4._prev = _local_8;
					}
					else
					{
						_local_6 = _local_8;
					}
					;
					_local_8 = _local_7;
				}
				;
				_local_8 = (_arg_2._firstPT = _local_5);
			}
			;
			while (_local_8)
			{
				if (_local_8.pg)
				{
					if ((_arg_1 in _local_8.t))
					{
						if (_local_8.t[_arg_1]())
						{
							_local_3 = true;
						}
						;
					}
					;
				}
				;
				_local_8 = _local_8._next;
			}
			;
			return (_local_3);
		}
		
		public function _roundProps(_arg_1:Object, _arg_2:Boolean = true):void
		{
			var _local_3:PropTween = this._firstPT;
			while (_local_3)
			{
				if (((this._propName in _arg_1) || ((!(_local_3.n == null)) && (_local_3.n.split((this._propName + "_")).join("") in _arg_1))))
				{
					_local_3.r = _arg_2;
				}
				;
				_local_3 = _local_3._next;
			}
			;
		}
		
		public function setRatio(_arg_1:Number):void
		{
			var _local_2:Number;
			var _local_4:*;
			var _local_3:PropTween = this._firstPT;
			while (_local_3)
			{
				_local_2 = ((_local_3.c * _arg_1) + _local_3.s);
				if (_local_3.r)
				{
					_local_2 = ((_local_2 + ((_local_2 > 0) ? 0.5 : -0.5)) | 0x00);
				}
				;
				if (_local_3.f)
				{
					_local_4 = _local_3.t;
					var _local_5:* = _local_4;
					(_local_5[_local_3.p](_local_2));
				}
				else
				{
					_local_3.t[_local_3.p] = _local_2;
				}
				;
				_local_3 = _local_3._next;
			}
			;
		}
		
		public function _kill(_arg_1:Object):Boolean
		{
			var _local_2:int;
			if ((this._propName in _arg_1))
			{
				this._overwriteProps = [];
			}
			else
			{
				_local_2 = this._overwriteProps.length;
				while (--_local_2 > -1)
				{
					if ((this._overwriteProps[_local_2] in _arg_1))
					{
						this._overwriteProps.splice(_local_2, 1);
					}
					;
				}
				;
			}
			;
			var _local_3:PropTween = this._firstPT;
			while (_local_3)
			{
				if ((_local_3.n in _arg_1))
				{
					if (_local_3._next)
					{
						_local_3._next._prev = _local_3._prev;
					}
					;
					if (_local_3._prev)
					{
						_local_3._prev._next = _local_3._next;
						_local_3._prev = null;
					}
					else
					{
						if (this._firstPT == _local_3)
						{
							this._firstPT = _local_3._next;
						}
						;
					}
					;
				}
				;
				_local_3 = _local_3._next;
			}
			;
			return (false);
		}
		
		protected function _addTween(_arg_1:Object, _arg_2:String, _arg_3:Number, _arg_4:*, _arg_5:String = null, _arg_6:Boolean = false):PropTween
		{
			var _local_7:Number = ((_arg_4 == null) ? 0 : (((typeof(_arg_4) === "number") || (!(_arg_4.charAt(1) === "="))) ? (Number(_arg_4) - _arg_3) : (int((_arg_4.charAt(0) + "1")) * Number(_arg_4.substr(2)))));
			if (_local_7 !== 0)
			{
				this._firstPT = new PropTween(_arg_1, _arg_2, _arg_3, _local_7, ((_arg_5) || (_arg_2)), false, this._firstPT);
				this._firstPT.r = _arg_6;
				return (this._firstPT);
			}
			;
			return (null);
		}
		
		public function _onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
		{
			return (false);
		}
	
	}
}//package com.greensock.plugins

