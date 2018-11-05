// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//io.decagames.rotmg.ui.popups.modal.TextModal

package io.decagames.rotmg.ui.popups.modal
{
    import io.decagames.rotmg.ui.labels.UILabel;
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import __AS3__.vec.Vector;

    public class TextModal extends ModalPopup 
    {

        private var buttonsMargin:int = 30;

        public function TextModal(_arg_1:int, _arg_2:String, _arg_3:String, _arg_4:Vector.<BaseButton>, _arg_5:Boolean=false)
        {
            var _local_6:UILabel;
            var _local_7:BaseButton;
            var _local_8:int;
            var _local_9:int;
            super(_arg_1, 0, _arg_2);
            _local_6 = new UILabel();
            _local_6.multiline = true;
            DefaultLabelFormat.defaultTextModalText(_local_6);
            _local_6.multiline = true;
            _local_6.width = _arg_1;
            if (_arg_5)
            {
                _local_6.htmlText = _arg_3;
            }
            else
            {
                _local_6.text = _arg_3;
            };
            _local_6.wordWrap = true;
            addChild(_local_6);
            for each (_local_7 in _arg_4)
            {
                _local_9 = (_local_9 + _local_7.width);
            };
            _local_9 = (_local_9 + (this.buttonsMargin * (_arg_4.length - 1)));
            _local_8 = int(int(((_arg_1 - _local_9) / 2)));
            for each (_local_7 in _arg_4)
            {
                _local_7.x = _local_8;
                _local_8 = (_local_8 + (this.buttonsMargin + _local_7.width));
                _local_7.y = ((_local_6.y + _local_6.textHeight) + 15);
                addChild(_local_7);
                registerButton(_local_7);
            };
        }

    }
}//package io.decagames.rotmg.ui.popups.modal

