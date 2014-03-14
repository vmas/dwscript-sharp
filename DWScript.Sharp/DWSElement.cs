using System;
using System.Diagnostics;
using DWScript.Interop;

namespace DWScript
{
	[DebuggerDisplay("{GetName()}: {GetValue()}")]
	public class DWSElement : IDWSElementDefinition
	{
		private string _name;
		private int _value;

		public DWSElement(string name, int value)
		{
			if (name == null)
				throw new ArgumentNullException("name");

			_name = name;
			_value = value;
		}

		public DWSElement(DWSValue value)
		{
			if (value == null)
				throw new ArgumentNullException("value");


			_name = value.GetNativeValue().GetValueAsString();
			_value = (int)value.GetNativeValue().GetValueAsInt64();
		}

		public virtual string GetName()
		{
			return _name;
		}

		public int GetValue()
		{
			return _value;
		}
	}
}
