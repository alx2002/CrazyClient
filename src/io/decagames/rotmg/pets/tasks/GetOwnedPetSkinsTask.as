﻿// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//io.decagames.rotmg.pets.tasks.GetOwnedPetSkinsTask

package io.decagames.rotmg.pets.tasks
{
    import kabam.lib.tasks.BaseTask;
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.appengine.api.AppEngineClient;
    import robotlegs.bender.framework.api.ILogger;
    import io.decagames.rotmg.pets.data.PetsModel;
    import com.company.util.MoreObjectUtil;

    public class GetOwnedPetSkinsTask extends BaseTask 
    {

        [Inject]
        public var account:Account;
        [Inject]
        public var client:AppEngineClient;
        [Inject]
        public var logger:ILogger;
        [Inject]
        public var petModel:PetsModel;


        override protected function startTask():void
        {
            this.logger.info("GetOwnedPetSkinsTask start");
            if ((!(this.account.isRegistered())))
            {
                this.logger.info("Guest account - skip skins check");
                completeTask(true, "");
            }
            else
            {
                this.client.complete.addOnce(this.onComplete);
                this.client.sendRequest("/account/getOwnedPetSkins", this.makeDataPacket());
            };
        }

        private function makeDataPacket():Object
        {
            var _local_1:Object = {};
            MoreObjectUtil.addToObject(_local_1, this.account.getCredentials());
            return (_local_1);
        }

        private function onComplete(_arg_1:Boolean, _arg_2:*):void
        {
            var isOK:Boolean = _arg_1;
            var data:* = _arg_2;
            isOK = ((isOK) || (data == "<Success/>"));
            if (isOK)
            {
                try
                {
                    this.petModel.parseOwnedSkins(XML(data));
                }
                catch(e:Error)
                {
                    logger.error(((e.message + " ") + e.getStackTrace()));
                };
                this.petModel.parsePetsData();
            };
            completeTask(isOK, data);
        }


    }
}//package io.decagames.rotmg.pets.tasks

