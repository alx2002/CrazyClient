


//com.company.assembleegameclient.mapeditor.DungeonChooser

package com.company.assembleegameclient.mapeditor
{
	
	
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.util.MoreStringUtil;
	import flash.utils.Dictionary;
	
	public class DungeonChooser extends Chooser
	{
		
		public var currentDungon:String = "";
		private var cache:Dictionary;
		private var lastSearch:String = "";
		
		public function DungeonChooser()
		{
			super(Layer.OBJECT);
			this.cache = new Dictionary();
		}
		
		public function getLastSearch():String
		{
			return (this.lastSearch);
		}
		
		public function reloadObjects(_arg_1:String, _arg_2:String):void
		{
			var _local_3:RegExp;
			var _local_4:String;
			var _local_5:XML;
			var _local_6:int;
			var _local_7:ObjectElement;
			this.currentDungon = _arg_1;
			removeElements();
			this.lastSearch = _arg_2;
			var _local_8:Vector.<String> = new Vector.<String>();
			if (_arg_2 != "")
			{
				_local_3 = new RegExp(_arg_2, "gix");
			}
			;
			var _local_9:Dictionary = GroupDivider.getDungeonsXML(this.currentDungon);
			for each (_local_5 in _local_9)
			{
				_local_4 = String(_local_5.@id);
				if (((_local_3 == null) || (_local_4.search(_local_3) >= 0)))
				{
					_local_8.push(_local_4);
				}
				;
			}
			;
			_local_8.sort(MoreStringUtil.cmp);
			for each (_local_4 in _local_8)
			{
				_local_6 = ObjectLibrary.idToType_[_local_4];
				_local_5 = _local_9[_local_6];
				if ((!(this.cache[_local_6])))
				{
					_local_7 = new ObjectElement(_local_5);
					this.cache[_local_6] = _local_7;
				}
				else
				{
					_local_7 = this.cache[_local_6];
				}
				;
				addElement(_local_7);
			}
			;
			hasBeenLoaded = true;
			scrollBar_.setIndicatorSize(HEIGHT, elementContainer_.height, true);
		}
	
	}
}//package com.company.assembleegameclient.mapeditor

