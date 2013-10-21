using System;
using System.Collections.Generic;
using System.Text;

namespace DWScript
{
	public class DWSArray : DWSValue
	{
		public DWSArray(DWSValue value)
			: base(value.GetNativeValue())
		{

		}

		public object this[int index]
		{
			get
			{
				return new DWSValue(GetNativeValue().GetElementByIndex(index)).Value;
			}
			set
			{
				var self = this.GetNativeValue();
				var v = new DWSValue(self.GetProgramInfo().CreateTypedValue(self.GetElementsTypeName()));
				v.Value = value;
				self.SetElementByIndex(index, v.GetNativeValue());
			}
		}

		public override DWSValue Get(string name)
		{
			int index;
			if (!int.TryParse(name, out index))
				throw new ArgumentOutOfRangeException("name");

			return new DWSValue(GetNativeValue().GetElementByIndex(index));
		}

		public override void Set(string name, DWSValue value)
		{
			int index;
			if (!int.TryParse(name, out index))
				throw new ArgumentOutOfRangeException("name");

			GetNativeValue().SetElementByIndex(index, value.GetNativeValue());
		}

		public void Resize(int size)
		{
			GetNativeValue().SetLength(size);
		}

		public int Length
		{
			get
			{
				return (int)GetNativeValue().GetField("Length").GetValueAsInt64();
			}
		}
	}
}
