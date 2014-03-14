using System;
using System.Diagnostics;

namespace DWScript
{
	[DebuggerDisplay("{ToString()}")]
	public class DWSParameterDefinition : DWSFieldDefinition
	{
		private string _defaultValue;

		public DWSParameterDefinition(string name, string typeName)
			: base(name, typeName)
		{

		}

		public override bool IsInOut { get; set; }
		public override bool HasDefaultValue { get; set; }
		public override string DefaultValue
		{
			get { return _defaultValue; }
			set
			{
				if (value != null)
					this.HasDefaultValue = true;
				_defaultValue = value;
			}
		}

		public override string ToString()
		{
			if (this.HasDefaultValue)
			{
				return string.Format("{0}: {1} = '{2}'", Name, TypeName, DefaultValue);
			}
			else
			{
				return string.Format("{0}: {1}", Name, TypeName);
			}
		}

	}
}
