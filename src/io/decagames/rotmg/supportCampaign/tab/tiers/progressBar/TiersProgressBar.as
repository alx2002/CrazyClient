// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//io.decagames.rotmg.supportCampaign.tab.tiers.progressBar.TiersProgressBar

package io.decagames.rotmg.supportCampaign.tab.tiers.progressBar
{
    import flash.display.Sprite;
    import __AS3__.vec.Vector;
    import io.decagames.rotmg.supportCampaign.data.vo.RankVO;
    import io.decagames.rotmg.supportCampaign.tab.tiers.button.TierButton;
    import io.decagames.rotmg.ui.ProgressBar;
    import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
    import io.decagames.rotmg.ui.texture.TextureParser;
    import io.decagames.rotmg.supportCampaign.tab.tiers.button.status.TierButtonStatus;
    import __AS3__.vec.*;

    public class TiersProgressBar extends Sprite 
    {

        private var ranks:Vector.<RankVO>;
        private var componentWidth:int;
        private var currentRank:int;
        private var claimed:int;
        private var buttonAreReady:Boolean;
        private var buttons:Vector.<TierButton>;
        private var progressBars:Vector.<ProgressBar>;
        private var points:int;
        private var supportIcon:SliceScalingBitmap;

        public function TiersProgressBar(_arg_1:Vector.<RankVO>, _arg_2:int)
        {
            this.ranks = _arg_1;
            this.componentWidth = _arg_2;
            this.buttons = new Vector.<TierButton>();
            this.progressBars = new Vector.<ProgressBar>();
            this.supportIcon = TextureParser.instance.getSliceScalingBitmap("UI", "campaign_Points");
        }

        public function show(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            this.currentRank = _arg_2;
            this.claimed = _arg_3;
            this.points = _arg_1;
            if ((!(this.buttonAreReady)))
            {
                this.renderButtons();
                this.renderProgressBar();
            };
            this.updateButtons();
            this.updateProgressBar();
        }

        private function getStatusByTier(_arg_1:int):int
        {
            if (this.claimed >= _arg_1)
            {
                return (TierButtonStatus.CLAIMED);
            };
            if (this.currentRank >= _arg_1)
            {
                return (TierButtonStatus.UNLOCKED);
            };
            return (TierButtonStatus.LOCKED);
        }

        private function updateButtons():void
        {
            var _local_1:TierButton;
            var _local_2:Boolean;
            for each (_local_1 in this.buttons)
            {
                _local_1.updateStatus(this.getStatusByTier(_local_1.tier));
                if (((!(_local_2)) && (this.getStatusByTier(_local_1.tier) == TierButtonStatus.UNLOCKED)))
                {
                    _local_2 = true;
                    _local_1.selected = true;
                }
                else
                {
                    _local_1.selected = false;
                };
            };
            if ((!(_local_2)))
            {
                if (this.currentRank != 0)
                {
                    for each (_local_1 in this.buttons)
                    {
                        if (this.currentRank == _local_1.tier)
                        {
                            _local_2 = true;
                            _local_1.selected = true;
                        };
                    };
                };
            };
            if ((!(_local_2)))
            {
                this.buttons[0].selected = true;
            };
        }

        private function updateProgressBar():void
        {
            var _local_1:ProgressBar;
            var _local_3:int;
            var _local_2:int = this.points;
            for each (_local_1 in this.progressBars)
            {
                if (this.claimed > _local_3)
                {
                    _local_1.maxColor = 0x4BA800;
                };
                if (_local_1.value != _local_2)
                {
                    if (_local_2 > (_local_1.maxValue - _local_1.minValue))
                    {
                        _local_1.value = (_local_1.maxValue - _local_1.minValue);
                    }
                    else
                    {
                        _local_1.value = _local_2;
                    };
                };
                _local_2 = this.points;
                _local_2 = (_local_2 - _local_1.maxValue);
                if (_local_2 <= 0) break;
                _local_3++;
            };
        }

        private function renderProgressBar():void
        {
            var _local_1:TierButton;
            var _local_2:TierButton;
            var _local_3:int;
            var _local_4:ProgressBar;
            var _local_5:int;
            _local_1 = null;
            var _local_6:Vector.<TierButton> = this.buttons.concat();
            for each (_local_2 in _local_6)
            {
                _local_3 = ((_local_1 == null) ? 0 : (_local_1.x + _local_1.width));
                _local_4 = new ProgressBar(((_local_2.x - _local_3) + 4), 4, "", "", ((_local_5 == 0) ? 0 : this.ranks[(_local_5 - 1)].points), this.ranks[_local_5].points, 0, 0x545454, 15585539);
                _local_4.x = (_local_3 - 2);
                _local_4.y = 7;
                _local_4.shouldAnimate = false;
                this.progressBars.push(_local_4);
                addChild(_local_4);
                if (_local_1 != null)
                {
                    addChild(_local_1);
                };
                addChild(_local_2);
                _local_1 = _local_2;
                _local_5++;
            };
            addChild(this.supportIcon);
            this.supportIcon.x = -3;
            this.supportIcon.y = 5;
        }

        private function renderButtons():void
        {
            var _local_1:RankVO;
            var _local_2:TierButton;
            var _local_3:int = 1;
            for each (_local_1 in this.ranks)
            {
                _local_2 = this.getButtonByTier(_local_3);
                this.buttons.push(addChild(_local_2));
                _local_3++;
            };
            this.buttonAreReady = true;
        }

        private function getButtonByTier(_arg_1:int):TierButton
        {
            var _local_2:TierButton = new TierButton(_arg_1, this.getStatusByTier(_arg_1));
            if (_arg_1 > 0)
            {
                _local_2.x = this.getPositionByTier(_arg_1, _local_2);
            };
            return (_local_2);
        }

        private function getPositionByTier(_arg_1:int, _arg_2:TierButton):int
        {
            var _local_3:int = this.ranks[(this.ranks.length - 1)].points;
            var _local_4:int = (this.componentWidth - (_arg_2.width * 1.5));
            return (Math.round(((_arg_2.width / 2) + ((_local_4 * this.ranks[(_arg_1 - 1)].points) / _local_3))));
        }


    }
}//package io.decagames.rotmg.supportCampaign.tab.tiers.progressBar

