// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//kabam.rotmg.ui.view.components.Spinner

package kabam.rotmg.ui.view.components
{
    import flash.display.Sprite;
    import flash.display.DisplayObject;
    import kabam.rotmg.assets.EmbeddedAssets;
    import flash.events.Event;
    import flash.utils.getTimer;

    public class Spinner extends Sprite 
    {

        public const graphic:DisplayObject = new EmbeddedAssets.StarburstSpinner();

        public var degreesPerSecond:Number;
        public var secondsElapsed:Number;
        public var previousSeconds:Number;

        public function Spinner()
        {
            this.secondsElapsed = 0;
            this.defaultConfig();
            this.addGraphic();
            addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            addEventListener(Event.REMOVED_FROM_STAGE, this.onRemoved);
        }

        public function defaultConfig():void
        {
            this.degreesPerSecond = 50;
        }

        public function addGraphic():void
        {
            addChild(this.graphic);
            this.graphic.x = ((-1 * width) / 2);
            this.graphic.y = ((-1 * height) / 2);
        }

        public function onRemoved(_arg_1:Event):void
        {
            removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemoved);
            removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        }

        public function onEnterFrame(_arg_1:Event):void
        {
            this.updateTimeElapsed();
            rotation = ((this.degreesPerSecond * this.secondsElapsed) % 360);
        }

        public function updateTimeElapsed():void
        {
            var _local_1:* = (getTimer() / 1000);
            if (this.previousSeconds)
            {
                this.secondsElapsed = (this.secondsElapsed + (_local_1 - this.previousSeconds));
            };
            this.previousSeconds = _local_1;
        }


    }
}//package kabam.rotmg.ui.view.components

