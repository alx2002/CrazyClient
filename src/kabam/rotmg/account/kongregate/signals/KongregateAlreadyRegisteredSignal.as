


//kabam.rotmg.account.kongregate.signals.KongregateAlreadyRegisteredSignal

package kabam.rotmg.account.kongregate.signals
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.account.web.model.AccountData;

    public class KongregateAlreadyRegisteredSignal extends Signal 
    {

        public function KongregateAlreadyRegisteredSignal()
        {
            super(AccountData);
        }

    }
}//package kabam.rotmg.account.kongregate.signals

