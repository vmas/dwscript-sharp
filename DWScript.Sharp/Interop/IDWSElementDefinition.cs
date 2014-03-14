using System;
using System.Runtime.InteropServices;

namespace DWScript.Interop
{
	[ComImport]
	[Guid("28CF73E3-175E-45DE-97DF-EFF1F8D9B52C")]
	[InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
	public interface IDWSElementDefinition
	{
		[return: MarshalAs(UnmanagedType.LPWStr)]
		string GetName();
		int GetValue();
	}
}
