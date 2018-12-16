


//com.greensock.TimelineMax

package com.greensock
{
	import com.greensock.core.Animation;
	import com.greensock.easing.Ease;
	import com.greensock.events.TweenEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class TimelineMax extends TimelineLite implements IEventDispatcher
	{

		public static const version:String = "12.1.5";
		protected static var _listenerLookup:Object = {"onCompleteListener": TweenEvent.COMPLETE, "onUpdateListener": TweenEvent.UPDATE, "onStartListener": TweenEvent.START, "onRepeatListener": TweenEvent.REPEAT, "onReverseCompleteListener": TweenEvent.REVERSE_COMPLETE};
		protected static var _easeNone:Ease = new Ease(null, null, 1, 0);

		protected var _dispatcher:EventDispatcher;
		protected var _yoyo:Boolean;
		protected var _hasUpdateListener:Boolean;
		protected var _cycle:int = 0;
		protected var _locked:Boolean;
		protected var _repeatDelay:Number;
		protected var _repeat:int;

		public function TimelineMax(_arg_1:Object = null)
		{
			super(_arg_1);
			this._repeat = ((this.vars.repeat) || (0));
			this._repeatDelay = ((this.vars.repeatDelay) || (0));
			this._yoyo = (this.vars.yoyo == true);
			_dirty = true;
			if ((((((this.vars.onCompleteListener) || (this.vars.onUpdateListener)) || (this.vars.onStartListener)) || (this.vars.onRepeatListener)) || (this.vars.onReverseCompleteListener)))
			{
				this._initDispatcher();
			}
			;
		}

		protected static function _getGlobalPaused(_arg_1:Animation):Boolean
		{
			while (_arg_1)
			{
				if (_arg_1._paused)
				{
					return (true);
				}
				;
				_arg_1 = _arg_1._timeline;
			}
			;
			return (false);
		}

		public function dispatchEvent(_arg_1:Event):Boolean
		{
			return ((this._dispatcher == null) ? false : this._dispatcher.dispatchEvent(_arg_1));
		}

		public function currentLabel(_arg_1:String = null):*
		{
			if ((!(arguments.length)))
			{
				return (this.getLabelBefore((_time + 1E-8)));
			}
			;
			return (seek(_arg_1, true));
		}

		public function hasEventListener(_arg_1:String):Boolean
		{
			return ((this._dispatcher == null) ? false : this._dispatcher.hasEventListener(_arg_1));
		}

		public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean = false):void
		{
			if (this._dispatcher != null)
			{
				this._dispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
			}
			;
		}

		public function addCallback(_arg_1:Function, _arg_2:*, _arg_3:Array = null):TimelineMax
		{
			return (add(TweenLite.delayedCall(0, _arg_1, _arg_3), _arg_2) as TimelineMax);
		}

		public function tweenFromTo(_arg_1:*, _arg_2:*, _arg_3:Object = null):TweenLite
		{
			_arg_3 = ((_arg_3) || ({}));
			_arg_1 = _parseTimeOrLabel(_arg_1);
			_arg_3.startAt = {"onComplete": seek, "onCompleteParams": [_arg_1]};
			_arg_3.immediateRender = (!(_arg_3.immediateRender === false));
			var _local_4:TweenLite = this.tweenTo(_arg_2, _arg_3);
			return (_local_4.public::duration(((Math.abs((_local_4.vars.time - _arg_1)) / _timeScale) || (0.001))) as TweenLite);
		}

		public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean = false, _arg_4:int = 0, _arg_5:Boolean = false):void
		{
			if (this._dispatcher == null)
			{
				this._dispatcher = new EventDispatcher(this);
			}
			;
			if (_arg_1 == TweenEvent.UPDATE)
			{
				this._hasUpdateListener = true;
			}
			;
			this._dispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
		}

		public function tweenTo(_arg_1:*, _arg_2:Object = null):TweenLite
		{
			var p:String;
			var duration:Number;
			var t:TweenLite;
			var position:* = _arg_1;
			var vars = _arg_2;
			vars = ((vars) || ({}));
			var copy:Object = {"ease": _easeNone, "overwrite": ((vars.delay) ? 2 : 1), "useFrames": usesFrames(), "immediateRender": false};
			for (p in vars)
			{
				copy[p] = vars[p];
			}
			;
			copy.time = _parseTimeOrLabel(position);
			duration = ((Math.abs((Number(copy.time) - _time)) / _timeScale) || (0.001));
			t = new TweenLite(this, duration, copy);
			copy.onStart = function():void
			{
				t.target.paused(true);
				if (((!(t.vars.time == t.target.time())) && (internal::duration === t.public::duration())))
				{
					t.public::duration((Math.abs((t.vars.time - t.target.time())) / t.target._timeScale));
				}
				;
				if (internal::vars.onStart)
				{
					internal::vars.onStart.apply(null, internal::vars.onStartParams);
				}
				;
			};
			return (t);
		}

		public function repeat(_arg_1:Number = 0):*
		{
			if ((!(arguments.length)))
			{
				return (this._repeat);
			}
			;
			this._repeat = _arg_1;
			return (_uncache(true));
		}

		public function getLabelBefore(_arg_1:Number = NaN):String
		{
			if ((!(_arg_1)))
			{
				if (_arg_1 != 0)
				{
					_arg_1 = _time;
				}
				;
			}
			;
			var _local_2:Array = this.getLabelsArray();
			var _local_3:int = _local_2.length;
			while (--_local_3 > -1)
			{
				if (_local_2[_local_3].time < _arg_1)
				{
					return (_local_2[_local_3].name);
				}
				;
			}
			;
			return (null);
		}

		public function willTrigger(_arg_1:String):Boolean
		{
			return ((this._dispatcher == null) ? false : this._dispatcher.willTrigger(_arg_1));
		}

		override public function totalProgress(_arg_1:Number = NaN, _arg_2:Boolean = true):*
		{
			return ((arguments.length) ? totalTime((this.totalDuration() * _arg_1), _arg_2) : (_totalTime / this.totalDuration()));
		}

		public function getLabelsArray():Array
		{
			var _local_1:String;
			var _local_3:int;
			var _local_4:*;
			var _local_2:Array = [];
			for (_local_1 in _labels)
			{
				_local_4 = _local_3++;
				_local_2[_local_4] = {"time": _labels[_local_1], "name": _local_1};
			}
			;
			_local_2.sortOn("time", Array.NUMERIC);
			return (_local_2);
		}

		override public function render(_arg_1:Number, _arg_2:Boolean = false, _arg_3:Boolean = false):void
		{
			var _local_4:Animation;
			var _local_5:Boolean;
			var _local_6:Animation;
			var _local_7:Number;
			var _local_8:String;
			var _local_9:Boolean;
			var _local_10:Number;
			var _local_11:Boolean;
			var _local_12:Boolean;
			var _local_13:Number;
			var _local_14:int;
			var _local_15:Number;
			var _local_16:Number;
			var _local_17:Number;
			var _local_18:Number;
			if (_gc)
			{
				_enabled(true, false);
			}
			;
			_local_17 = ((_dirty) ? this.totalDuration() : _totalDuration);
			_local_18 = _time;
			var _local_19:Number = _totalTime;
			var _local_20:Number = _startTime;
			var _local_21:Number = _timeScale;
			var _local_22:Number = _rawPrevTime;
			var _local_23:Boolean = _paused;
			var _local_24:int = this._cycle;
			if (_arg_1 >= _local_17)
			{
				if ((!(this._locked)))
				{
					_totalTime = _local_17;
					this._cycle = this._repeat;
				}
				;
				if ((!(_reversed)))
				{
					if ((!(_hasPausedChild())))
					{
						_local_5 = true;
						_local_8 = "onComplete";
						if (_duration === 0)
						{
							if ((((_arg_1 === 0) || (_rawPrevTime < 0)) || (_rawPrevTime === _tinyNum)))
							{
								if (((!(_rawPrevTime === _arg_1)) && (!(_first == null))))
								{
									_local_9 = true;
									if (_rawPrevTime > _tinyNum)
									{
										_local_8 = "onReverseComplete";
									}
									;
								}
								;
							}
							;
						}
						;
					}
					;
				}
				;
				_rawPrevTime = (((((_duration) || (!(_arg_2))) || (!(_arg_1 === 0))) || (_rawPrevTime === _arg_1)) ? _arg_1 : _tinyNum);
				if (((this._yoyo) && (!((this._cycle & 0x01) == 0))))
				{
					_time = (_arg_1 = 0);
				}
				else
				{
					_time = _duration;
					_arg_1 = (_duration + 0.0001);
				}
				;
			}
			else
			{
				if (_arg_1 < 1E-7)
				{
					if ((!(this._locked)))
					{
						_totalTime = (this._cycle = 0);
					}
					;
					_time = 0;
					if (((!(_local_18 === 0)) || ((((_duration === 0) && (!(_rawPrevTime === _tinyNum))) && ((_rawPrevTime > 0) || ((_arg_1 < 0) && (_rawPrevTime >= 0)))) && (!(this._locked)))))
					{
						_local_8 = "onReverseComplete";
						_local_5 = _reversed;
					}
					;
					if (_arg_1 < 0)
					{
						_active = false;
						if (((_rawPrevTime >= 0) && (_first)))
						{
							_local_9 = true;
						}
						;
						_rawPrevTime = _arg_1;
					}
					else
					{
						_rawPrevTime = (((((_duration) || (!(_arg_2))) || (!(_arg_1 === 0))) || (_rawPrevTime === _arg_1)) ? _arg_1 : _tinyNum);
						_arg_1 = 0;
						if ((!(_initted)))
						{
							_local_9 = true;
						}
						;
					}
					;
				}
				else
				{
					if (((_duration === 0) && (_rawPrevTime < 0)))
					{
						_local_9 = true;
					}
					;
					_time = (_rawPrevTime = _arg_1);
					if ((!(this._locked)))
					{
						_totalTime = _arg_1;
						if (this._repeat != 0)
						{
							_local_10 = (_duration + this._repeatDelay);
							this._cycle = ((_totalTime / _local_10) >> 0);
							if (this._cycle !== 0)
							{
								if (this._cycle === (_totalTime / _local_10))
								{
									this._cycle--;
								}
								;
							}
							;
							_time = (_totalTime - (this._cycle * _local_10));
							if (this._yoyo)
							{
								if ((this._cycle & 0x01) != 0)
								{
									_time = (_duration - _time);
								}
								;
							}
							;
							if (_time > _duration)
							{
								_time = _duration;
								_arg_1 = (_duration + 0.0001);
							}
							else
							{
								if (_time < 0)
								{
									_time = (_arg_1 = 0);
								}
								else
								{
									_arg_1 = _time;
								}
								;
							}
							;
						}
						;
					}
					;
				}
				;
			}
			;
			if (this._cycle != _local_24)
			{
				if ((!(this._locked)))
				{
					_local_11 = ((this._yoyo) && (!((_local_24 & 0x01) === 0)));
					_local_12 = (_local_11 == ((this._yoyo) && (!((this._cycle & 0x01) === 0))));
					_local_13 = _totalTime;
					_local_14 = this._cycle;
					_local_15 = _rawPrevTime;
					_local_16 = _time;
					_totalTime = (_local_24 * _duration);
					if (this._cycle < _local_24)
					{
						_local_11 = (!(_local_11));
					}
					else
					{
						_totalTime = (_totalTime + _duration);
					}
					;
					_time = _local_18;
					_rawPrevTime = _local_22;
					this._cycle = _local_24;
					this._locked = true;
					_local_18 = ((_local_11) ? 0 : _duration);
					this.render(_local_18, _arg_2, false);
					if ((!(_arg_2)))
					{
						if ((!(_gc)))
						{
							if (public::vars.onRepeat)
							{
								public::vars.onRepeat.apply(null, public::vars.onRepeatParams);
							}
							;
							if (this._dispatcher)
							{
								this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.REPEAT));
							}
							;
						}
						;
					}
					;
					if (_local_12)
					{
						_local_18 = ((_local_11) ? (_duration + 0.0001) : -0.0001);
						this.render(_local_18, true, false);
					}
					;
					this._locked = false;
					if (((_paused) && (!(_local_23))))
					{
						return;
					}
					;
					_time = _local_16;
					_totalTime = _local_13;
					this._cycle = _local_14;
					_rawPrevTime = _local_15;
				}
				;
			}
			;
			if (((((_time == _local_18) || (!(_first))) && (!(_arg_3))) && (!(_local_9))))
			{
				if (_local_19 !== _totalTime)
				{
					if (_onUpdate != null)
					{
						if ((!(_arg_2)))
						{
							_onUpdate.apply(((public::vars.onUpdateScope) || (this)), public::vars.onUpdateParams);
						}
						;
					}
					;
				}
				;
				return;
			}
			;
			if ((!(_initted)))
			{
				_initted = true;
			}
			;
			if ((!(_active)))
			{
				if ((((!(_paused)) && (!(_totalTime === _local_19))) && (_arg_1 > 0)))
				{
					_active = true;
				}
				;
			}
			;
			if (_local_19 == 0)
			{
				if (_totalTime != 0)
				{
					if ((!(_arg_2)))
					{
						if (public::vars.onStart)
						{
							public::vars.onStart.apply(this, public::vars.onStartParams);
						}
						;
						if (this._dispatcher)
						{
							this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.START));
						}
						;
					}
					;
				}
				;
			}
			;
			if (_time >= _local_18)
			{
				_local_4 = _first;
				while (_local_4)
				{
					_local_6 = _local_4._next;
					if (((_paused) && (!(_local_23)))) break;
					if (((_local_4._active) || (((_local_4._startTime <= _time) && (!(_local_4._paused))) && (!(_local_4._gc)))))
					{
						if ((!(_local_4._reversed)))
						{
							_local_4.render(((_arg_1 - _local_4._startTime) * _local_4._timeScale), _arg_2, _arg_3);
						}
						else
						{
							_local_4.render((((_local_4._dirty) ? _local_4.totalDuration() : _local_4._totalDuration) - ((_arg_1 - _local_4._startTime) * _local_4._timeScale)), _arg_2, _arg_3);
						}
						;
					}
					;
					_local_4 = _local_6;
				}
				;
			}
			else
			{
				_local_4 = _last;
				while (_local_4)
				{
					_local_6 = _local_4._prev;
					if (((_paused) && (!(_local_23)))) break;
					if (((_local_4._active) || (((_local_4._startTime <= _local_18) && (!(_local_4._paused))) && (!(_local_4._gc)))))
					{
						if ((!(_local_4._reversed)))
						{
							_local_4.render(((_arg_1 - _local_4._startTime) * _local_4._timeScale), _arg_2, _arg_3);
						}
						else
						{
							_local_4.render((((_local_4._dirty) ? _local_4.totalDuration() : _local_4._totalDuration) - ((_arg_1 - _local_4._startTime) * _local_4._timeScale)), _arg_2, _arg_3);
						}
						;
					}
					;
					_local_4 = _local_6;
				}
				;
			}
			;
			if (_onUpdate != null)
			{
				if ((!(_arg_2)))
				{
					_onUpdate.apply(null, public::vars.onUpdateParams);
				}
				;
			}
			;
			if (this._hasUpdateListener)
			{
				if ((!(_arg_2)))
				{
					this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
				}
				;
			}
			;
			if (_local_8)
			{
				if ((!(this._locked)))
				{
					if ((!(_gc)))
					{
						if (((_local_20 === _startTime) || (!(_local_21 === _timeScale))))
						{
							if (((_time === 0) || (_local_17 >= this.totalDuration())))
							{
								if (_local_5)
								{
									if (_timeline.autoRemoveChildren)
									{
										_enabled(false, false);
									}
									;
									_active = false;
								}
								;
								if ((!(_arg_2)))
								{
									if (public::vars[_local_8])
									{
										public::vars[_local_8].apply(null, public::vars[(_local_8 + "Params")]);
									}
									;
									if (this._dispatcher)
									{
										this._dispatcher.dispatchEvent(new TweenEvent(((_local_8 == "onComplete") ? TweenEvent.COMPLETE : TweenEvent.REVERSE_COMPLETE)));
									}
									;
								}
								;
							}
							;
						}
						;
					}
					;
				}
				;
			}
			;
		}

		public function removeCallback(_arg_1:Function, _arg_2:* = null):TimelineMax
		{
			var _local_3:Array;
			var _local_4:int;
			var _local_5:Number;
			if (_arg_1 != null)
			{
				if (_arg_2 == null)
				{
					_kill(null, _arg_1);
				}
				else
				{
					_local_3 = getTweensOf(_arg_1, false);
					_local_4 = _local_3.length;
					_local_5 = _parseTimeOrLabel(_arg_2);
					while (--_local_4 > -1)
					{
						if (_local_3[_local_4]._startTime === _local_5)
						{
							_local_3[_local_4]._enabled(false, false);
						}
						;
					}
					;
				}
				;
			}
			;
			return (this);
		}

		public function yoyo(_arg_1:Boolean = false):*
		{
			if ((!(arguments.length)))
			{
				return (this._yoyo);
			}
			;
			this._yoyo = _arg_1;
			return (this);
		}

		override public function progress(_arg_1:Number = NaN, _arg_2:Boolean = false):*
		{
			return ((arguments.length) ? totalTime(((public::duration() * (((this._yoyo) && (!((this._cycle & 0x01) === 0))) ? (1 - _arg_1) : _arg_1)) + (this._cycle * (_duration + this._repeatDelay))), _arg_2) : (_time / public::duration()));
		}

		public function repeatDelay(_arg_1:Number = 0):*
		{
			if ((!(arguments.length)))
			{
				return (this._repeatDelay);
			}
			;
			this._repeatDelay = _arg_1;
			return (_uncache(true));
		}

		override public function time(_arg_1:Number = NaN, _arg_2:Boolean = false):*
		{
			if ((!(arguments.length)))
			{
				return (_time);
			}
			;
			if (_dirty)
			{
				this.totalDuration();
			}
			;
			if (_arg_1 > _duration)
			{
				_arg_1 = _duration;
			}
			;
			if (((this._yoyo) && (!((this._cycle & 0x01) === 0))))
			{
				_arg_1 = ((_duration - _arg_1) + (this._cycle * (_duration + this._repeatDelay)));
			}
			else
			{
				if (this._repeat != 0)
				{
					_arg_1 = (_arg_1 + (this._cycle * (_duration + this._repeatDelay)));
				}
				;
			}
			;
			return (totalTime(_arg_1, _arg_2));
		}

		protected function _initDispatcher():Boolean
		{
			var _local_1:String;
			var _local_2:Boolean;
			for (_local_1 in _listenerLookup)
			{
				if ((_local_1 in public::vars))
				{
					if ((public::vars[_local_1] is Function))
					{
						if (this._dispatcher == null)
						{
							this._dispatcher = new EventDispatcher(this);
						}
						;
						this._dispatcher.addEventListener(_listenerLookup[_local_1], public::vars[_local_1], false, 0, true);
						_local_2 = true;
					}
					;
				}
				;
			}
			;
			return (_local_2);
		}

		override public function invalidate():*
		{
			this._yoyo = Boolean((this.vars.yoyo == true));
			this._repeat = ((this.vars.repeat) || (0));
			this._repeatDelay = ((this.vars.repeatDelay) || (0));
			this._hasUpdateListener = false;
			this._initDispatcher();
			_uncache(true);
			return (super.invalidate());
		}

		public function getActive(_arg_1:Boolean = true, _arg_2:Boolean = true, _arg_3:Boolean = false):Array
		{
			var _local_4:int;
			var _local_5:Animation;
			var _local_8:int;
			var _local_10:*;
			var _local_6:Array = [];
			var _local_7:Array = getChildren(_arg_1, _arg_2, _arg_3);
			var _local_9:int = _local_7.length;
			_local_4 = 0;
			while (_local_4 < _local_9)
			{
				_local_5 = _local_7[_local_4];
				if ((!(_local_5._paused)))
				{
					if (_local_5._timeline._time >= _local_5._startTime)
					{
						if (_local_5._timeline._time < (_local_5._startTime + (_local_5._totalDuration / _local_5._timeScale)))
						{
							if ((!(_getGlobalPaused(_local_5._timeline))))
							{
								_local_10 = _local_8++;
								_local_6[_local_10] = _local_5;
							}
							;
						}
						;
					}
					;
				}
				;
				_local_4++;
			}
			;
			return (_local_6);
		}

		public function getLabelAfter(_arg_1:Number = NaN):String
		{
			var _local_2:int;
			if ((!(_arg_1)))
			{
				if (_arg_1 != 0)
				{
					_arg_1 = _time;
				}
				;
			}
			;
			var _local_3:Array = this.getLabelsArray();
			var _local_4:int = _local_3.length;
			_local_2 = 0;
			while (_local_2 < _local_4)
			{
				if (_local_3[_local_2].time > _arg_1)
				{
					return (_local_3[_local_2].name);
				}
				;
				_local_2++;
			}
			;
			return (null);
		}

		override public function totalDuration(_arg_1:Number = NaN):*
		{
			if ((!(arguments.length)))
			{
				if (_dirty)
				{
					super.totalDuration();
					_totalDuration = ((this._repeat == -1) ? 999999999999 : ((_duration * (this._repeat + 1)) + (this._repeatDelay * this._repeat)));
				}
				;
				return (_totalDuration);
			}
			;
			return ((this._repeat == -1) ? this : public::duration(((_arg_1 - (this._repeat * this._repeatDelay)) / (this._repeat + 1))));
		}

	}
}//package com.greensock

