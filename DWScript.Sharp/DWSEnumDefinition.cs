using System;
using DWScript.Interop;
using System.Collections.Generic;

namespace DWScript
{
	public class DWSEnumDefinition : IDWSGenericTypeDefinition
	{
		private string _name;
		private DelphiArray<DWSElement> _args;

		public DWSEnumDefinition(string name)
		{
			if (name == null)
				throw new ArgumentNullException("name");

			_name = name;
			_args = new DelphiArray<DWSElement>();
		}

		public void Add(string name, int value)
		{
			_args.Add(new DWSElement(name, value));
		}

		public string GetName()
		{
			return _name;
		}

		public ICOMEnumerable GetFields()
		{
			return _args;
		}
	}
}
