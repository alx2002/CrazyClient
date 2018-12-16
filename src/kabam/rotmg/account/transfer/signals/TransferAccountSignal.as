


//kabam.rotmg.account.transfer.signals.TransferAccountSignal

package kabam.rotmg.account.transfer.signals
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.account.transfer.model.TransferAccountData;

    public class TransferAccountSignal extends Signal 
    {

        public function TransferAccountSignal()
        {
            super(TransferAccountData);
        }

    }
}//package kabam.rotmg.account.transfer.signals

