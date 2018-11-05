﻿// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//kabam.rotmg.ui.view.NotEnoughGoldDialog

package kabam.rotmg.ui.view
{
    import com.company.assembleegameclient.ui.dialogs.Dialog;
    import org.osflash.signals.Signal;
    import kabam.rotmg.text.model.TextKey;
    import org.osflash.signals.natives.NativeMappedSignal;

    public class NotEnoughGoldDialog extends Dialog 
    {

        public var cancel:Signal;
        public var buyGold:Signal;

        public function NotEnoughGoldDialog()
        {
            super(TextKey.NOT_ENOUGH_GOLD, TextKey.GOLD_NOTENOUGHFORITEM, TextKey.FRAME_CANCEL, TextKey.BUY_GOLD);
            this.cancel = new NativeMappedSignal(this, LEFT_BUTTON);
            this.buyGold = new NativeMappedSignal(this, RIGHT_BUTTON);
        }

    }
}//package kabam.rotmg.ui.view

