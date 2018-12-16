


//kabam.rotmg.core.signals.TrackEventSignal

package kabam.rotmg.core.signals
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.core.service.TrackingData;

    public class TrackEventSignal extends Signal 
    {

        public function TrackEventSignal()
        {
            super(TrackingData);
        }

    }
}//package kabam.rotmg.core.signals

