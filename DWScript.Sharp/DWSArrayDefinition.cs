using System;
using DWScript.Interop;

namespace DWScript
{
	public class DWSArrayDefinition : IDWSGenericArrayDefinition
	{
		private string _name;
		private string _elementsTypeName;

		public DWSArrayDefinition(string name, string elementsTypeName)
		{
			_name = name;
			_elementsTypeName = elementsTypeName;
		}

		string IDWSGenericArrayDefinition.GetName()
		{
			return _name;
		}

		string IDWSGenericArrayDefinition.GetElementsTypeName()
		{
			return _elementsTypeName;
		}

		bool IDWSGenericArrayDefinition.GetIsDynamic()
		{
			return true;
		}

		int IDWSGenericArrayDefinition.GetLowBound()
		{
			throw new NotSupportedException();
		}

		int IDWSGenericArrayDefinition.GetHighBound()
		{
			throw new NotSupportedException();
		}
	}
}
