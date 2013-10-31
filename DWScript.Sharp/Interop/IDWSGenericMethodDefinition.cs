using System;
using System.Runtime.InteropServices;

namespace DWScript.Interop
{
	[ComImport]
	[Guid("753549A4-82D4-4C45-ACD0-D25A4A18EFA3")]
	[InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
	public interface IDWSGenericMethodDefinition
	{
		[return: MarshalAs(UnmanagedType.LPWStr)]
		string GetName();

		[return: MarshalAs(UnmanagedType.Interface)]
		ICOMEnumerable GetArgs();

		[return: MarshalAs(UnmanagedType.LPWStr)]
		string GetReturnTypeName();

		IntPtr GetCallback();

		[return: MarshalAs(UnmanagedType.I1)]
		bool GetIsOverloaded();
	}


}
