// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.company.assembleegameclient.ui.panels.itemgrids.EquippedGrid

package com.company.assembleegameclient.ui.panels.itemgrids
{
    import __AS3__.vec.Vector;
    import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.EquipmentTile;
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.objects.Player;
    import com.company.assembleegameclient.util.EquipmentUtil;
    import com.company.util.ArrayIterator;
    import kabam.lib.util.VectorAS3Util;
    import com.company.util.IIterator;
    import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.ItemTile;
    import __AS3__.vec.*;

    public class EquippedGrid extends ItemGrid 
    {

        private var tiles:Vector.<EquipmentTile>;
        private var _invTypes:Vector.<int>;

        public function EquippedGrid(_arg_1:GameObject, _arg_2:Vector.<int>, _arg_3:Player, _arg_4:int=0)
        {
            super(_arg_1, _arg_3, _arg_4);
            this._invTypes = _arg_2;
            this.init();
        }

        private function init():void
        {
            var _local_1:EquipmentTile;
            var _local_3:int;
            var _local_2:int = EquipmentUtil.NUM_SLOTS;
            this.tiles = new Vector.<EquipmentTile>(_local_2);
            while (_local_3 < _local_2)
            {
                _local_1 = new EquipmentTile(_local_3, this, interactive);
                addToGrid(_local_1, 1, _local_3);
                _local_1.setType(this._invTypes[_local_3]);
                this.tiles[_local_3] = _local_1;
                _local_3++;
            };
        }

        public function createInteractiveItemTileIterator():IIterator
        {
            return (new ArrayIterator(VectorAS3Util.toArray(this.tiles)));
        }

        override public function setItems(_arg_1:Vector.<int>, _arg_2:int=0):void
        {
            var _local_4:int;
            if ((!(_arg_1)))
            {
                return;
            };
            var _local_3:int = _arg_1.length;
            while (_local_4 < this.tiles.length)
            {
                if ((_local_4 + _arg_2) < _local_3)
                {
                    this.tiles[_local_4].setItem(_arg_1[(_local_4 + _arg_2)]);
                }
                else
                {
                    this.tiles[_local_4].setItem(-1);
                };
                this.tiles[_local_4].updateDim(curPlayer);
                _local_4++;
            };
        }

        public function toggleTierTags(_arg_1:Boolean):void
        {
            var _local_2:ItemTile;
            for each (_local_2 in this.tiles)
            {
                _local_2.toggleTierTag(_arg_1);
            };
        }


    }
}//package com.company.assembleegameclient.ui.panels.itemgrids

