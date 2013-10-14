using System;
using System.Collections.Generic;
using DWScript.Interop;

namespace DWScript
{
	public class DWSTypeDefinition : IDWSGenericTypeDefinition
	{
		private string _name;
		private DelphiArray<DWSFieldDefinition> _fields;

		public DWSTypeDefinition(string name)
		{
			_name = name;
			_fields = new DelphiArray<DWSFieldDefinition>();
		}

		public virtual string Name
		{
			get { return _name; }
		}

		public IList<DWSFieldDefinition> Fields
		{
			get
			{
				return _fields;
			}
		}


		string IDWSGenericTypeDefinition.GetName()
		{
			return this.Name;
		}

		ICOMEnumerable IDWSGenericTypeDefinition.GetFields()
		{
			return _fields;
		}

	}
}
