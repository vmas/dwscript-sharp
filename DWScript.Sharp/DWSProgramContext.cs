using System;
using DWScript.Interop;

namespace DWScript
{
	public class DWSProgramContext
	{
		private IDWSProgramInfo _info;

		public DWSProgramContext(IDWSProgramInfo info)
		{
			_info = info;
		}

		public DWSValue CreateTypedValue(string typeName)
		{
			return new DWSValue(_info.CreateTypedValue(typeName));
		}
	}
}
