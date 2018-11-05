// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.greensock.TweenLite

package com.greensock
{
    import com.greensock.core.Animation;
    import com.greensock.easing.Ease;
    import flash.display.Shape;
    import flash.utils.Dictionary;
    import com.greensock.core.PropTween;
    import flash.events.Event;
    import com.greensock.core.SimpleTimeline;

    public class TweenLite extends Animation 
    {

        public static const version:String = "12.1.5";
        public static var defaultEase:Ease = new Ease(null, null, 1, 1);
        public static var defaultOverwrite:String = "auto";
        public static var ticker:Shape = Animation.ticker;
        public static var _plugins:Object = {};
        public static var _onPluginEvent:Function;
        protected static var _tweenLookup:Dictionary = new Dictionary(false);
        protected static var _reservedProps:Object = {
            "ease":1,
            "delay":1,
            "overwrite":1,
            "onComplete":1,
            "onCompleteParams":1,
            "onCompleteScope":1,
            "useFrames":1,
            "runBackwards":1,
            "startAt":1,
            "onUpdate":1,
            "onUpdateParams":1,
            "onUpdateScope":1,
            "onStart":1,
            "onStartParams":1,
            "onStartScope":1,
            "onReverseComplete":1,
            "onReverseCompleteParams":1,
            "onReverseCompleteScope":1,
            "onRepeat":1,
            "onRepeatParams":1,
            "onRepeatScope":1,
            "easeParams":1,
            "yoyo":1,
            "onCompleteListener":1,
            "onUpdateListener":1,
            "onStartListener":1,
            "onReverseCompleteListener":1,
            "onRepeatListener":1,
            "orientToBezier":1,
            "immediateRender":1,
            "repeat":1,
            "repeatDelay":1,
            "data":1,
            "paused":1,
            "reversed":1
        };
        protected static var _overwriteLookup:Object;

        protected var _targets:Array;
        public var ratio:Number;
        protected var _overwrite:int;
        public var _ease:Ease;
        protected var _siblings:Array;
        public var target:Object;
        protected var _overwrittenProps:Object;
        public var _propLookup:Object;
        protected var _easeType:int;
        protected var _notifyPluginsOfEnabled:Boolean;
        public var _firstPT:PropTween;
        protected var _startAt:TweenLite;
        protected var _easePower:int;

        public function TweenLite(_arg_1:Object, _arg_2:Number, _arg_3:Object)
        {
            var _local_4:int;
            super(_arg_2, _arg_3);
            if (_arg_1 == null)
            {
                throw (new Error(((("Cannot tween a null object. Duration: " + _arg_2) + ", data: ") + this.data)));
            };
            if ((!(_overwriteLookup)))
            {
                _overwriteLookup = {
                    "none":0,
                    "all":1,
                    "auto":2,
                    "concurrent":3,
                    "allOnStart":4,
                    "preexisting":5,
                    "true":1,
                    "false":0
                };
                ticker.addEventListener("enterFrame", _dumpGarbage, false, -1, true);
            };
            this.ratio = 0;
            this.target = _arg_1;
            this._ease = defaultEase;
            this._overwrite = (("overwrite" in this.vars) ? ((typeof(this.vars.overwrite) === "number") ? (this.vars.overwrite >> 0) : _overwriteLookup[this.vars.overwrite]) : _overwriteLookup[defaultOverwrite]);
            if (((this.target is Array) && (typeof(this.target[0]) === "object")))
            {
                this._targets = this.target.concat();
                this._propLookup = [];
                this._siblings = [];
                _local_4 = this._targets.length;
                while (--_local_4 > -1)
                {
                    this._siblings[_local_4] = _register(this._targets[_local_4], this, false);
                    if (this._overwrite == 1)
                    {
                        if (this._siblings[_local_4].length > 1)
                        {
                            _applyOverwrite(this._targets[_local_4], this, null, 1, this._siblings[_local_4]);
                        };
                    };
                };
            }
            else
            {
                this._propLookup = {};
                this._siblings = _tweenLookup[_arg_1];
                if (this._siblings == null)
                {
                    this._siblings = (_tweenLookup[_arg_1] = [this]);
                }
                else
                {
                    this._siblings[this._siblings.length] = this;
                    if (this._overwrite == 1)
                    {
                        _applyOverwrite(_arg_1, this, null, 1, this._siblings);
                    };
                };
            };
            if (((this.vars.immediateRender) || (((_arg_2 == 0) && (_delay == 0)) && (!(this.vars.immediateRender == false)))))
            {
                this.render(-(_delay), false, true);
            };
        }

        public static function fromTo(_arg_1:Object, _arg_2:Number, _arg_3:Object, _arg_4:Object):TweenLite
        {
            _arg_4 = _prepVars(_arg_4, true);
            _arg_3 = _prepVars(_arg_3);
            _arg_4.startAt = _arg_3;
            _arg_4.immediateRender = ((!(_arg_4.immediateRender == false)) && (!(_arg_3.immediateRender == false)));
            return (new TweenLite(_arg_1, _arg_2, _arg_4));
        }

        public static function getTweensOf(_arg_1:*, _arg_2:Boolean=false):Array
        {
            var _local_3:int;
            var _local_4:Array;
            var _local_5:int;
            var _local_6:TweenLite;
            if ((((_arg_1 is Array) && (!(typeof(_arg_1[0]) == "string"))) && (!(typeof(_arg_1[0]) == "number"))))
            {
                _local_3 = _arg_1.length;
                _local_4 = [];
                while (--_local_3 > -1)
                {
                    _local_4 = _local_4.concat(getTweensOf(_arg_1[_local_3], _arg_2));
                };
                _local_3 = _local_4.length;
                while (--_local_3 > -1)
                {
                    _local_6 = _local_4[_local_3];
                    _local_5 = _local_3;
                    while (--_local_5 > -1)
                    {
                        if (_local_6 === _local_4[_local_5])
                        {
                            _local_4.splice(_local_3, 1);
                        };
                    };
                };
            }
            else
            {
                _local_4 = _register(_arg_1).concat();
                _local_3 = _local_4.length;
                while (--_local_3 > -1)
                {
                    if (((_local_4[_local_3]._gc) || ((_arg_2) && (!(_local_4[_local_3].isActive())))))
                    {
                        _local_4.splice(_local_3, 1);
                    };
                };
            };
            return (_local_4);
        }

        protected static function _register(_arg_1:Object, _arg_2:TweenLite=null, _arg_3:Boolean=false):Array
        {
            var _local_4:int;
            var _local_5:Array = _tweenLookup[_arg_1];
            if (_local_5 == null)
            {
                _local_5 = (_tweenLookup[_arg_1] = []);
            };
            if (_arg_2)
            {
                _local_4 = _local_5.length;
                _local_5[_local_4] = _arg_2;
                if (_arg_3)
                {
                    while (--_local_4 > -1)
                    {
                        if (_local_5[_local_4] === _arg_2)
                        {
                            _local_5.splice(_local_4, 1);
                        };
                    };
                };
            };
            return (_local_5);
        }

        protected static function _applyOverwrite(_arg_1:Object, _arg_2:TweenLite, _arg_3:Object, _arg_4:int, _arg_5:Array):Boolean
        {
            var _local_6:int;
            var _local_7:Boolean;
            var _local_8:TweenLite;
            var _local_9:Number;
            var _local_10:int;
            var _local_13:int;
            var _local_15:*;
            if (((_arg_4 == 1) || (_arg_4 >= 4)))
            {
                _local_10 = _arg_5.length;
                _local_6 = 0;
                while (_local_6 < _local_10)
                {
                    _local_8 = _arg_5[_local_6];
                    if (_local_8 != _arg_2)
                    {
                        if ((!(_local_8._gc)))
                        {
                            if (_local_8._enabled(false, false))
                            {
                                _local_7 = true;
                            };
                        };
                    }
                    else
                    {
                        if (_arg_4 == 5) break;
                    };
                    _local_6++;
                };
                return (_local_7);
            };
            var _local_11:Number = (_arg_2._startTime + 1E-10);
            var _local_12:Array = [];
            var _local_14:* = (_arg_2._duration == 0);
            _local_6 = _arg_5.length;
            while (--_local_6 > -1)
            {
                _local_8 = _arg_5[_local_6];
                if ((!(((_local_8 === _arg_2) || (_local_8._gc)) || (_local_8._paused))))
                {
                    if (_local_8._timeline != _arg_2._timeline)
                    {
                        _local_9 = ((_local_9) || (_checkOverlap(_arg_2, 0, _local_14)));
                        if (_checkOverlap(_local_8, _local_9, _local_14) === 0)
                        {
                            _local_15 = _local_13++;
                            _local_12[_local_15] = _local_8;
                        };
                    }
                    else
                    {
                        if (_local_8._startTime <= _local_11)
                        {
                            if ((_local_8._startTime + (_local_8.totalDuration() / _local_8._timeScale)) > _local_11)
                            {
                                if ((!(((_local_14) || (!(_local_8._initted))) && ((_local_11 - _local_8._startTime) <= 2E-10))))
                                {
                                    _local_15 = _local_13++;
                                    _local_12[_local_15] = _local_8;
                                };
                            };
                        };
                    };
                };
            };
            _local_6 = _local_13;
            while (--_local_6 > -1)
            {
                _local_8 = _local_12[_local_6];
                if (_arg_4 == 2)
                {
                    if (_local_8._kill(_arg_3, _arg_1))
                    {
                        _local_7 = true;
                    };
                };
                if (((!(_arg_4 === 2)) || ((!(_local_8._firstPT)) && (_local_8._initted))))
                {
                    if (_local_8._enabled(false, false))
                    {
                        _local_7 = true;
                    };
                };
            };
            return (_local_7);
        }

        public static function killTweensOf(_arg_1:*, _arg_2:*=false, _arg_3:Object=null):void
        {
            if (typeof(_arg_2) === "object")
            {
                _arg_3 = _arg_2;
                _arg_2 = false;
            };
            var _local_4:Array = TweenLite.getTweensOf(_arg_1, _arg_2);
            var _local_5:int = _local_4.length;
            while (--_local_5 > -1)
            {
                _local_4[_local_5]._kill(_arg_3, _arg_1);
            };
        }

        protected static function _prepVars(_arg_1:Object, _arg_2:Boolean=false):Object
        {
            if (_arg_1._isGSVars)
            {
                _arg_1 = _arg_1.vars;
            };
            if (((_arg_2) && (!("immediateRender" in _arg_1))))
            {
                _arg_1.immediateRender = true;
            };
            return (_arg_1);
        }

        public static function delayedCall(_arg_1:Number, _arg_2:Function, _arg_3:Array=null, _arg_4:Boolean=false):TweenLite
        {
            return (new TweenLite(_arg_2, 0, {
                "delay":_arg_1,
                "onComplete":_arg_2,
                "onCompleteParams":_arg_3,
                "onReverseComplete":_arg_2,
                "onReverseCompleteParams":_arg_3,
                "immediateRender":false,
                "useFrames":_arg_4,
                "overwrite":0
            }));
        }

        public static function from(_arg_1:Object, _arg_2:Number, _arg_3:Object):TweenLite
        {
            _arg_3 = _prepVars(_arg_3, true);
            _arg_3.runBackwards = true;
            return (new TweenLite(_arg_1, _arg_2, _arg_3));
        }

        public static function killDelayedCallsTo(_arg_1:Function):void
        {
            killTweensOf(_arg_1);
        }

        public static function set(_arg_1:Object, _arg_2:Object):TweenLite
        {
            return (new TweenLite(_arg_1, 0, _arg_2));
        }

        private static function _dumpGarbage(_arg_1:Event):void
        {
            var _local_2:int;
            var _local_3:Array;
            var _local_4:Object;
            if (((_rootFrame / 60) >> 0) === (_rootFrame / 60))
            {
                for (_local_4 in _tweenLookup)
                {
                    _local_3 = _tweenLookup[_local_4];
                    _local_2 = _local_3.length;
                    while (--_local_2 > -1)
                    {
                        if (_local_3[_local_2]._gc)
                        {
                            _local_3.splice(_local_2, 1);
                        };
                    };
                    if (_local_3.length === 0)
                    {
                        delete _tweenLookup[_local_4];
                    };
                };
            };
        }

        public static function to(_arg_1:Object, _arg_2:Number, _arg_3:Object):TweenLite
        {
            return (new TweenLite(_arg_1, _arg_2, _arg_3));
        }

        private static function _checkOverlap(_arg_1:Animation, _arg_2:Number, _arg_3:Boolean):Number
        {
            var _local_4:SimpleTimeline = _arg_1._timeline;
            var _local_5:Number = _local_4._timeScale;
            var _local_6:Number = _arg_1._startTime;
            var _local_7:Number = 1E-10;
            while (_local_4._timeline)
            {
                _local_6 = (_local_6 + _local_4._startTime);
                _local_5 = (_local_5 * _local_4._timeScale);
                if (_local_4._paused)
                {
                    return (-100);
                };
                _local_4 = _local_4._timeline;
            };
            _local_6 = (_local_6 / _local_5);
            return ((_local_6 > _arg_2) ? (_local_6 - _arg_2) : ((((_arg_3) && (_local_6 == _arg_2)) || ((!(_arg_1._initted)) && ((_local_6 - _arg_2) < (2 * _local_7)))) ? _local_7 : (((_local_6 = (_local_6 + ((_arg_1.totalDuration() / _arg_1._timeScale) / _local_5))) > (_arg_2 + _local_7)) ? 0 : ((_local_6 - _arg_2) - _local_7))));
        }


        protected function _initProps(_arg_1:Object, _arg_2:Object, _arg_3:Array, _arg_4:Object):Boolean
        {
            var _local_5:String;
            var _local_6:int;
            var _local_7:Boolean;
            var _local_8:Object;
            var _local_9:Object;
            var _local_10:Object = this.vars;
            if (_arg_1 == null)
            {
                return (false);
            };
            for (_local_5 in _local_10)
            {
                _local_9 = _local_10[_local_5];
                if ((_local_5 in _reservedProps))
                {
                    if ((_local_9 is Array))
                    {
                        if (_local_9.join("").indexOf("{self}") !== -1)
                        {
                            _local_10[_local_5] = _swapSelfInParams((_local_9 as Array));
                        };
                    };
                }
                else
                {
                    if (((_local_5 in _plugins) && ((_local_8 = new (_plugins[_local_5])())._onInitTween(_arg_1, _local_9, this))))
                    {
                        this._firstPT = new PropTween(_local_8, "setRatio", 0, 1, _local_5, true, this._firstPT, _local_8._priority);
                        _local_6 = _local_8._overwriteProps.length;
                        while (--_local_6 > -1)
                        {
                            _arg_2[_local_8._overwriteProps[_local_6]] = this._firstPT;
                        };
                        if (((_local_8._priority) || ("_onInitAllProps" in _local_8)))
                        {
                            _local_7 = true;
                        };
                        if ((("_onDisable" in _local_8) || ("_onEnable" in _local_8)))
                        {
                            this._notifyPluginsOfEnabled = true;
                        };
                    }
                    else
                    {
                        this._firstPT = (_arg_2[_local_5] = new PropTween(_arg_1, _local_5, 0, 1, _local_5, false, this._firstPT));
                        this._firstPT.s = ((this._firstPT.f) ? _arg_1[(((_local_5.indexOf("set")) || (!(("get" + _local_5.substr(3)) in _arg_1))) ? _local_5 : ("get" + _local_5.substr(3)))]() : Number(_arg_1[_local_5]));
                        this._firstPT.c = ((typeof(_local_9) === "number") ? (Number(_local_9) - this._firstPT.s) : (((typeof(_local_9) === "string") && (_local_9.charAt(1) === "=")) ? (int((_local_9.charAt(0) + "1")) * Number(_local_9.substr(2))) : ((Number(_local_9)) || (0))));
                    };
                };
            };
            if (_arg_4)
            {
                if (this._kill(_arg_4, _arg_1))
                {
                    return (this._initProps(_arg_1, _arg_2, _arg_3, _arg_4));
                };
            };
            if (this._overwrite > 1)
            {
                if (this._firstPT != null)
                {
                    if (_arg_3.length > 1)
                    {
                        if (_applyOverwrite(_arg_1, this, _arg_2, this._overwrite, _arg_3))
                        {
                            this._kill(_arg_2, _arg_1);
                            return (this._initProps(_arg_1, _arg_2, _arg_3, _arg_4));
                        };
                    };
                };
            };
            return (_local_7);
        }

        override public function _enabled(_arg_1:Boolean, _arg_2:Boolean=false):Boolean
        {
            var _local_3:int;
            if (((_arg_1) && (_gc)))
            {
                if (this._targets)
                {
                    _local_3 = this._targets.length;
                    while (--_local_3 > -1)
                    {
                        this._siblings[_local_3] = _register(this._targets[_local_3], this, true);
                    };
                }
                else
                {
                    this._siblings = _register(this.target, this, true);
                };
            };
            super._enabled(_arg_1, _arg_2);
            if (this._notifyPluginsOfEnabled)
            {
                if (this._firstPT != null)
                {
                    return (_onPluginEvent(((_arg_1) ? "_onEnable" : "_onDisable"), this));
                };
            };
            return (false);
        }

        override public function render(_arg_1:Number, _arg_2:Boolean=false, _arg_3:Boolean=false):void
        {
            var _local_4:Boolean;
            var _local_5:String;
            var _local_6:PropTween;
            var _local_7:Number;
            var _local_8:Number;
            var _local_10:*;
            var _local_9:Number = _time;
            if (_arg_1 >= _duration)
            {
                _totalTime = (_time = _duration);
                this.ratio = ((this._ease._calcEnd) ? this._ease.getRatio(1) : 1);
                if ((!(_reversed)))
                {
                    _local_4 = true;
                    _local_5 = "onComplete";
                };
                if (_duration == 0)
                {
                    _local_7 = _rawPrevTime;
                    if (_startTime === _timeline._duration)
                    {
                        _arg_1 = 0;
                    };
                    if ((((_arg_1 === 0) || (_local_7 < 0)) || (_local_7 === _tinyNum)))
                    {
                        if (_local_7 !== _arg_1)
                        {
                            _arg_3 = true;
                            if (((_local_7 > 0) && (!(_local_7 === _tinyNum))))
                            {
                                _local_5 = "onReverseComplete";
                            };
                        };
                    };
                    _rawPrevTime = (_local_7 = ((((!(_arg_2)) || (!(_arg_1 === 0))) || (_rawPrevTime === _arg_1)) ? _arg_1 : _tinyNum));
                };
            }
            else
            {
                if (_arg_1 < 1E-7)
                {
                    _totalTime = (_time = 0);
                    this.ratio = ((this._ease._calcEnd) ? this._ease.getRatio(0) : 0);
                    if (((!(_local_9 === 0)) || (((_duration === 0) && (_rawPrevTime > 0)) && (!(_rawPrevTime === _tinyNum)))))
                    {
                        _local_5 = "onReverseComplete";
                        _local_4 = _reversed;
                    };
                    if (_arg_1 < 0)
                    {
                        _active = false;
                        if (_duration == 0)
                        {
                            if (_rawPrevTime >= 0)
                            {
                                _arg_3 = true;
                            };
                            _rawPrevTime = (_local_7 = ((((!(_arg_2)) || (!(_arg_1 === 0))) || (_rawPrevTime === _arg_1)) ? _arg_1 : _tinyNum));
                        };
                    }
                    else
                    {
                        if ((!(_initted)))
                        {
                            _arg_3 = true;
                        };
                    };
                }
                else
                {
                    _totalTime = (_time = _arg_1);
                    if (this._easeType)
                    {
                        _local_8 = (_arg_1 / _duration);
                        if (((this._easeType == 1) || ((this._easeType == 3) && (_local_8 >= 0.5))))
                        {
                            _local_8 = (1 - _local_8);
                        };
                        if (this._easeType == 3)
                        {
                            _local_8 = (_local_8 * 2);
                        };
                        if (this._easePower == 1)
                        {
                            _local_8 = (_local_8 * _local_8);
                        }
                        else
                        {
                            if (this._easePower == 2)
                            {
                                _local_8 = (_local_8 * (_local_8 * _local_8));
                            }
                            else
                            {
                                if (this._easePower == 3)
                                {
                                    _local_8 = (_local_8 * ((_local_8 * _local_8) * _local_8));
                                }
                                else
                                {
                                    if (this._easePower == 4)
                                    {
                                        _local_8 = (_local_8 * (((_local_8 * _local_8) * _local_8) * _local_8));
                                    };
                                };
                            };
                        };
                        if (this._easeType == 1)
                        {
                            this.ratio = (1 - _local_8);
                        }
                        else
                        {
                            if (this._easeType == 2)
                            {
                                this.ratio = _local_8;
                            }
                            else
                            {
                                if ((_arg_1 / _duration) < 0.5)
                                {
                                    this.ratio = (_local_8 / 2);
                                }
                                else
                                {
                                    this.ratio = (1 - (_local_8 / 2));
                                };
                            };
                        };
                    }
                    else
                    {
                        this.ratio = this._ease.getRatio((_arg_1 / _duration));
                    };
                };
            };
            if (((_time == _local_9) && (!(_arg_3))))
            {
                return;
            };
            if ((!(_initted)))
            {
                this._init();
                if (((!(_initted)) || (_gc)))
                {
                    return;
                };
                if (((_time) && (!(_local_4))))
                {
                    this.ratio = this._ease.getRatio((_time / _duration));
                }
                else
                {
                    if (((_local_4) && (this._ease._calcEnd)))
                    {
                        this.ratio = this._ease.getRatio(((_time === 0) ? 0 : 1));
                    };
                };
            };
            if ((!(_active)))
            {
                if ((((!(_paused)) && (!(_time === _local_9))) && (_arg_1 >= 0)))
                {
                    _active = true;
                };
            };
            if (_local_9 == 0)
            {
                if (this._startAt != null)
                {
                    if (_arg_1 >= 0)
                    {
                        this._startAt.render(_arg_1, _arg_2, _arg_3);
                    }
                    else
                    {
                        if ((!(_local_5)))
                        {
                            _local_5 = "_dummyGS";
                        };
                    };
                };
                if (vars.onStart)
                {
                    if (((!(_time == 0)) || (_duration == 0)))
                    {
                        if ((!(_arg_2)))
                        {
                            vars.onStart.apply(null, vars.onStartParams);
                        };
                    };
                };
            };
            _local_6 = this._firstPT;
            while (_local_6)
            {
                if (_local_6.f)
                {
                    _local_10 = _local_6.t;
                    var _local_11:* = _local_10;
                    (_local_11[_local_6.p](((_local_6.c * this.ratio) + _local_6.s)));
                }
                else
                {
                    _local_6.t[_local_6.p] = ((_local_6.c * this.ratio) + _local_6.s);
                };
                _local_6 = _local_6._next;
            };
            if (_onUpdate != null)
            {
                if ((((_arg_1 < 0) && (!(this._startAt == null))) && (!(_startTime == 0))))
                {
                    this._startAt.render(_arg_1, _arg_2, _arg_3);
                };
                if ((!(_arg_2)))
                {
                    if (((!(_time === _local_9)) || (_local_4)))
                    {
                        _onUpdate.apply(null, vars.onUpdateParams);
                    };
                };
            };
            if (_local_5)
            {
                if ((!(_gc)))
                {
                    if (((((_arg_1 < 0) && (!(this._startAt == null))) && (_onUpdate == null)) && (!(_startTime == 0))))
                    {
                        this._startAt.render(_arg_1, _arg_2, _arg_3);
                    };
                    if (_local_4)
                    {
                        if (_timeline.autoRemoveChildren)
                        {
                            this._enabled(false, false);
                        };
                        _active = false;
                    };
                    if ((!(_arg_2)))
                    {
                        if (vars[_local_5])
                        {
                            vars[_local_5].apply(null, vars[(_local_5 + "Params")]);
                        };
                    };
                    if ((((_duration === 0) && (_rawPrevTime === _tinyNum)) && (!(_local_7 === _tinyNum))))
                    {
                        _rawPrevTime = 0;
                    };
                };
            };
        }

        protected function _init():void
        {
            var _local_1:int;
            var _local_2:Boolean;
            var _local_3:PropTween;
            var _local_4:String;
            var _local_5:Object;
            var _local_6:Boolean = vars.immediateRender;
            if (vars.startAt)
            {
                if (this._startAt != null)
                {
                    this._startAt.render(-1, true);
                };
                vars.startAt.overwrite = 0;
                vars.startAt.immediateRender = true;
                this._startAt = new TweenLite(this.target, 0, vars.startAt);
                if (_local_6)
                {
                    if (_time > 0)
                    {
                        this._startAt = null;
                    }
                    else
                    {
                        if (_duration !== 0)
                        {
                            return;
                        };
                    };
                };
            }
            else
            {
                if (((vars.runBackwards) && (!(_duration === 0))))
                {
                    if (this._startAt != null)
                    {
                        this._startAt.render(-1, true);
                        this._startAt = null;
                    }
                    else
                    {
                        _local_5 = {};
                        for (_local_4 in vars)
                        {
                            if ((!(_local_4 in _reservedProps)))
                            {
                                _local_5[_local_4] = vars[_local_4];
                            };
                        };
                        _local_5.overwrite = 0;
                        _local_5.data = "isFromStart";
                        this._startAt = TweenLite.to(this.target, 0, _local_5);
                        if ((!(_local_6)))
                        {
                            this._startAt.render(-1, true);
                        }
                        else
                        {
                            if (_time === 0)
                            {
                                return;
                            };
                        };
                    };
                };
            };
            if ((vars.ease is Ease))
            {
                this._ease = ((vars.easeParams is Array) ? vars.ease.config.apply(vars.ease, vars.easeParams) : vars.ease);
            }
            else
            {
                if (typeof(vars.ease) === "function")
                {
                    this._ease = new Ease(vars.ease, vars.easeParams);
                }
                else
                {
                    this._ease = defaultEase;
                };
            };
            this._easeType = this._ease._type;
            this._easePower = this._ease._power;
            this._firstPT = null;
            if (this._targets)
            {
                _local_1 = this._targets.length;
                while (--_local_1 > -1)
                {
                    if (this._initProps(this._targets[_local_1], (this._propLookup[_local_1] = {}), this._siblings[_local_1], ((this._overwrittenProps) ? this._overwrittenProps[_local_1] : null)))
                    {
                        _local_2 = true;
                    };
                };
            }
            else
            {
                _local_2 = this._initProps(this.target, this._propLookup, this._siblings, this._overwrittenProps);
            };
            if (_local_2)
            {
                _onPluginEvent("_onInitAllProps", this);
            };
            if (this._overwrittenProps)
            {
                if (this._firstPT == null)
                {
                    if (typeof(this.target) !== "function")
                    {
                        this._enabled(false, false);
                    };
                };
            };
            if (vars.runBackwards)
            {
                _local_3 = this._firstPT;
                while (_local_3)
                {
                    _local_3.s = (_local_3.s + _local_3.c);
                    _local_3.c = -(_local_3.c);
                    _local_3 = _local_3._next;
                };
            };
            _onUpdate = vars.onUpdate;
            _initted = true;
        }

        override public function invalidate():*
        {
            if (this._notifyPluginsOfEnabled)
            {
                _onPluginEvent("_onDisable", this);
            };
            this._firstPT = null;
            this._overwrittenProps = null;
            _onUpdate = null;
            this._startAt = null;
            _initted = (_active = (this._notifyPluginsOfEnabled = false));
            this._propLookup = ((this._targets) ? {} : []);
            return (this);
        }

        override public function _kill(_arg_1:Object=null, _arg_2:Object=null):Boolean
        {
            var _local_3:int;
            var _local_4:Object;
            var _local_5:String;
            var _local_6:PropTween;
            var _local_7:Object;
            var _local_8:Boolean;
            var _local_9:Object;
            var _local_10:Boolean;
            if (_arg_1 === "all")
            {
                _arg_1 = null;
            };
            if (_arg_1 == null)
            {
                if (((_arg_2 == null) || (_arg_2 == this.target)))
                {
                    return (this._enabled(false, false));
                };
            };
            _arg_2 = (((_arg_2) || (this._targets)) || (this.target));
            if (((_arg_2 is Array) && (typeof(_arg_2[0]) === "object")))
            {
                _local_3 = _arg_2.length;
                while (--_local_3 > -1)
                {
                    if (this._kill(_arg_1, _arg_2[_local_3]))
                    {
                        _local_8 = true;
                    };
                };
            }
            else
            {
                if (this._targets)
                {
                    _local_3 = this._targets.length;
                    while (--_local_3 > -1)
                    {
                        if (_arg_2 === this._targets[_local_3])
                        {
                            _local_7 = ((this._propLookup[_local_3]) || ({}));
                            this._overwrittenProps = ((this._overwrittenProps) || ([]));
                            _local_4 = (this._overwrittenProps[_local_3] = ((_arg_1) ? ((this._overwrittenProps[_local_3]) || ({})) : "all"));
                            break;
                        };
                    };
                }
                else
                {
                    if (_arg_2 !== this.target)
                    {
                        return (false);
                    };
                    _local_7 = this._propLookup;
                    _local_4 = (this._overwrittenProps = ((_arg_1) ? ((this._overwrittenProps) || ({})) : "all"));
                };
                if (_local_7)
                {
                    _local_9 = ((_arg_1) || (_local_7));
                    _local_10 = ((((!(_arg_1 == _local_4)) && (!(_local_4 == "all"))) && (!(_arg_1 == _local_7))) && ((!(typeof(_arg_1) == "object")) || (!(_arg_1._tempKill == true))));
                    for (_local_5 in _local_9)
                    {
                        _local_6 = _local_7[_local_5];
                        if (_local_6 != null)
                        {
                            if (((_local_6.pg) && (_local_6.t._kill(_local_9))))
                            {
                                _local_8 = true;
                            };
                            if (((!(_local_6.pg)) || (_local_6.t._overwriteProps.length === 0)))
                            {
                                if (_local_6._prev)
                                {
                                    _local_6._prev._next = _local_6._next;
                                }
                                else
                                {
                                    if (_local_6 == this._firstPT)
                                    {
                                        this._firstPT = _local_6._next;
                                    };
                                };
                                if (_local_6._next)
                                {
                                    _local_6._next._prev = _local_6._prev;
                                };
                                _local_6._next = (_local_6._prev = null);
                            };
                            delete _local_7[_local_5];
                        };
                        if (_local_10)
                        {
                            _local_4[_local_5] = 1;
                        };
                    };
                    if (((this._firstPT == null) && (_initted)))
                    {
                        this._enabled(false, false);
                    };
                };
            };
            return (_local_8);
        }


    }
}//package com.greensock

