using System;
using System.Runtime.InteropServices;

namespace DWScript.Interop
{
	[ComImport]
	[Guid("3A1E2229-26C0-436C-97D7-08C46CF86995")]
	[InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
	public interface ICOMEnumerator
	{
		[return: MarshalAs(UnmanagedType.IUnknown)]
		object GetCurrent();
		[return: MarshalAs(UnmanagedType.I1)]
		bool MoveNext();
	}
}
