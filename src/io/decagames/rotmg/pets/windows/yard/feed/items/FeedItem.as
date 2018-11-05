﻿// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//io.decagames.rotmg.pets.windows.yard.feed.items.FeedItem

package io.decagames.rotmg.pets.windows.yard.feed.items
{
    import io.decagames.rotmg.ui.gird.UIGridElement;
    import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InventoryTile;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.text.view.BitmapTextFactory;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

    public class FeedItem extends UIGridElement 
    {

        private var _item:InventoryTile;
        private var imageBitmap:Bitmap;
        private var _feedPower:int;
        private var _selected:Boolean;

        public function FeedItem(_arg_1:InventoryTile)
        {
            this._item = _arg_1;
            this.renderBackground(0x454545, 0.25);
            this.renderItem();
        }

        private function renderBackground(_arg_1:uint, _arg_2:Number):void
        {
            graphics.clear();
            graphics.beginFill(_arg_1, _arg_2);
            graphics.drawRect(0, 0, 40, 40);
        }

        private function renderItem():void
        {
            var _local_1:BitmapData;
            var _local_2:Matrix;
            this.imageBitmap = new Bitmap();
            var _local_3:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this._item.getItemId(), 40, true);
            _local_3 = _local_3.clone();
            var _local_4:XML = ObjectLibrary.xmlLibrary_[this._item.getItemId()];
            this._feedPower = _local_4.feedPower;
            var _local_5:BitmapTextFactory = StaticInjectorContext.getInjector().getInstance(BitmapTextFactory);
            if ((((_local_4) && (_local_4.hasOwnProperty("Quantity"))) && (_local_5)))
            {
                _local_1 = _local_5.make(new StaticStringBuilder(String(_local_4.Quantity)), 12, 0xFFFFFF, false, new Matrix(), true);
                _local_2 = new Matrix();
                _local_2.translate(8, 7);
                _local_3.draw(_local_1, _local_2);
            };
            this.imageBitmap.bitmapData = _local_3;
            addChild(this.imageBitmap);
        }

        override public function dispose():void
        {
            super.dispose();
            this.imageBitmap.bitmapData.dispose();
        }

        public function get itemId():int
        {
            return (this._item.getItemId());
        }

        public function get feedPower():int
        {
            return (this._feedPower);
        }

        public function get selected():Boolean
        {
            return (this._selected);
        }

        public function set selected(_arg_1:Boolean):void
        {
            this._selected = _arg_1;
            if (_arg_1)
            {
                this.renderBackground(15306295, 1);
            }
            else
            {
                this.renderBackground(0x454545, 0.25);
            };
        }

        public function get item():InventoryTile
        {
            return (this._item);
        }


    }
}//package io.decagames.rotmg.pets.windows.yard.feed.items

