﻿// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//kabam.rotmg.mysterybox.services.GetMysteryBoxesTask

package kabam.rotmg.mysterybox.services
{
    import kabam.lib.tasks.BaseTask;
    import kabam.rotmg.appengine.api.AppEngineClient;
    import kabam.rotmg.fortune.services.FortuneModel;
    import kabam.rotmg.account.core.Account;
    import robotlegs.bender.framework.api.ILogger;
    import kabam.rotmg.language.model.LanguageModel;
    import kabam.rotmg.dialogs.control.OpenDialogSignal;
    import kabam.rotmg.fortune.model.FortuneInfo;
    import com.company.assembleegameclient.util.TimeUtil;
    import kabam.rotmg.mysterybox.model.MysteryBoxInfo;

    public class GetMysteryBoxesTask extends BaseTask 
    {

        private static var version:String = "0";

        [Inject]
        public var client:AppEngineClient;
        [Inject]
        public var mysteryBoxModel:MysteryBoxModel;
        [Inject]
        public var fortuneModel:FortuneModel;
        [Inject]
        public var account:Account;
        [Inject]
        public var logger:ILogger;
        [Inject]
        public var languageModel:LanguageModel;
        [Inject]
        public var openDialogSignal:OpenDialogSignal;


        override protected function startTask():void
        {
            var _local_1:Object = this.account.getCredentials();
            _local_1.language = this.languageModel.getLanguage();
            _local_1.version = version;
            this.client.sendRequest("/mysterybox/getBoxes", _local_1);
            this.client.complete.addOnce(this.onComplete);
        }

        private function onComplete(_arg_1:Boolean, _arg_2:*):void
        {
            if (_arg_1)
            {
                this.handleOkay(_arg_2);
            }
            else
            {
                this.logger.warn("GetMysteryBox.onComplete: Request failed.");
                completeTask(true);
            };
            reset();
        }

        private function handleOkay(_arg_1:*):void
        {
            version = XML(_arg_1).attribute("version").toString();
            var _local_2:XMLList = XML(_arg_1).child("MysteryBox");
            var _local_3:XMLList = XML(_arg_1).child("SoldCounter");
            if (_local_3.length() > 0)
            {
                this.updateSoldCounters(_local_3);
            };
            if (_local_2.length() > 0)
            {
                this.parse(_local_2);
            }
            else
            {
                if (this.mysteryBoxModel.isInitialized())
                {
                    this.mysteryBoxModel.updateSignal.dispatch();
                };
            };
            var _local_4:XMLList = XML(_arg_1).child("FortuneGame");
            if (_local_4.length() > 0)
            {
                this.parseFortune(_local_4);
            };
            completeTask(true);
        }

        private function hasNoBoxes(_arg_1:*):Boolean
        {
            var _local_2:XMLList = XML(_arg_1).children();
            return (_local_2.length() == 0);
        }

        private function parseFortune(_arg_1:XMLList):void
        {
            var _local_2:FortuneInfo = new FortuneInfo();
            _local_2.id = _arg_1.attribute("id").toString();
            _local_2.title = _arg_1.attribute("title").toString();
            _local_2.weight = _arg_1.attribute("weight").toString();
            _local_2.description = _arg_1.Description.toString();
            _local_2.contents = _arg_1.Contents.toString();
            _local_2.priceFirstInGold = _arg_1.Price.attribute("firstInGold").toString();
            _local_2.priceFirstInToken = _arg_1.Price.attribute("firstInToken").toString();
            _local_2.priceSecondInGold = _arg_1.Price.attribute("secondInGold").toString();
            _local_2.iconImageUrl = _arg_1.Icon.toString();
            _local_2.infoImageUrl = _arg_1.Image.toString();
            _local_2.startTime = TimeUtil.parseUTCDate(_arg_1.StartTime.toString());
            _local_2.endTime = TimeUtil.parseUTCDate(_arg_1.EndTime.toString());
            _local_2.parseContents();
            this.fortuneModel.setFortune(_local_2);
        }

        private function updateSoldCounters(_arg_1:XMLList):void
        {
            var _local_2:XML;
            var _local_3:MysteryBoxInfo;
            for each (_local_2 in _arg_1)
            {
                _local_3 = this.mysteryBoxModel.getBoxById(_local_2.attribute("id").toString());
                _local_3.unitsLeft = _local_2.attribute("left");
            };
        }

        private function parse(_arg_1:XMLList):void
        {
            var _local_2:XML;
            var _local_3:MysteryBoxInfo;
            var _local_5:Boolean;
            var _local_4:Array = [];
            for each (_local_2 in _arg_1)
            {
                _local_3 = new MysteryBoxInfo();
                _local_3.id = _local_2.attribute("id").toString();
                _local_3.title = _local_2.attribute("title").toString();
                _local_3.weight = _local_2.attribute("weight").toString();
                _local_3.description = _local_2.Description.toString();
                _local_3.contents = _local_2.Contents.toString();
                _local_3.priceAmount = int(_local_2.Price.attribute("amount").toString());
                _local_3.priceCurrency = _local_2.Price.attribute("currency").toString();
                if (_local_2.hasOwnProperty("Sale"))
                {
                    _local_3.saleAmount = _local_2.Sale.attribute("price").toString();
                    _local_3.saleCurrency = _local_2.Sale.attribute("currency").toString();
                    _local_3.saleEnd = TimeUtil.parseUTCDate(_local_2.Sale.End.toString());
                };
                if (_local_2.hasOwnProperty("Left"))
                {
                    _local_3.unitsLeft = _local_2.Left;
                };
                if (_local_2.hasOwnProperty("Total"))
                {
                    _local_3.totalUnits = _local_2.Total;
                };
                if (_local_2.hasOwnProperty("Slot"))
                {
                    _local_3.slot = _local_2.Slot;
                };
                if (_local_2.hasOwnProperty("Jackpots"))
                {
                    _local_3.jackpots = _local_2.Jackpots;
                };
                if (_local_2.hasOwnProperty("DisplayedItems"))
                {
                    _local_3.displayedItems = _local_2.DisplayedItems;
                };
                if (_local_2.hasOwnProperty("Rolls"))
                {
                    _local_3.rolls = int(_local_2.Rolls);
                };
                if (_local_2.hasOwnProperty("Tags"))
                {
                    _local_3.tags = _local_2.Tags;
                };
                _local_3.iconImageUrl = _local_2.Icon.toString();
                _local_3.infoImageUrl = _local_2.Image.toString();
                _local_3.startTime = TimeUtil.parseUTCDate(_local_2.StartTime.toString());
                if (_local_2.EndTime.toString())
                {
                    _local_3.endTime = TimeUtil.parseUTCDate(_local_2.EndTime.toString());
                };
                _local_3.parseContents();
                if (((!(_local_5)) && ((_local_3.isNew()) || (_local_3.isOnSale()))))
                {
                    _local_5 = true;
                };
                _local_4.push(_local_3);
            };
            this.mysteryBoxModel.setMysetryBoxes(_local_4);
            this.mysteryBoxModel.isNew = _local_5;
        }


    }
}//package kabam.rotmg.mysterybox.services

