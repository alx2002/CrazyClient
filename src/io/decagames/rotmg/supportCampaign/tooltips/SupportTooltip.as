// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//io.decagames.rotmg.supportCampaign.tooltips.SupportTooltip

package io.decagames.rotmg.supportCampaign.tooltips
{
    import com.company.assembleegameclient.ui.tooltip.ToolTip;
    import io.decagames.rotmg.ui.labels.UILabel;
    import flash.display.Sprite;
    import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.texture.TextureParser;

    public class SupportTooltip extends ToolTip 
    {

        private var title:UILabel;
        private var topDesc:UILabel;
        private var topContainer:Sprite;
        private var topGift:SliceScalingBitmap;
        private var optionText:UILabel;
        private var optionContainer:Sprite;
        private var campaignProgress:SliceScalingBitmap;
        private var botDesc:UILabel;

        public function SupportTooltip()
        {
            super(0x363636, 1, 0x9B9B9B, 1);
            this.init();
        }

        private function init():void
        {
            this.createTitle();
            this.createOptions();
            this.createGlow();
            this.createTopGift();
            this.createBottom();
        }

        private function createTitle():void
        {
            this.title = new UILabel();
            DefaultLabelFormat.petNameLabel(this.title, 0xFFFFFF);
            addChild(this.title);
            this.title.text = "Support the Campaign!";
            this.title.y = 5;
            this.title.x = 0;
            this.topDesc = new UILabel();
            DefaultLabelFormat.infoTooltipText(this.topDesc, 0xAAAAAA);
            addChild(this.topDesc);
            this.topDesc.text = "Your options to progress and support us are:";
            this.topDesc.width = 300;
            this.topDesc.wordWrap = true;
            this.topDesc.y = (this.title.y + this.title.height);
            this.topDesc.x = 0;
        }

        private function createOptions():void
        {
            this.optionContainer = new Sprite();
            addChild(this.optionContainer);
            this.campaignProgress = TextureParser.instance.getSliceScalingBitmap("UI", "campaignProgress", 248);
            this.optionContainer.addChild(this.campaignProgress);
            this.campaignProgress.x = (150 - (this.campaignProgress.width / 2));
            this.campaignProgress.y = 0;
            this.optionContainer.y = ((this.topDesc.y + this.topDesc.height) + 10);
            this.optionContainer.x = 0;
        }

        private function createGlow():void
        {
            this.optionText = new UILabel();
            DefaultLabelFormat.infoTooltipText(this.optionText, 0xAAAAAA);
            addChild(this.optionText);
            this.optionText.text = "Every Player who reaches 100.000 points will unlock an exclusive character glow!";
            this.optionText.width = 300;
            this.optionText.wordWrap = true;
            this.optionText.y = ((this.optionContainer.y + this.optionContainer.height) + 5);
            this.optionText.x = 0;
        }

        private function createTopGift():void
        {
            this.topContainer = new Sprite();
            addChild(this.topContainer);
            this.topGift = TextureParser.instance.getSliceScalingBitmap("UI", "100kgift", 157);
            this.topContainer.addChild(this.topGift);
            this.topGift.width = 100;
            this.topGift.height = 100;
            this.topGift.x = 0;
            this.topGift.y = 0;
            this.topContainer.y = ((this.optionText.y + this.optionText.height) - 10);
            this.topContainer.x = 55;
        }

        private function createBottom():void
        {
            this.botDesc = new UILabel();
            DefaultLabelFormat.infoTooltipText(this.botDesc, 0xAAAAAA);
            addChild(this.botDesc);
            this.botDesc.text = ("We are excited to have you join us on this journey!\n" + "Your Realm Team");
            this.botDesc.width = 300;
            this.botDesc.wordWrap = true;
            this.botDesc.y = ((this.topContainer.y + this.topContainer.height) - 10);
            this.botDesc.x = 0;
        }


    }
}//package io.decagames.rotmg.supportCampaign.tooltips

