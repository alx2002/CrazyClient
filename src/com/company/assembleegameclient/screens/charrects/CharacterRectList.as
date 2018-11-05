﻿// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.company.assembleegameclient.screens.charrects.CharacterRectList

package com.company.assembleegameclient.screens.charrects
{
    import flash.display.Sprite;
    import kabam.rotmg.classes.model.ClassesModel;
    import kabam.rotmg.core.model.PlayerModel;
    import kabam.rotmg.assets.services.CharacterFactory;
    import org.osflash.signals.Signal;
    import com.company.assembleegameclient.appengine.SavedCharacter;
    import kabam.rotmg.classes.model.CharacterClass;
    import com.company.assembleegameclient.appengine.CharacterStats;
    import kabam.rotmg.core.StaticInjectorContext;
    import org.swiftsuspenders.Injector;
    import __AS3__.vec.Vector;
    import com.company.assembleegameclient.parameters.Parameters;
    import flash.events.MouseEvent;
    import kabam.rotmg.classes.model.CharacterSkin;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.events.Event;

    public class CharacterRectList extends Sprite 
    {

        private var classes:ClassesModel;
        private var model:PlayerModel;
        private var assetFactory:CharacterFactory;
        public var newCharacter:Signal;
        public var buyCharacterSlot:Signal;

        public function CharacterRectList()
        {
            var _local_1:SavedCharacter;
            var _local_2:BuyCharacterRect;
            var _local_3:CharacterClass;
            var _local_4:CharacterStats;
            var _local_5:CurrentCharacterRect;
            var _local_6:int;
            var _local_7:CreateNewCharacterRect;
            super();
            var _local_8:Injector = StaticInjectorContext.getInjector();
            this.classes = _local_8.getInstance(ClassesModel);
            this.model = _local_8.getInstance(PlayerModel);
            this.assetFactory = _local_8.getInstance(CharacterFactory);
            this.newCharacter = new Signal();
            this.buyCharacterSlot = new Signal();
            var _local_9:String = this.model.getName();
            var _local_10:int = 4;
            var _local_11:Vector.<SavedCharacter> = this.model.getSavedCharacters();
            for each (_local_1 in _local_11)
            {
                _local_3 = this.classes.getCharacterClass(_local_1.objectType());
                _local_4 = this.model.getCharStats()[_local_1.objectType()];
                _local_5 = new CurrentCharacterRect(_local_9, _local_3, _local_1, _local_4);
                if (Parameters.skinTypes16.indexOf(_local_1.skinType()) != -1)
                {
                    _local_5.setIcon(this.getIcon(_local_1, 50));
                }
                else
                {
                    _local_5.setIcon(this.getIcon(_local_1, 100));
                };
                _local_5.y = _local_10;
                addChild(_local_5);
                _local_10 = (_local_10 + (CharacterRect.HEIGHT + 4));
            };
            if (this.model.hasAvailableCharSlot())
            {
                _local_6 = 0;
                while (_local_6 < this.model.getAvailableCharSlots())
                {
                    _local_7 = new CreateNewCharacterRect(this.model);
                    _local_7.addEventListener(MouseEvent.MOUSE_DOWN, this.onNewChar);
                    _local_7.y = _local_10;
                    addChild(_local_7);
                    _local_10 = (_local_10 + (CharacterRect.HEIGHT + 4));
                    _local_6++;
                };
            };
            _local_2 = new BuyCharacterRect(this.model);
            _local_2.addEventListener(MouseEvent.MOUSE_DOWN, this.onBuyCharSlot);
            _local_2.y = _local_10;
            addChild(_local_2);
        }

        private function getIcon(_arg_1:SavedCharacter, _arg_2:int=100):DisplayObject
        {
            var _local_3:CharacterClass = this.classes.getCharacterClass(_arg_1.objectType());
            var _local_4:CharacterSkin = ((_local_3.skins.getSkin(_arg_1.skinType())) || (_local_3.skins.getDefaultSkin()));
            var _local_5:BitmapData = this.assetFactory.makeIcon(_local_4.template, _arg_2, _arg_1.tex1(), _arg_1.tex2());
            return (new Bitmap(_local_5));
        }

        private function onNewChar(_arg_1:Event):void
        {
            this.newCharacter.dispatch();
        }

        private function onBuyCharSlot(_arg_1:Event):void
        {
            this.buyCharacterSlot.dispatch(this.model.getNextCharSlotPrice());
        }


    }
}//package com.company.assembleegameclient.screens.charrects

