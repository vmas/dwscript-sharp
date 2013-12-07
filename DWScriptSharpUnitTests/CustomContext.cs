using System;
using DWScript;
using DWScript.Interop;

namespace UnitTests
{
	class CustomContext : DWSContext
	{
		public Func<string, string> SourceGetter;
		
		public CustomContext(IDWSContext context)
			: base(context)
		{

		}

		protected override string OnInclude(string scriptName)
		{
			return SourceGetter != null ? SourceGetter(scriptName) : null;
		}

		

	}
}
