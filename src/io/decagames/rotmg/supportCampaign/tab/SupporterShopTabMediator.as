﻿// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//io.decagames.rotmg.supportCampaign.tab.SupporterShopTabMediator

package io.decagames.rotmg.supportCampaign.tab
{
    import robotlegs.bender.bundles.mvcs.Mediator;
    import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;
    import kabam.rotmg.game.model.GameModel;
    import kabam.rotmg.core.model.PlayerModel;
    import kabam.rotmg.ui.signals.HUDModelInitialized;
    import kabam.rotmg.ui.model.HUDModel;
    import kabam.rotmg.core.signals.ShowTooltipSignal;
    import kabam.rotmg.core.signals.HideTooltipsSignal;
    import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
    import io.decagames.rotmg.ui.popups.signals.ShowLockFade;
    import io.decagames.rotmg.ui.popups.signals.RemoveLockFade;
    import kabam.rotmg.appengine.api.AppEngineClient;
    import kabam.rotmg.account.core.Account;
    import io.decagames.rotmg.supportCampaign.signals.UpdateCampaignProgress;
    import io.decagames.rotmg.supportCampaign.signals.TierSelectedSignal;
    import com.company.assembleegameclient.ui.tooltip.TextToolTip;
    import kabam.rotmg.tooltips.HoverTooltipDelegate;
    import flash.events.Event;
    import io.decagames.rotmg.shop.NotEnoughResources;
    import com.company.assembleegameclient.util.Currency;
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.popups.modal.error.ErrorModal;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import com.company.assembleegameclient.objects.Player;

    public class SupporterShopTabMediator extends Mediator 
    {

        [Inject]
        public var view:SupporterShopTabView;
        [Inject]
        public var model:SupporterCampaignModel;
        [Inject]
        public var gameModel:GameModel;
        [Inject]
        public var playerModel:PlayerModel;
        [Inject]
        public var initHUDModelSignal:HUDModelInitialized;
        [Inject]
        public var hudModel:HUDModel;
        [Inject]
        public var showTooltipSignal:ShowTooltipSignal;
        [Inject]
        public var hideTooltipSignal:HideTooltipsSignal;
        [Inject]
        public var showPopup:ShowPopupSignal;
        [Inject]
        public var showFade:ShowLockFade;
        [Inject]
        public var removeFade:RemoveLockFade;
        [Inject]
        public var client:AppEngineClient;
        [Inject]
        public var account:Account;
        [Inject]
        public var updatePointsSignal:UpdateCampaignProgress;
        [Inject]
        public var selectedSignal:TierSelectedSignal;
        private var toolTip:TextToolTip = null;
        private var hoverTooltipDelegate:HoverTooltipDelegate;


        override public function initialize():void
        {
            this.updatePointsSignal.add(this.onPointsUpdate);
            this.view.show(this.hudModel.getPlayerName(), this.model.isUnlocked, this.model.isStarted, this.model.unlockPrice, this.model.donatePointsRatio);
            if ((!(this.model.isStarted)))
            {
                this.view.addEventListener(Event.ENTER_FRAME, this.updateStartCountdown);
            };
            if (this.model.isUnlocked)
            {
                this.updateCampaignInformation();
            };
            if (this.view.unlockButton)
            {
                this.view.unlockButton.clickSignal.add(this.unlockClick);
            };
        }

        private function updateCampaignInformation():void
        {
            this.view.updatePoints(this.model.points, this.model.rank);
            this.view.drawProgress(this.model.points, this.model.rankConfig, this.model.rank, this.model.claimed);
            this.updateTooltip();
            this.view.showTier(this.model.nextClaimableTier, this.model.ranks, this.model.rank, this.model.claimed);
            this.view.updateTime((this.model.endDate.time - new Date().time));
        }

        private function updateStartCountdown(_arg_1:Event):void
        {
            var _local_2:String = this.model.getStartTimeString();
            if (_local_2 == "")
            {
                this.view.removeEventListener(Event.ENTER_FRAME, this.updateStartCountdown);
                this.view.unlockButton.disabled = false;
            };
            this.view.updateStartCountdown(_local_2);
        }

        override public function destroy():void
        {
            this.updatePointsSignal.remove(this.onPointsUpdate);
            if (this.view.unlockButton)
            {
                this.view.unlockButton.clickSignal.remove(this.unlockClick);
            };
            this.view.removeEventListener(Event.ENTER_FRAME, this.updateStartCountdown);
        }

        private function onPointsUpdate():void
        {
            this.view.updatePoints(this.model.points, this.model.rank);
            this.view.showTier(this.model.nextClaimableTier, this.model.ranks, this.model.rank, this.model.claimed);
            this.view.drawProgress(this.model.points, this.model.rankConfig, this.model.rank, this.model.claimed);
            this.updateTooltip();
            this.selectedSignal.dispatch(this.model.nextClaimableTier);
            if (this.model.rank >= SupporterCampaignModel.CHARACTER_GLOW_RANK)
            {
                this.gameModel.player.supporterPoints = this.model.points;
                this.gameModel.player.clearTextureCache();
            };
        }

        private function updateTooltip():void
        {
            if (this.view.infoButton)
            {
                if (this.model.rank == 5)
                {
                    this.toolTip = new TextToolTip(0x363636, 15585539, (((this.model.rank == 0) ? "No rank" : SupporterCampaignModel.RANKS_NAMES[(this.model.rank - 1)]) + " Supporter"), (((("Thank you for your Support, " + this.hudModel.getPlayerName()) + "!") + "\n\nWe are bringing your favorite bullet-hell MMO to Unity!") + "\n\nYou have unlocked everything we had to offer, we are glad you are joining us on this journey! You can continue to Donate and further help shape the future of Realm of the Mad God."), 220);
                }
                else
                {
                    this.toolTip = new TextToolTip(0x363636, 0x9B9B9B, (((this.model.rank == 0) ? "No rank" : SupporterCampaignModel.RANKS_NAMES[(this.model.rank - 1)]) + " Supporter"), ("We are bringing your favorite bullet-hell MMO to Unity!" + "\n\nWith each donation you are helping us achieve this goal and additionally unlock some unique gifts."), 220);
                };
                this.hoverTooltipDelegate = new HoverTooltipDelegate();
                this.hoverTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
                this.hoverTooltipDelegate.setHideToolTipsSignal(this.hideTooltipSignal);
                this.hoverTooltipDelegate.setDisplayObject(this.view.infoButton);
                this.hoverTooltipDelegate.tooltip = this.toolTip;
            };
        }

        private function unlockClick(_arg_1:BaseButton):void
        {
            if (this.currentGold < this.model.unlockPrice)
            {
                this.showPopup.dispatch(new NotEnoughResources(300, Currency.GOLD));
                return;
            };
            this.showFade.dispatch();
            var _local_2:Object = this.account.getCredentials();
            this.client.sendRequest("/supportCampaign/unlock", _local_2);
            this.client.complete.addOnce(this.onUnlockComplete);
        }

        private function onUnlockComplete(_arg_1:Boolean, _arg_2:*):void
        {
            var xml:XML;
            var errorMessage:XML;
            var message:String;
            var isOK:Boolean = _arg_1;
            var data:* = _arg_2;
            this.removeFade.dispatch();
            if (isOK)
            {
                try
                {
                    xml = new XML(data);
                    if (xml.hasOwnProperty("Gold"))
                    {
                        this.updateUserGold(int(xml.Gold));
                    };
                    this.view.show(null, true, this.model.isStarted, this.model.unlockPrice, this.model.donatePointsRatio);
                    this.model.parseUpdateData(xml);
                    this.updateCampaignInformation();
                }
                catch(e:Error)
                {
                    showPopup.dispatch(new ErrorModal(300, "Campaign Error", "General campaign error."));
                    return;
                };
            }
            else
            {
                try
                {
                    errorMessage = new XML(data);
                    message = LineBuilder.getLocalizedStringFromKey(errorMessage.toString(), {});
                    this.showPopup.dispatch(new ErrorModal(300, "Campaign Error", ((message == "") ? errorMessage.toString() : message)));
                }
                catch(e:Error)
                {
                    showPopup.dispatch(new ErrorModal(300, "Campaign Error", "General campaign error."));
                };
            };
        }

        private function updateUserGold(_arg_1:int):void
        {
            var _local_2:Player = this.gameModel.player;
            if (_local_2 != null)
            {
                _local_2.setCredits(_arg_1);
            }
            else
            {
                this.playerModel.setCredits(_arg_1);
            };
        }

        private function get currentGold():int
        {
            var _local_1:Player = this.gameModel.player;
            if (_local_1 != null)
            {
                return (_local_1.credits_);
            };
            if (this.playerModel != null)
            {
                return (this.playerModel.getCredits());
            };
            return (0);
        }


    }
}//package io.decagames.rotmg.supportCampaign.tab

