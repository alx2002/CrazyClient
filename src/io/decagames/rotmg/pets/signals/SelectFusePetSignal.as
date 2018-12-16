


//io.decagames.rotmg.pets.signals.SelectFusePetSignal

package io.decagames.rotmg.pets.signals
{
    import org.osflash.signals.Signal;
    import io.decagames.rotmg.pets.data.vo.PetVO;

    public class SelectFusePetSignal extends Signal 
    {

        public function SelectFusePetSignal()
        {
            super(PetVO);
        }

    }
}//package io.decagames.rotmg.pets.signals

