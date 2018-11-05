// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//io.decagames.rotmg.pets.data.ability.AbilitiesUtil

package io.decagames.rotmg.pets.data.ability
{
    import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;
    import io.decagames.rotmg.pets.data.vo.AbilityVO;
    import io.decagames.rotmg.pets.data.vo.IPetVO;

    public class AbilitiesUtil 
    {


        public static function isActiveAbility(_arg_1:PetRarityEnum, _arg_2:int):Boolean
        {
            if (_arg_1.ordinal >= PetRarityEnum.LEGENDARY.ordinal)
            {
                return (true);
            };
            if (_arg_1.ordinal >= PetRarityEnum.UNCOMMON.ordinal)
            {
                return (_arg_2 <= 1);
            };
            return (_arg_2 == 0);
        }

        public static function abilityPowerToMinPoints(_arg_1:int):int
        {
            return (Math.ceil(((AbilityConfig.ABILITY_LEVEL1_POINTS * (1 - Math.pow(AbilityConfig.ABILITY_GEOMETRIC_RATIO, (_arg_1 - 1)))) / (1 - AbilityConfig.ABILITY_GEOMETRIC_RATIO))));
        }

        public static function abilityPointsToLevel(_arg_1:int):int
        {
            var _local_2:Number = (((_arg_1 * (AbilityConfig.ABILITY_GEOMETRIC_RATIO - 1)) / AbilityConfig.ABILITY_LEVEL1_POINTS) + 1);
            return (int((Math.log(_local_2) / Math.log(AbilityConfig.ABILITY_GEOMETRIC_RATIO))) + 1);
        }

        public static function simulateAbilityUpgrade(_arg_1:IPetVO, _arg_2:int):Array
        {
            var _local_3:AbilityVO;
            var _local_4:int;
            var _local_6:int;
            var _local_5:Array = [];
            while (_local_6 < 3)
            {
                _local_3 = _arg_1.abilityList[_local_6].clone();
                if (((AbilitiesUtil.isActiveAbility(_arg_1.rarity, _local_6)) && (_local_3.level < _arg_1.maxAbilityPower)))
                {
                    _local_3.points = (_local_3.points + (_arg_2 * AbilityConfig.ABILITY_INDEX_TO_POINT_MODIFIER[_local_6]));
                    _local_4 = abilityPointsToLevel(_local_3.points);
                    if (_local_4 > _arg_1.maxAbilityPower)
                    {
                        _local_4 = _arg_1.maxAbilityPower;
                        _local_3.points = abilityPowerToMinPoints(_local_4);
                    };
                    _local_3.level = _local_4;
                };
                _local_5.push(_local_3);
                _local_6++;
            };
            return (_local_5);
        }


    }
}//package io.decagames.rotmg.pets.data.ability

