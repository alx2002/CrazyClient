// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//io.decagames.rotmg.supportCampaign.tab.donate.DonatePanelMediator

package io.decagames.rotmg.supportCampaign.tab.donate
{
    import robotlegs.bender.bundles.mvcs.Mediator;
    import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
    import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;
    import flash.events.Event;
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.supportCampaign.tab.donate.popup.DonateConfirmationPopup;

    public class DonatePanelMediator extends Mediator 
    {

        [Inject]
        public var view:DonatePanel;
        [Inject]
        public var showPopupSignal:ShowPopupSignal;
        [Inject]
        public var model:SupporterCampaignModel;


        override public function initialize():void
        {
            this.view.upArrow.clickSignal.add(this.upClickHandler);
            this.view.downArrow.clickSignal.add(this.downClickHandler);
            this.view.donateButton.clickSignal.add(this.donateClickHandler);
            this.view.amountTextfield.addEventListener(Event.CHANGE, this.onAmountChange);
        }

        override public function destroy():void
        {
            this.view.upArrow.clickSignal.remove(this.upClickHandler);
            this.view.downArrow.clickSignal.remove(this.downClickHandler);
            this.view.donateButton.clickSignal.remove(this.donateClickHandler);
            this.view.amountTextfield.removeEventListener(Event.CHANGE, this.onAmountChange);
        }

        private function onAmountChange(_arg_1:Event):void
        {
            this.view.updateDonateAmount();
        }

        private function upClickHandler(_arg_1:BaseButton):void
        {
            this.view.addDonateAmount(SupporterCampaignModel.DEFAULT_DONATE_SPINNER_STEP);
        }

        private function downClickHandler(_arg_1:BaseButton):void
        {
            this.view.addDonateAmount(-(SupporterCampaignModel.DEFAULT_DONATE_SPINNER_STEP));
        }

        private function donateClickHandler(_arg_1:BaseButton):void
        {
            this.showPopupSignal.dispatch(new DonateConfirmationPopup(this.view.gold, (this.view.gold * this.model.donatePointsRatio)));
        }


    }
}//package io.decagames.rotmg.supportCampaign.tab.donate

