


//com.greensock.plugins.ColorTransformPlugin

package com.greensock.plugins
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	public class ColorTransformPlugin extends TintPlugin
	{
		
		public static const API:Number = 2;
		
		public function ColorTransformPlugin()
		{
			_propName = "colorTransform";
		}
		
		override public function _onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
		{
			var _local_4:ColorTransform;
			var _local_5:String;
			var _local_6:Number;
			var _local_7:ColorTransform = new ColorTransform();
			if ((_arg_1 is DisplayObject))
			{
				_transform = DisplayObject(_arg_1).transform;
				_local_4 = _transform.colorTransform;
			}
			else
			{
				if ((_arg_1 is ColorTransform))
				{
					_local_4 = (_arg_1 as ColorTransform);
				}
				else
				{
					return (false);
				}
				;
			}
			;
			if ((_arg_2 is ColorTransform))
			{
				_local_7.concat(_arg_2);
			}
			else
			{
				_local_7.concat(_local_4);
			}
			;
			for (_local_5 in _arg_2)
			{
				if (((_local_5 == "tint") || (_local_5 == "color")))
				{
					if (_arg_2[_local_5] != null)
					{
						_local_7.color = int(_arg_2[_local_5]);
					}
					;
				}
				else
				{
					if ((!(((_local_5 == "tintAmount") || (_local_5 == "exposure")) || (_local_5 == "brightness"))))
					{
						_local_7[_local_5] = _arg_2[_local_5];
					}
					;
				}
				;
			}
			;
			if ((!(_arg_2 is ColorTransform)))
			{
				if ((!(isNaN(_arg_2.tintAmount))))
				{
					_local_6 = (_arg_2.tintAmount / (1 - (((_local_7.redMultiplier + _local_7.greenMultiplier) + _local_7.blueMultiplier) / 3)));
					_local_7.redOffset = (_local_7.redOffset * _local_6);
					_local_7.greenOffset = (_local_7.greenOffset * _local_6);
					_local_7.blueOffset = (_local_7.blueOffset * _local_6);
					_local_7.redMultiplier = (_local_7.greenMultiplier = (_local_7.blueMultiplier = (1 - _arg_2.tintAmount)));
				}
				else
				{
					if ((!(isNaN(_arg_2.exposure))))
					{
						_local_7.redOffset = (_local_7.greenOffset = (_local_7.blueOffset = (0xFF * (_arg_2.exposure - 1))));
						_local_7.redMultiplier = (_local_7.greenMultiplier = (_local_7.blueMultiplier = 1));
					}
					else
					{
						if ((!(isNaN(_arg_2.brightness))))
						{
							_local_7.redOffset = (_local_7.greenOffset = (_local_7.blueOffset = Math.max(0, ((_arg_2.brightness - 1) * 0xFF))));
							_local_7.redMultiplier = (_local_7.greenMultiplier = (_local_7.blueMultiplier = (1 - Math.abs((_arg_2.brightness - 1)))));
						}
						;
					}
					;
				}
				;
			}
			;
			_init(_local_4, _local_7);
			return (true);
		}
	
	}
}//package com.greensock.plugins

