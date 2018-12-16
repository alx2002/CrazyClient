


//com.company.assembleegameclient.objects.thrown.BitmapParticle

package com.company.assembleegameclient.objects.thrown
{


	import com.company.assembleegameclient.map.Camera;
	import com.company.assembleegameclient.map.Square;
	import com.company.assembleegameclient.objects.BasicObject;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.ui.options.Options;
	import com.company.util.GraphicsUtil;
	import flash.display.BitmapData;
	import flash.display.GraphicsBitmapFill;
	import flash.display.GraphicsPath;
	import flash.display.IGraphicsData;
	import flash.geom.Matrix;

	public class BitmapParticle extends BasicObject
	{

		protected var bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill(null, null, false, false);
		protected var path_:GraphicsPath = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS, null);
		protected var vS_:Vector.<Number> = new Vector.<Number>();
		protected var fillMatrix_:Matrix = new Matrix();
		public var size_:int;
		public var _bitmapData:BitmapData;
		protected var _rotationDelta:Number = 0;
		public var _rotation:Number = 0;

		public function BitmapParticle(_arg_1:BitmapData, _arg_2:Number)
		{
			hasShadow_ = false;
			objectId_ = getNextFakeObjectId();
			this._bitmapData = _arg_1;
			z_ = _arg_2;
		}

		public function moveTo(_arg_1:Number, _arg_2:Number):Boolean
		{
			var _local_3:Square;
			_local_3 = map_.getSquare(_arg_1, _arg_2);
			if ((!(_local_3)))
			{
				return (false);
			}
			;
			x_ = _arg_1;
			y_ = _arg_2;
			square_ = _local_3;
			return (true);
		}

		public function setSize(_arg_1:int):void
		{
			this.size_ = ((_arg_1 / 100) * 5);
		}

		override public function drawShadow(_arg_1:Vector.<IGraphicsData>, _arg_2:Camera, _arg_3:int):void
		{
		}

		override public function draw(_arg_1:Vector.<IGraphicsData>, _arg_2:Camera, _arg_3:int):void
		{
			var _local_4:BitmapData;
			var _local_5:int;
			var _local_6:int;
			if (((!(Options.hidden)) && (Parameters.lowCPUMode)))
			{
				return;
			}
			;
			try
			{
				_local_4 = this._bitmapData;
				_local_5 = _local_4.width;
				_local_6 = _local_4.height;
				if (((!(_local_5)) || (!(_local_6))))
				{
					return;
				}
				;
				this.vS_.length = 0;
				this.vS_.push((posS_[3] - (_local_5 / 2)), (posS_[4] - (_local_6 / 2)), (posS_[3] + (_local_5 / 2)), (posS_[4] - (_local_6 / 2)), (posS_[3] + (_local_5 / 2)), (posS_[4] + (_local_6 / 2)), (posS_[3] - (_local_5 / 2)), (posS_[4] + (_local_6 / 2)));
				this.path_.data = this.vS_;
				this.bitmapFill_.bitmapData = _local_4;
				this.fillMatrix_.identity();
				if (((this._rotation) || (this._rotationDelta)))
				{
					if (this._rotationDelta)
					{
						this._rotation = (this._rotation + this._rotationDelta);
					}
					;
					this.fillMatrix_.translate((-(_local_5) / 2), (-(_local_6) / 2));
					this.fillMatrix_.rotate(this._rotation);
					this.fillMatrix_.translate((_local_5 / 2), (_local_6 / 2));
				}
				;
				this.fillMatrix_.translate(this.vS_[0], this.vS_[1]);
				this.bitmapFill_.matrix = this.fillMatrix_;
				_arg_1.push(this.bitmapFill_);
				_arg_1.push(this.bitmapFill_);
				_arg_1.push(this.path_);
				_arg_1.push(GraphicsUtil.END_FILL);
			}
			catch (error:Error)
			{
			}
			;
		}

	}
}//package com.company.assembleegameclient.objects.thrown

