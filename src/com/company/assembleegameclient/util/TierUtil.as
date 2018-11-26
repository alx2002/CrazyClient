// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.company.assembleegameclient.util.TierUtil

package com.company.assembleegameclient.util
{
	import com.company.assembleegameclient.ui.tooltip.TooltipHelper;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.labels.UILabel;
	
	public class TierUtil
	{
		
		public static function getTierTag(_arg_1:XML, _arg_2:int = 12):UILabel
		{
			var _local_3:UILabel;
			var _local_4:Number;
			var _local_5:String;
			var _local_6:* = (isPet(_arg_1) == false);
			var _local_7:* = (_arg_1.hasOwnProperty("Consumable") == false);
			var _local_8:* = (_arg_1.hasOwnProperty("InvUse") == false);
			var _local_9:* = (_arg_1.hasOwnProperty("Treasure") == false);
			var _local_10:* = (_arg_1.hasOwnProperty("PetFood") == false);
			var _local_11:Boolean = _arg_1.hasOwnProperty("Tier");
			if ((((((_local_6) && (_local_7)) && (_local_8)) && (_local_9)) && (_local_10)))
			{
				_local_3 = new UILabel();
				if (_local_11)
				{
					_local_4 = 0xFFFFFF;
					_local_5 = ("T" + _arg_1.Tier);
				}
				else
				{
					if (_arg_1.hasOwnProperty("@setType"))
					{
						_local_4 = TooltipHelper.SET_COLOR;
						_local_5 = "ST";
					}
					else
					{
						_local_4 = TooltipHelper.UNTIERED_COLOR;
						_local_5 = "UT";
					}
					;
				}
				;
				_local_3.text = _local_5;
				DefaultLabelFormat.tierLevelLabel(_local_3, _arg_2, _local_4);
				return (_local_3);
			}
			;
			return (null);
		}
		
		public static function isPet(_arg_1:XML):Boolean
		{
			var activateTags:XMLList;
			var itemDataXML:XML = _arg_1;
			activateTags = itemDataXML.Activate.(text() == "PermaPet");
			return (activateTags.length() >= 1);
		}
	
	}
}//package com.company.assembleegameclient.util

