


//com.company.assembleegameclient.objects.Party

package com.company.assembleegameclient.objects
{
	import com.company.assembleegameclient.map.Map;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.ui.options.Options;
	import com.company.util.PointUtil;
	import flash.utils.Dictionary;
	import kabam.rotmg.chat.model.ChatMessage;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.game.signals.AddTextLineSignal;
	import kabam.rotmg.messaging.impl.incoming.AccountList;
	
	public class Party
	{
		
		public static const NUM_MEMBERS:int = 6;
		private static const SORT_ON_FIELDS:Array = ["starred_", "distSqFromThisPlayer_", "objectId_"];
		private static const SORT_ON_PARAMS:Array = [(Array.NUMERIC | Array.DESCENDING), Array.NUMERIC, Array.NUMERIC];
		private static const PARTY_DISTANCE_SQ:int = 2500;
		private static var addTextLine:AddTextLineSignal = StaticInjectorContext.getInjector().getInstance(AddTextLineSignal);
		private static const DOD_PATH_X:Array = [124, 124, 132, 132, 128, 128, 132, 132, 128, 131, 128, 128];
		private static const DOD_PATH_Y:Array = [229, 223, 223, 217, 217, 211, 211, 208, 207, 205, 202, 129];
		private static const TOT_X:Array = [2, 3, -5];
		private static const TOT_Y:Array = [2, 3, -5];
		private static var PATH_IDX:int = 0;
		private static var debugEnd:Boolean = false;
		public static var daichi:GameObject;
		private static var COUNT:Number = 0;
		private static var nextPhase:int = 0;
		
		public var map_:Map;
		public var members_:Array = [];
		private var starred_:Dictionary = new Dictionary(true);
		private var ignored_:Dictionary = new Dictionary(true);
		private var lastUpdate_:int = -2147483648;
		
		public function Party(_arg_1:Map)
		{
			this.map_ = _arg_1;
		}
		
		public static function dodBot(_arg_1:Player):void
		{
			if (_arg_1.map_.name_ == "Tutorial")
			{
				if ((!(debugEnd)))
				{
					moveTo(DOD_PATH_X[PATH_IDX], DOD_PATH_Y[PATH_IDX], _arg_1);
				}
				else
				{
					PATH_IDX = 0;
					COUNT++;
					debugEnd = false;
					addTextLine.dispatch(ChatMessage.make("Counter", (COUNT + " tutorials done on this session.")));
					_arg_1.map_.gs_.gsc_.playerText("/tutorial");
				}
				;
			}
			;
			if (_arg_1.map_.name_ == "Nexus")
			{
				PATH_IDX = 0;
				_arg_1.map_.gs_.gsc_.playerText("/tutorial");
			}
			;
		}
		
		public static function templeBot(_arg_1:Player):void
		{
			if (((!(daichi == null)) && (_arg_1.map_.name_ == "Nexus")))
			{
				if ((!(debugEnd)))
				{
					moveTo((daichi.x_ - TOT_X[PATH_IDX]), (daichi.y_ - TOT_Y[PATH_IDX]), _arg_1);
				}
				else
				{
					PATH_IDX = 0;
					COUNT++;
					debugEnd = false;
					addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, (COUNT + " phase started.")));
				}
				;
			}
			;
		}
		
		public static function moveTo(_arg_1:Number, _arg_2:Number, _arg_3:Player):void
		{
			if (((int(_arg_3.x_) == _arg_1) && (int(_arg_3.y_) == _arg_2)))
			{
				if (Parameters.data_.dodBot)
				{
					if (PATH_IDX == (DOD_PATH_X.length - 1))
					{
						debugEnd = true;
					}
					else
					{
						PATH_IDX++;
					}
					;
				}
				;
				if (Parameters.data_.templeBot)
				{
					if (PATH_IDX == (TOT_X.length - 1))
					{
						debugEnd = true;
					}
					else
					{
						PATH_IDX++;
					}
					;
				}
				;
				return;
			}
			;
			var _local_4:Number = (_arg_3.getPSpeed() * 10);
			var _local_5:Boolean = (_arg_3.x_ > _arg_1);
			var _local_6:Boolean = (_arg_3.y_ > _arg_2);
			var _local_7:Boolean = (int(_arg_3.x_) == _arg_1);
			var _local_8:Boolean = (int(_arg_3.y_) == _arg_2);
			if (((!(_local_7)) && (!(_local_8))))
			{
				_arg_3.walkTo(((!(!(_local_5))) ? (_arg_3.x_ - _local_4) : (_arg_3.x_ + _local_4)), ((!(!(_local_6))) ? (_arg_3.y_ - _local_4) : (_arg_3.y_ + _local_4)));
			}
			else
			{
				if (_local_8)
				{
					_arg_3.walkTo(((!(!(_local_5))) ? (_arg_3.x_ - _local_4) : (_arg_3.x_ + _local_4)), _arg_3.y_);
				}
				else
				{
					if (_local_7)
					{
						_arg_3.walkTo(_arg_3.x_, ((!(!(_local_6))) ? (_arg_3.y_ - _local_4) : (_arg_3.y_ + _local_4)));
					}
					;
				}
				;
			}
			;
		}
		
		public function update(_arg_1:int, _arg_2:int):void
		{
			var _local_3:GameObject;
			var _local_4:Player;
			if (_arg_1 < (this.lastUpdate_ + (((!(Options.hidden)) && (Parameters.lowCPUMode)) ? 2500 : 500)))
			{
				return;
			}
			;
			this.lastUpdate_ = _arg_1;
			this.members_.length = 0;
			var _local_5:Player = this.map_.player_;
			if (_local_5 == null)
			{
				return;
			}
			;
			for each (_local_3 in this.map_.goDict_)
			{
				_local_4 = (_local_3 as Player);
				if ((!((_local_4 == null) || (_local_4 == _local_5))))
				{
					_local_4.starred_ = (!(this.starred_[_local_4.accountId_] == undefined));
					_local_4.ignored_ = (!(this.ignored_[_local_4.accountId_] == undefined));
					_local_4.distSqFromThisPlayer_ = PointUtil.distanceSquaredXY(_local_5.x_, _local_5.y_, _local_4.x_, _local_4.y_);
					if (((!((_local_4.distSqFromThisPlayer_ > PARTY_DISTANCE_SQ) && (!(_local_4.starred_)))) || (this.members_.length < 6)))
					{
						if ((!(((this.map_.name_ == "Nexus") && (Parameters.data_.HidePlayerFilter)) && (_local_4.numStars_ <= Parameters.data_.chatStarRequirement))))
						{
							this.members_.push(_local_4);
						}
						;
					}
					;
				}
				;
			}
			;
			this.members_.sortOn(SORT_ON_FIELDS, SORT_ON_PARAMS);
			if (this.members_.length > NUM_MEMBERS)
			{
				this.members_.length = NUM_MEMBERS;
			}
			;
		}
		
		public function lockPlayer(_arg_1:Player):void
		{
			this.starred_[_arg_1.accountId_] = 1;
			this.lastUpdate_ = int.MIN_VALUE;
			this.map_.gs_.gsc_.editAccountList(0, true, _arg_1.objectId_);
		}
		
		public function unlockPlayer(_arg_1:Player):void
		{
			delete this.starred_[_arg_1.accountId_];
			_arg_1.starred_ = false;
			this.lastUpdate_ = int.MIN_VALUE;
			this.map_.gs_.gsc_.editAccountList(0, false, _arg_1.objectId_);
		}
		
		public function setStars(_arg_1:AccountList):void
		{
			var _local_2:String;
			var _local_3:int;
			while (_local_3 < _arg_1.accountIds_.length)
			{
				_local_2 = _arg_1.accountIds_[_local_3];
				this.starred_[_local_2] = 1;
				this.lastUpdate_ = int.MIN_VALUE;
				_local_3++;
			}
			;
		}
		
		public function removeStars(_arg_1:AccountList):void
		{
			var _local_2:String;
			var _local_3:int;
			while (_local_3 < _arg_1.accountIds_.length)
			{
				_local_2 = _arg_1.accountIds_[_local_3];
				delete this.starred_[_local_2];
				this.lastUpdate_ = int.MIN_VALUE;
				_local_3++;
			}
			;
		}
		
		public function ignorePlayer(_arg_1:Player):void
		{
			this.ignored_[_arg_1.accountId_] = 1;
			this.lastUpdate_ = int.MIN_VALUE;
			this.map_.gs_.gsc_.editAccountList(1, true, _arg_1.objectId_);
		}
		
		public function unignorePlayer(_arg_1:Player):void
		{
			delete this.ignored_[_arg_1.accountId_];
			_arg_1.ignored_ = false;
			this.lastUpdate_ = int.MIN_VALUE;
			this.map_.gs_.gsc_.editAccountList(1, false, _arg_1.objectId_);
		}
		
		public function setIgnores(_arg_1:AccountList):void
		{
			var _local_2:String;
			var _local_3:int;
			this.ignored_ = new Dictionary(true);
			while (_local_3 < _arg_1.accountIds_.length)
			{
				_local_2 = _arg_1.accountIds_[_local_3];
				this.ignored_[_local_2] = 1;
				this.lastUpdate_ = int.MIN_VALUE;
				_local_3++;
			}
			;
		}
	
	}
}//package com.company.assembleegameclient.objects

