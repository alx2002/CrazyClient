// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.company.assembleegameclient.mapeditor.AllObjectChooser

package com.company.assembleegameclient.mapeditor
{
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import com.company.util.MoreStringUtil;
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import __AS3__.vec.*;

    public class AllObjectChooser extends Chooser 
    {

        public static const GROUP_NAME_MAP_OBJECTS:String = "All Map Objects";
        public static const GROUP_NAME_GAME_OBJECTS:String = "All Game Objects";

        private var cache:Dictionary;
        private var lastSearch:String = "";

        public function AllObjectChooser()
        {
            super(Layer.OBJECT);
            this.cache = new Dictionary();
        }

        public function getLastSearch():String
        {
            return (this.lastSearch);
        }

        public function reloadObjects(_arg_1:String="", _arg_2:String="All Map Objects"):void
        {
            var _local_3:RegExp;
            var _local_4:String;
            var _local_5:int;
            var _local_6:XML;
            var _local_7:int;
            var _local_8:ObjectElement;
            removeElements();
            this.lastSearch = _arg_1;
            var _local_9:Vector.<String> = new Vector.<String>();
            if (_arg_1 != "")
            {
                _local_3 = new RegExp(_arg_1, "gix");
            };
            var _local_10:Dictionary = GroupDivider.GROUPS[_arg_2];
            for each (_local_6 in _local_10)
            {
                _local_4 = String(_local_6.@id);
                _local_5 = int(_local_6.@type);
                if ((((_local_3 == null) || (_local_4.search(_local_3) >= 0)) || (_local_5 == int(_arg_1))))
                {
                    _local_9.push(_local_4);
                };
            };
            _local_9.sort(MoreStringUtil.cmp);
            for each (_local_4 in _local_9)
            {
                _local_7 = ObjectLibrary.idToType_[_local_4];
                _local_6 = ObjectLibrary.xmlLibrary_[_local_7];
                if ((!(this.cache[_local_7])))
                {
                    _local_8 = new ObjectElement(_local_6);
                    if (_arg_2 == GROUP_NAME_GAME_OBJECTS)
                    {
                        _local_8.downloadOnly = true;
                    };
                    this.cache[_local_7] = _local_8;
                }
                else
                {
                    _local_8 = this.cache[_local_7];
                };
                addElement(_local_8);
            };
            hasBeenLoaded = true;
            scrollBar_.setIndicatorSize(HEIGHT, elementContainer_.height, true);
        }


    }
}//package com.company.assembleegameclient.mapeditor

