using System;
using System.Runtime.InteropServices;

namespace DWScript.Interop
{
	[ComImport]
	[Guid("C7A2EC25-7D05-41D8-B1C1-8E930B9F95FB")]
	[InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
	public interface IDelphiObject
	{
		void SetDebugCallback([MarshalAs(UnmanagedType.FunctionPtr)] DWSErrorCallbackDelegate callback);
	}
}
