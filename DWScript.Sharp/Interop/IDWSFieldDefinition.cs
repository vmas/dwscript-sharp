using System;
using System.Runtime.InteropServices;

namespace DWScript.Interop
{
	[ComImport]
	[Guid("B6445511-CC01-45FC-9B28-434F7FDFE0C3")]
	[InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
	public interface IDWSFieldDefinition
	{
		[return: MarshalAs(UnmanagedType.LPWStr)]
		string GetName();
		[return: MarshalAs(UnmanagedType.LPWStr)]
		string GetTypeName();
		[return: MarshalAs(UnmanagedType.I1)]
		bool GetHasDefaultValue();
		[return: MarshalAs(UnmanagedType.LPWStr)]
		string GetDefaultValue();
		[return: MarshalAs(UnmanagedType.I4)]
		DWSVisibility GetModifier();
		[return: MarshalAs(UnmanagedType.I1)]
		bool GetIsVarParam();
	}
}
