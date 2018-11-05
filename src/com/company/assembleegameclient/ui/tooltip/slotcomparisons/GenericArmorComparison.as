// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.company.assembleegameclient.ui.tooltip.slotcomparisons.GenericArmorComparison

package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
    import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;

    public class GenericArmorComparison extends SlotComparison 
    {

        private static const DEFENSE_STAT:String = "21";

        private var defTags:XMLList;
        private var otherDefTags:XMLList;

        public function GenericArmorComparison()
        {
            comparisonStringBuilder = new AppendingLineBuilder();
        }

        override protected function compareSlots(_arg_1:XML, _arg_2:XML):void
        {
            var defense:int;
            var otherDefense:int;
            var itemXML:XML = _arg_1;
            var curItemXML:XML = _arg_2;
            this.defTags = itemXML.ActivateOnEquip.(@stat == DEFENSE_STAT);
            this.otherDefTags = curItemXML.ActivateOnEquip.(@stat == DEFENSE_STAT);
            if (((this.defTags.length() == 1) && (this.otherDefTags.length() == 1)))
            {
                defense = int(this.defTags.@amount);
                otherDefense = int(this.otherDefTags.@amount);
            };
        }

        private function compareDefense(_arg_1:int, _arg_2:int):String
        {
            var _local_3:uint = getTextColor((_arg_1 - _arg_2));
            return (wrapInColoredFont((("+" + _arg_1) + " Defense"), _local_3));
        }


    }
}//package com.company.assembleegameclient.ui.tooltip.slotcomparisons

