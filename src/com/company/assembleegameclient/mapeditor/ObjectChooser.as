


//com.company.assembleegameclient.mapeditor.ObjectChooser

package com.company.assembleegameclient.mapeditor
{
	
	
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.util.MoreStringUtil;
	import flash.utils.Dictionary;
	
	public class ObjectChooser extends Chooser
	{
		
		private var cache:Dictionary;
		private var lastSearch:String = "";
		
		public function ObjectChooser()
		{
			super(Layer.OBJECT);
			this.cache = new Dictionary();
		}
		
		public function getLastSearch():String
		{
			return (this.lastSearch);
		}
		
		public function reloadObjects(_arg_1:String = ""):void
		{
			var _local_2:RegExp;
			var _local_3:String;
			var _local_4:XML;
			var _local_5:int;
			var _local_6:ObjectElement;
			removeElements();
			this.lastSearch = _arg_1;
			var _local_7:Vector.<String> = new Vector.<String>();
			if (_arg_1 != "")
			{
				_local_2 = new RegExp(_arg_1, "gix");
			}
			;
			var _local_8:Dictionary = GroupDivider.GROUPS["Basic Objects"];
			for each (_local_4 in _local_8)
			{
				_local_3 = String(_local_4.@id);
				if (((_local_2 == null) || (_local_3.search(_local_2) >= 0)))
				{
					_local_7.push(_local_3);
				}
				;
			}
			;
			_local_7.sort(MoreStringUtil.cmp);
			for each (_local_3 in _local_7)
			{
				_local_5 = ObjectLibrary.idToType_[_local_3];
				_local_4 = ObjectLibrary.xmlLibrary_[_local_5];
				if ((!(this.cache[_local_5])))
				{
					_local_6 = new ObjectElement(_local_4);
					this.cache[_local_5] = _local_6;
				}
				else
				{
					_local_6 = this.cache[_local_5];
				}
				;
				addElement(_local_6);
			}
			;
			hasBeenLoaded = true;
			scrollBar_.setIndicatorSize(HEIGHT, elementContainer_.height, true);
		}
	
	}
}//package com.company.assembleegameclient.mapeditor

