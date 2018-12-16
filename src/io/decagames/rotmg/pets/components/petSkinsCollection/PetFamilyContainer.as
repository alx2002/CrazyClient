


//io.decagames.rotmg.pets.components.petSkinsCollection.PetFamilyContainer

package io.decagames.rotmg.pets.components.petSkinsCollection
{
	import io.decagames.rotmg.pets.data.family.PetFamilyColors;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.gird.UIGridElement;
	import io.decagames.rotmg.ui.labels.UILabel;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.texture.TextureParser;
	import io.decagames.rotmg.utils.colors.Tint;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	
	public class PetFamilyContainer extends UIGridElement
	{
		
		public function PetFamilyContainer(_arg_1:String, _arg_2:int, _arg_3:int)
		{
			var _local_4:SliceScalingBitmap;
			var _local_5:UILabel;
			var _local_6:SliceScalingBitmap;
			super();
			var _local_7:uint = PetFamilyColors.KEYS_TO_COLORS[_arg_1];
			_local_4 = TextureParser.instance.getSliceScalingBitmap("UI", "content_divider_white", 320);
			Tint.add(_local_4, _local_7, 1);
			addChild(_local_4);
			_local_4.x = 10;
			_local_4.y = 3;
			_local_5 = new UILabel();
			DefaultLabelFormat.petFamilyLabel(_local_5, 0xFFFFFF);
			_local_5.text = LineBuilder.getLocalizedStringFromKey(_arg_1);
			_local_5.y = 0;
			_local_5.x = (((320 / 2) - (_local_5.width / 2)) + 10);
			_local_6 = TextureParser.instance.getSliceScalingBitmap("UI", "content_divider_smalltitle_white", (_local_5.width + 20));
			Tint.add(_local_6, _local_7, 1);
			addChild(_local_6);
			_local_6.x = (((320 / 2) - (_local_6.width / 2)) + 10);
			_local_6.y = 0;
			addChild(_local_5);
		}
	
	}
}//package io.decagames.rotmg.pets.components.petSkinsCollection

