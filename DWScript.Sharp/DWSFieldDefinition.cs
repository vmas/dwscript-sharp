using System;
using System.Diagnostics;
using DWScript.Interop;

namespace DWScript
{
	[DebuggerDisplay("{GetName()}: {GetTypeName()}")]
	public class DWSFieldDefinition : IDWSFieldDefinition
	{
		private string _name;
		private string _typeName;

		public DWSFieldDefinition(string name, string typeName)
		{
			_name = name;
			_typeName = typeName;
		}

		public string Name
		{
			get { return _name; }
		}

		public string TypeName
		{
			get { return _typeName; }
		}

		public string GetName()
		{
			return _name;
		}

		public string GetTypeName()
		{
			return _typeName;
		}

		public virtual bool GetHasDefaultValue()
		{
			return false;
		}

		public virtual string GetDefaultValue()
		{
			throw new NotSupportedException();
		}
	}
}
