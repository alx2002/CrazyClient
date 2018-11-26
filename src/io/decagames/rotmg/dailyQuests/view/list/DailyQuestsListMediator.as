// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//io.decagames.rotmg.dailyQuests.view.list.DailyQuestsListMediator

package io.decagames.rotmg.dailyQuests.view.list
{
	import __AS3__.vec.*;
	import __AS3__.vec.Vector;
	import io.decagames.rotmg.dailyQuests.model.DailyQuest;
	import io.decagames.rotmg.dailyQuests.model.DailyQuestsModel;
	import io.decagames.rotmg.dailyQuests.view.info.DailyQuestInfo;
	import kabam.rotmg.constants.GeneralConstants;
	import kabam.rotmg.ui.model.HUDModel;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class DailyQuestsListMediator extends Mediator
	{
		
		[Inject]
		public var view:DailyQuestsList;
		[Inject]
		public var model:DailyQuestsModel;
		[Inject]
		public var hud:HUDModel;
		private var hasEvent:Boolean;
		
		override public function initialize():void
		{
			var _local_1:DailyQuest;
			var _local_2:DailyQuestListElement;
			var _local_3:Vector.<DailyQuest> = this.model.questsList;
			var _local_4:Boolean = true;
			this.view.tabs.buttonsRenderedSignal.addOnce(this.onAddedHandler);
			var _local_5:Vector.<int> = ((this.hud.gameSprite.map.player_) ? this.hud.gameSprite.map.player_.equipment_.slice((GeneralConstants.NUM_EQUIPMENT_SLOTS - 1), (GeneralConstants.NUM_EQUIPMENT_SLOTS + (GeneralConstants.NUM_INVENTORY_SLOTS * 2))) : new Vector.<int>());
			for each (_local_1 in _local_3)
			{
				_local_2 = new DailyQuestListElement(_local_1.id, _local_1.name, _local_1.completed, DailyQuestInfo.hasAllItems(_local_1.requirements, _local_5), _local_1.category);
				if (_local_4)
				{
					_local_2.isSelected = true;
				}
				;
				_local_4 = false;
				if (_local_1.category == 3)
				{
					this.hasEvent = true;
					this.view.addEventToList(_local_2);
				}
				else
				{
					this.view.addQuestToList(_local_2);
				}
				;
			}
			;
		}
		
		private function onAddedHandler():void
		{
			if (this.hasEvent)
			{
				this.view.addIndicator(this.hasEvent);
			}
			;
		}
		
		override public function destroy():void
		{
			this.view.tabs.buttonsRenderedSignal.remove(this.onAddedHandler);
		}
	
	}
}//package io.decagames.rotmg.dailyQuests.view.list

