using System;
using DWScript.Interop;

namespace DWScript
{
	public class DWSProgramContext
	{
		private IDWSFunctionCallInfo _info;

		public DWSProgramContext(IDWSFunctionCallInfo info)
		{
			_info = info;
		}

		public DWSValue CreateTypedValue(string typeName)
		{
			return new DWSValue(_info.CreateTypedValue(typeName));
		}
	}
}
