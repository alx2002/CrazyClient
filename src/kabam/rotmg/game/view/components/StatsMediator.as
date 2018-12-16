﻿


//kabam.rotmg.game.view.components.StatsMediator

package kabam.rotmg.game.view.components
{
    import robotlegs.bender.bundles.mvcs.Mediator;
    import kabam.rotmg.ui.signals.UpdateHUDSignal;
    import kabam.rotmg.ui.view.StatsDockedSignal;
    import com.company.assembleegameclient.objects.Player;

    public class StatsMediator extends Mediator 
    {

        [Inject]
        public var view:StatsView;
        [Inject]
        public var updateHUD:UpdateHUDSignal;
        [Inject]
        public var statsUndocked:StatsUndockedSignal;
        [Inject]
        public var statsDocked:StatsDockedSignal;


        override public function initialize():void
        {
            this.updateHUD.add(this.onUpdateHUD);
        }

        override public function destroy():void
        {
            this.updateHUD.remove(this.onUpdateHUD);
        }

        private function onUpdateHUD(_arg_1:Player):void
        {
            this.view.draw(_arg_1);
        }


    }
}//package kabam.rotmg.game.view.components

