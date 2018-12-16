


//kabam.rotmg.ui.view.components.ScreenBase

package kabam.rotmg.ui.view.components
{
    import flash.display.Sprite;
    import com.company.assembleegameclient.ui.SoundIcon;

    public class ScreenBase extends Sprite 
    {

        public static var TitleScreenBackground:Class = ScreenBase_TitleScreenBackground;

        public function ScreenBase()
        {
            addChild(new TitleScreenBackground());
            addChild(new DarkLayer());
            addChild(new SoundIcon());
        }

    }
}//package kabam.rotmg.ui.view.components

