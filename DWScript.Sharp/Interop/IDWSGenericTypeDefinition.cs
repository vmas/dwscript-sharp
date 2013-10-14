using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;

namespace DWScript.Interop
{
	[ComImport]
	[Guid("5FA48473-A1C0-4F40-BFAE-94A207115B09")]
	[InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
	public interface IDWSGenericTypeDefinition
	{
		[return: MarshalAs(UnmanagedType.LPWStr)]
		string GetName();

		[return: MarshalAs(UnmanagedType.Interface)]
		ICOMEnumerable GetFields();
	}
}
