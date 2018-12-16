


//io.decagames.rotmg.pets.signals.HatchPetSignal

package io.decagames.rotmg.pets.signals
{
    import org.osflash.signals.Signal;
    import io.decagames.rotmg.pets.data.vo.HatchPetVO;

    public class HatchPetSignal extends Signal 
    {

        public function HatchPetSignal()
        {
            super(HatchPetVO);
        }

    }
}//package io.decagames.rotmg.pets.signals

