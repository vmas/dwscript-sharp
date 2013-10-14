using System;
using System.Runtime.InteropServices;

namespace DWScript.Interop
{
	[ComImport]
	[Guid("F406C38C-9E16-44FA-A34B-025CFA23BD52")]
	[InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
	public interface IDWSGenericArrayDefinition
	{
		[return: MarshalAs(UnmanagedType.LPWStr)]
		string GetName();
		[return: MarshalAs(UnmanagedType.LPWStr)]
		string GetElementsTypeName();
		[return: MarshalAs(UnmanagedType.I1)]
		bool GetIsDynamic();
		int GetLowBound();
		int GetHighBound();
	}
}
