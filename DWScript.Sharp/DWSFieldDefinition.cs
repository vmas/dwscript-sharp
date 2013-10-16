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
			this.Modifier = DWSVisibility.Public;
		}

		public string Name
		{
			get { return _name; }
		}

		public string TypeName
		{
			get { return _typeName; }
		}

		public virtual bool HasDefaultValue
		{
			get { return false; }
			set { }
		}

		public virtual string DefaultValue
		{
			get { throw new NotSupportedException(); }
			set { throw new NotSupportedException(); }
		}

		public DWSVisibility Modifier { get; set; }

		string IDWSFieldDefinition.GetName()
		{
			return _name;
		}

		string IDWSFieldDefinition.GetTypeName()
		{
			return _typeName;
		}

		bool IDWSFieldDefinition.GetHasDefaultValue()
		{
			return this.HasDefaultValue;
		}

		string IDWSFieldDefinition.GetDefaultValue()
		{
			return this.DefaultValue;
		}

		DWSVisibility IDWSFieldDefinition.GetModifier()
		{
			return this.Modifier;
		}
	}
}
