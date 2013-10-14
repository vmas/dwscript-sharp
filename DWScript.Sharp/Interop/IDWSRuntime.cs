using System;
using System.Runtime.InteropServices;

namespace DWScript.Interop
{
	[ComImport]
	[Guid("564CEE22-7FEA-429A-A6F9-76FBAA94EA65")]
	[InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
	public interface IDWSRuntime
	{
		[return: MarshalAs(UnmanagedType.Interface)]
		IDWSContext NewContext();
	}
}
