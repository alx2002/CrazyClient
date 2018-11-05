// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.greensock.core.Animation

package com.greensock.core
{
    import flash.display.Shape;
    import flash.events.Event;
    import flash.utils.getTimer;

    public class Animation 
    {

        public static const version:String = "12.1.1";
        public static var ticker:Shape = new Shape();
        public static var _rootTimeline:SimpleTimeline;
        public static var _rootFramesTimeline:SimpleTimeline;
        protected static var _rootFrame:Number = -1;
        protected static var _tickEvent:Event = new Event("tick");
        protected static var _tinyNum:Number = 1E-10;

        public var _delay:Number;
        public var _prev:Animation;
        public var _reversed:Boolean;
        public var _active:Boolean;
        public var _timeline:SimpleTimeline;
        public var _rawPrevTime:Number;
        public var data:*;
        public var vars:Object;
        public var _totalTime:Number;
        public var _time:Number;
        public var timeline:SimpleTimeline;
        public var _initted:Boolean;
        public var _paused:Boolean;
        public var _startTime:Number;
        public var _dirty:Boolean;
        public var _next:Animation;
        protected var _onUpdate:Function;
        public var _pauseTime:Number;
        public var _duration:Number;
        public var _totalDuration:Number;
        public var _gc:Boolean;
        public var _timeScale:Number;

        public function Animation(_arg_1:Number=0, _arg_2:Object=null)
        {
            this.vars = ((_arg_2) || ({}));
            if (this.vars._isGSVars)
            {
                this.vars = this.vars.vars;
            };
            this._duration = (this._totalDuration = ((_arg_1) || (0)));
            this._delay = ((Number(this.vars.delay)) || (0));
            this._timeScale = 1;
            this._totalTime = (this._time = 0);
            this.data = this.vars.data;
            this._rawPrevTime = -1;
            if (_rootTimeline == null)
            {
                if (_rootFrame == -1)
                {
                    _rootFrame = 0;
                    _rootFramesTimeline = new SimpleTimeline();
                    _rootTimeline = new SimpleTimeline();
                    _rootTimeline._startTime = (getTimer() / 1000);
                    _rootFramesTimeline._startTime = 0;
                    _rootTimeline._active = (_rootFramesTimeline._active = true);
                    ticker.addEventListener("enterFrame", _updateRoot, false, 0, true);
                }
                else
                {
                    return;
                };
            };
            var _local_3:SimpleTimeline = ((this.vars.useFrames) ? _rootFramesTimeline : _rootTimeline);
            _local_3.add(this, _local_3._time);
            this._reversed = (this.vars.reversed == true);
            if (this.vars.paused)
            {
                this.paused(true);
            };
        }

        public static function _updateRoot(_arg_1:Event=null):void
        {
            _rootFrame++;
            _rootTimeline.render((((getTimer() / 1000) - _rootTimeline._startTime) * _rootTimeline._timeScale), false, false);
            _rootFramesTimeline.render(((_rootFrame - _rootFramesTimeline._startTime) * _rootFramesTimeline._timeScale), false, false);
            ticker.dispatchEvent(_tickEvent);
        }


        public function delay(_arg_1:Number=NaN):*
        {
            if ((!(arguments.length)))
            {
                return (this._delay);
            };
            if (this._timeline.smoothChildTiming)
            {
                this.startTime(((this._startTime + _arg_1) - this._delay));
            };
            this._delay = _arg_1;
            return (this);
        }

        public function totalDuration(_arg_1:Number=NaN):*
        {
            this._dirty = false;
            return ((arguments.length) ? this.duration(_arg_1) : this._totalDuration);
        }

        public function _enabled(_arg_1:Boolean, _arg_2:Boolean=false):Boolean
        {
            this._gc = (!(_arg_1));
            this._active = Boolean(((((_arg_1) && (!(this._paused))) && (this._totalTime > 0)) && (this._totalTime < this._totalDuration)));
            if ((!(_arg_2)))
            {
                if (((_arg_1) && (this.timeline == null)))
                {
                    this._timeline.add(this, (this._startTime - this._delay));
                }
                else
                {
                    if (((!(_arg_1)) && (!(this.timeline == null))))
                    {
                        this._timeline._remove(this, true);
                    };
                };
            };
            return (false);
        }

        public function timeScale(_arg_1:Number=NaN):*
        {
            var _local_3:Number;
            if ((!(arguments.length)))
            {
                return (this._timeScale);
            };
            _arg_1 = ((_arg_1) || (1E-6));
            if (((this._timeline) && (this._timeline.smoothChildTiming)))
            {
                _local_3 = (((this._pauseTime) || (this._pauseTime == 0)) ? this._pauseTime : this._timeline._totalTime);
                this._startTime = (_local_3 - (((_local_3 - this._startTime) * this._timeScale) / _arg_1));
            };
            this._timeScale = _arg_1;
            return (this._uncache(false));
        }

        protected function _swapSelfInParams(_arg_1:Array):Array
        {
            var _local_2:int = _arg_1.length;
            var _local_3:Array = _arg_1.concat();
            while (--_local_2 > -1)
            {
                if (_arg_1[_local_2] === "{self}")
                {
                    _local_3[_local_2] = this;
                };
            };
            return (_local_3);
        }

        public function totalProgress(_arg_1:Number=NaN, _arg_2:Boolean=false):*
        {
            return ((arguments.length) ? this.totalTime((this.duration() * _arg_1), _arg_2) : (this._time / this.duration()));
        }

        public function duration(_arg_1:Number=NaN):*
        {
            if ((!(arguments.length)))
            {
                this._dirty = false;
                return (this._duration);
            };
            this._duration = (this._totalDuration = _arg_1);
            this._uncache(true);
            if (this._timeline.smoothChildTiming)
            {
                if (this._time > 0)
                {
                    if (this._time < this._duration)
                    {
                        if (_arg_1 != 0)
                        {
                            this.totalTime((this._totalTime * (_arg_1 / this._duration)), true);
                        };
                    };
                };
            };
            return (this);
        }

        public function restart(_arg_1:Boolean=false, _arg_2:Boolean=true):*
        {
            this.reversed(false);
            this.paused(false);
            return (this.totalTime(((_arg_1) ? -(this._delay) : 0), _arg_2, true));
        }

        public function render(_arg_1:Number, _arg_2:Boolean=false, _arg_3:Boolean=false):void
        {
        }

        public function resume(_arg_1:*=null, _arg_2:Boolean=true):*
        {
            if (_arg_1 != null)
            {
                this.seek(_arg_1, _arg_2);
            };
            return (this.paused(false));
        }

        public function paused(_arg_1:Boolean=false):*
        {
            var _local_3:Number;
            var _local_4:Number;
            if ((!(arguments.length)))
            {
                return (this._paused);
            };
            if (_arg_1 != this._paused)
            {
                if (this._timeline)
                {
                    _local_3 = this._timeline.rawTime();
                    _local_4 = (_local_3 - this._pauseTime);
                    if (((!(_arg_1)) && (this._timeline.smoothChildTiming)))
                    {
                        this._startTime = (this._startTime + _local_4);
                        this._uncache(false);
                    };
                    this._pauseTime = ((_arg_1) ? _local_3 : NaN);
                    this._paused = _arg_1;
                    this._active = (((!(_arg_1)) && (this._totalTime > 0)) && (this._totalTime < this._totalDuration));
                    if (((((!(_arg_1)) && (!(_local_4 == 0))) && (this._initted)) && (!(this.duration() === 0))))
                    {
                        this.render(((this._timeline.smoothChildTiming) ? this._totalTime : ((_local_3 - this._startTime) / this._timeScale)), true, true);
                    };
                };
            };
            if (((this._gc) && (!(_arg_1))))
            {
                this._enabled(true, false);
            };
            return (this);
        }

        public function totalTime(_arg_1:Number=NaN, _arg_2:Boolean=false, _arg_3:Boolean=false):*
        {
            var _local_5:SimpleTimeline;
            if ((!(arguments.length)))
            {
                return (this._totalTime);
            };
            if (this._timeline)
            {
                if (((_arg_1 < 0) && (!(_arg_3))))
                {
                    _arg_1 = (_arg_1 + this.totalDuration());
                };
                if (this._timeline.smoothChildTiming)
                {
                    if (this._dirty)
                    {
                        this.totalDuration();
                    };
                    if (((_arg_1 > this._totalDuration) && (!(_arg_3))))
                    {
                        _arg_1 = this._totalDuration;
                    };
                    _local_5 = this._timeline;
                    this._startTime = (((this._paused) ? this._pauseTime : _local_5._time) - (((this._reversed) ? (this._totalDuration - _arg_1) : _arg_1) / this._timeScale));
                    if ((!(this._timeline._dirty)))
                    {
                        this._uncache(false);
                    };
                    if (_local_5._timeline != null)
                    {
                        while (_local_5._timeline)
                        {
                            if (_local_5._timeline._time !== ((_local_5._startTime + _local_5._totalTime) / _local_5._timeScale))
                            {
                                _local_5.totalTime(_local_5._totalTime, true);
                            };
                            _local_5 = _local_5._timeline;
                        };
                    };
                };
                if (this._gc)
                {
                    this._enabled(true, false);
                };
                if (((!(this._totalTime == _arg_1)) || (this._duration === 0)))
                {
                    this.render(_arg_1, _arg_2, false);
                };
            };
            return (this);
        }

        public function play(_arg_1:*=null, _arg_2:Boolean=true):*
        {
            if (_arg_1 != null)
            {
                this.seek(_arg_1, _arg_2);
            };
            this.reversed(false);
            return (this.paused(false));
        }

        public function invalidate():*
        {
            return (this);
        }

        public function progress(_arg_1:Number=NaN, _arg_2:Boolean=false):*
        {
            return ((arguments.length) ? this.totalTime((this.duration() * _arg_1), _arg_2) : (this._time / this.duration()));
        }

        public function _kill(_arg_1:Object=null, _arg_2:Object=null):Boolean
        {
            return (this._enabled(false, false));
        }

        public function reversed(_arg_1:Boolean=false):*
        {
            if ((!(arguments.length)))
            {
                return (this._reversed);
            };
            if (_arg_1 != this._reversed)
            {
                this._reversed = _arg_1;
                this.totalTime((((this._timeline) && (!(this._timeline.smoothChildTiming))) ? (this.totalDuration() - this._totalTime) : this._totalTime), true);
            };
            return (this);
        }

        public function startTime(_arg_1:Number=NaN):*
        {
            if ((!(arguments.length)))
            {
                return (this._startTime);
            };
            if (_arg_1 != this._startTime)
            {
                this._startTime = _arg_1;
                if (this.timeline)
                {
                    if (this.timeline._sortChildren)
                    {
                        this.timeline.add(this, (_arg_1 - this._delay));
                    };
                };
            };
            return (this);
        }

        protected function _uncache(_arg_1:Boolean):*
        {
            var _local_2:Animation = ((_arg_1) ? this : this.timeline);
            while (_local_2)
            {
                _local_2._dirty = true;
                _local_2 = _local_2.timeline;
            };
            return (this);
        }

        public function isActive():Boolean
        {
            var _local_1:Number;
            var _local_2:SimpleTimeline = this._timeline;
            return ((_local_2 == null) || (((((!(this._gc)) && (!(this._paused))) && (_local_2.isActive())) && ((_local_1 = _local_2.rawTime()) >= this._startTime)) && (_local_1 < (this._startTime + (this.totalDuration() / this._timeScale)))));
        }

        public function time(_arg_1:Number=NaN, _arg_2:Boolean=false):*
        {
            if ((!(arguments.length)))
            {
                return (this._time);
            };
            if (this._dirty)
            {
                this.totalDuration();
            };
            if (_arg_1 > this._duration)
            {
                _arg_1 = this._duration;
            };
            return (this.totalTime(_arg_1, _arg_2));
        }

        public function kill(_arg_1:Object=null, _arg_2:Object=null):*
        {
            this._kill(_arg_1, _arg_2);
            return (this);
        }

        public function reverse(_arg_1:*=null, _arg_2:Boolean=true):*
        {
            if (_arg_1 != null)
            {
                this.seek(((_arg_1) || (this.totalDuration())), _arg_2);
            };
            this.reversed(true);
            return (this.paused(false));
        }

        public function seek(_arg_1:*, _arg_2:Boolean=true):*
        {
            return (this.totalTime(Number(_arg_1), _arg_2));
        }

        public function pause(_arg_1:*=null, _arg_2:Boolean=true):*
        {
            if (_arg_1 != null)
            {
                this.seek(_arg_1, _arg_2);
            };
            return (this.paused(true));
        }

        public function eventCallback(_arg_1:String, _arg_2:Function=null, _arg_3:Array=null):*
        {
            if (_arg_1 == null)
            {
                return (null);
            };
            if (_arg_1.substr(0, 2) == "on")
            {
                if (arguments.length == 1)
                {
                    return (this.vars[_arg_1]);
                };
                if (_arg_2 == null)
                {
                    delete this.vars[_arg_1];
                }
                else
                {
                    this.vars[_arg_1] = _arg_2;
                    this.vars[(_arg_1 + "Params")] = (((_arg_3 is Array) && (!(_arg_3.join("").indexOf("{self}") === -1))) ? this._swapSelfInParams(_arg_3) : _arg_3);
                };
                if (_arg_1 == "onUpdate")
                {
                    this._onUpdate = _arg_2;
                };
            };
            return (this);
        }


    }
}//package com.greensock.core

