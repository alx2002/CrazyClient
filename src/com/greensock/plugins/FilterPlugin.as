


//com.greensock.plugins.FilterPlugin

package com.greensock.plugins
{
	import com.greensock.TweenLite;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	
	public class FilterPlugin extends TweenPlugin
	{
		
		public static const API:Number = 2;
		
		protected var _remove:Boolean;
		private var _tween:TweenLite;
		protected var _target:Object;
		protected var _index:int;
		protected var _filter:BitmapFilter;
		protected var _type:Class;
		
		public function FilterPlugin(_arg_1:String = "", _arg_2:Number = 0)
		{
			super(_arg_1, _arg_2);
		}
		
		protected function _initFilter(_arg_1:*, _arg_2:Object, _arg_3:TweenLite, _arg_4:Class, _arg_5:BitmapFilter, _arg_6:Array):Boolean
		{
			var _local_7:String;
			var _local_8:int;
			var _local_9:HexColorsPlugin;
			this._target = _arg_1;
			this._tween = _arg_3;
			this._type = _arg_4;
			var _local_10:Array = this._target.filters;
			var _local_11:Object = ((_arg_2 is BitmapFilter) ? {} : _arg_2);
			if (_local_11.index != null)
			{
				this._index = _local_11.index;
			}
			else
			{
				this._index = _local_10.length;
				if (_local_11.addFilter != true)
				{
					do
					{
					} while (((--this._index > -1) && (!(_local_10[this._index] is this._type))));
				}
				;
			}
			;
			if (((this._index < 0) || (!(_local_10[this._index] is this._type))))
			{
				if (this._index < 0)
				{
					this._index = _local_10.length;
				}
				;
				if (this._index > _local_10.length)
				{
					_local_8 = (_local_10.length - 1);
					while (++_local_8 < this._index)
					{
						_local_10[_local_8] = new BlurFilter(0, 0, 1);
					}
					;
				}
				;
				_local_10[this._index] = _arg_5;
				this._target.filters = _local_10;
			}
			;
			this._filter = _local_10[this._index];
			this._remove = (_local_11.remove == true);
			_local_8 = _arg_6.length;
			while (--_local_8 > -1)
			{
				_local_7 = _arg_6[_local_8];
				if (((_local_7 in _arg_2) && (!(this._filter[_local_7] == _arg_2[_local_7]))))
				{
					if ((((_local_7 == "color") || (_local_7 == "highlightColor")) || (_local_7 == "shadowColor")))
					{
						_local_9 = new HexColorsPlugin();
						_local_9._initColor(this._filter, _local_7, _arg_2[_local_7]);
						_addTween(_local_9, "setRatio", 0, 1, _propName);
					}
					else
					{
						if (((((_local_7 == "quality") || (_local_7 == "inner")) || (_local_7 == "knockout")) || (_local_7 == "hideObject")))
						{
							this._filter[_local_7] = _arg_2[_local_7];
						}
						else
						{
							_addTween(this._filter, _local_7, this._filter[_local_7], _arg_2[_local_7], _propName);
						}
						;
					}
					;
				}
				;
			}
			;
			return (true);
		}
		
		override public function setRatio(_arg_1:Number):void
		{
			super.setRatio(_arg_1);
			var _local_2:Array = this._target.filters;
			if ((!(_local_2[this._index] is this._type)))
			{
				this._index = _local_2.length;
				do
				{
				} while (((--this._index > -1) && (!(_local_2[this._index] is this._type))));
				if (this._index == -1)
				{
					this._index = _local_2.length;
				}
				;
			}
			;
			if (((((_arg_1 == 1) && (this._remove)) && (this._tween._time == this._tween._duration)) && (!(this._tween.data == "isFromStart"))))
			{
				if (this._index < _local_2.length)
				{
					_local_2.splice(this._index, 1);
				}
				;
			}
			else
			{
				_local_2[this._index] = this._filter;
			}
			;
			this._target.filters = _local_2;
		}
	
	}
}//package com.greensock.plugins

