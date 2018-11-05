// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//io.decagames.rotmg.supportCampaign.tooltips.PointsTooltip

package io.decagames.rotmg.supportCampaign.tooltips
{
    import com.company.assembleegameclient.ui.tooltip.ToolTip;
    import io.decagames.rotmg.ui.labels.UILabel;
    import io.decagames.rotmg.shop.ShopBuyButton;
    import flash.display.Bitmap;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import flash.text.TextFormatAlign;
    import kabam.rotmg.assets.services.IconFactory;
    import flash.display.BitmapData;

    public class PointsTooltip extends ToolTip 
    {

        private var pointsInfo:UILabel;
        private var _shopButton:ShopBuyButton;
        private var pointsBitmap:Bitmap;

        public function PointsTooltip(_arg_1:ShopBuyButton, _arg_2:uint, _arg_3:uint, _arg_4:int, _arg_5:Boolean=true)
        {
            super(_arg_2, 1, _arg_3, 1, _arg_5);
            this._shopButton = _arg_1;
            this.pointsInfo = new UILabel();
            DefaultLabelFormat.createLabelFormat(this.pointsInfo, 14, 0xEAEAEA, TextFormatAlign.RIGHT, false);
            addChild(this.pointsInfo);
            var _local_6:BitmapData = IconFactory.makeSupporterPointsIcon(40, false);
            this.pointsBitmap = new Bitmap(_local_6);
            addChild(this.pointsBitmap);
        }

        public function updatePoints(_arg_1:int):void
        {
            this.pointsInfo.text = ("You will get " + _arg_1);
            this.pointsBitmap.y = (this.pointsInfo.y - 2);
            this.pointsBitmap.x = (this.pointsInfo.x + this.pointsInfo.width);
        }

        public function get shopButton():ShopBuyButton
        {
            return (this._shopButton);
        }


    }
}//package io.decagames.rotmg.supportCampaign.tooltips

