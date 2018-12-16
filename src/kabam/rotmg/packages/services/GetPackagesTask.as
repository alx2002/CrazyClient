


//kabam.rotmg.packages.services.GetPackagesTask

package kabam.rotmg.packages.services
{
    import kabam.lib.tasks.BaseTask;
    import kabam.rotmg.appengine.api.AppEngineClient;
    import kabam.rotmg.account.core.Account;
    import robotlegs.bender.framework.api.ILogger;
    import kabam.rotmg.language.model.LanguageModel;
    import kabam.rotmg.packages.model.PackageInfo;
    import com.company.assembleegameclient.util.TimeUtil;

    public class GetPackagesTask extends BaseTask 
    {

        private static var version:String = "0";

        [Inject]
        public var client:AppEngineClient;
        [Inject]
        public var packageModel:PackageModel;
        [Inject]
        public var account:Account;
        [Inject]
        public var logger:ILogger;
        [Inject]
        public var languageModel:LanguageModel;


        override protected function startTask():void
        {
            var _local_1:Object = this.account.getCredentials();
            _local_1.language = this.languageModel.getLanguage();
            _local_1.version = version;
            this.client.sendRequest("/package/getPackages", _local_1);
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
                this.logger.warn("GetPackageTask.onComplete: Request failed.");
                completeTask(true);
            };
            reset();
        }

        private function handleOkay(_arg_1:*):void
        {
            version = XML(_arg_1).attribute("version").toString();
            var _local_2:XMLList = XML(_arg_1).child("Package");
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
                if (this.packageModel.getInitialized())
                {
                    this.packageModel.updateSignal.dispatch();
                };
            };
            completeTask(true);
        }

        private function updateSoldCounters(_arg_1:XMLList):void
        {
            var _local_2:XML;
            var _local_3:PackageInfo;
            for each (_local_2 in _arg_1)
            {
                _local_3 = this.packageModel.getPackageById(_local_2.attribute("id").toString());
                _local_3.unitsLeft = _local_2.attribute("left");
            };
        }

        private function hasNoPackage(_arg_1:*):Boolean
        {
            var _local_2:XMLList = XML(_arg_1).children();
            return (_local_2.length() == 0);
        }

        private function parse(_arg_1:XMLList):void
        {
            var _local_2:XML;
            var _local_3:PackageInfo;
            var _local_4:Array = [];
            for each (_local_2 in _arg_1)
            {
                _local_3 = new PackageInfo();
                _local_3.id = _local_2.attribute("id").toString();
                _local_3.title = _local_2.attribute("title").toString();
                _local_3.weight = _local_2.attribute("weight").toString();
                _local_3.description = _local_2.Description.toString();
                _local_3.contents = _local_2.Contents.toString();
                _local_3.priceAmount = int(_local_2.Price.attribute("amount").toString());
                _local_3.priceCurrency = _local_2.Price.attribute("currency").toString();
                if (_local_2.hasOwnProperty("Sale"))
                {
                    _local_3.saleAmount = int(_local_2.Sale.attribute("price").toString());
                    _local_3.saleCurrency = int(_local_2.Sale.attribute("currency").toString());
                    if (_local_2.Sale.End.toString())
                    {
                        _local_3.saleEnd = TimeUtil.parseUTCDate(_local_2.Sale.End.toString());
                    };
                };
                if (_local_2.hasOwnProperty("Left"))
                {
                    _local_3.unitsLeft = _local_2.Left;
                };
                if (_local_2.hasOwnProperty("ShowOnLogin"))
                {
                    _local_3.showOnLogin = (int(_local_2.ShowOnLogin) == 1);
                };
                if (_local_2.hasOwnProperty("Total"))
                {
                    _local_3.totalUnits = _local_2.Total;
                };
                if (_local_2.hasOwnProperty("Slot"))
                {
                    _local_3.slot = _local_2.Slot;
                };
                if (_local_2.hasOwnProperty("Tags"))
                {
                    _local_3.tags = _local_2.Tags;
                };
                _local_3.startTime = TimeUtil.parseUTCDate(_local_2.StartTime.toString());
                if (_local_2.EndTime.toString())
                {
                    _local_3.endTime = TimeUtil.parseUTCDate(_local_2.EndTime.toString());
                };
                _local_3.image = _local_2.Image.toString();
                _local_3.charSlot = int(_local_2.CharSlot.toString());
                _local_3.vaultSlot = int(_local_2.VaultSlot.toString());
                _local_3.gold = int(_local_2.Gold.toString());
                if (_local_2.PopupImage.toString() != "")
                {
                    _local_3.popupImage = _local_2.PopupImage.toString();
                };
                _local_4.push(_local_3);
            };
            this.packageModel.setPackages(_local_4);
        }


    }
}//package kabam.rotmg.packages.services

