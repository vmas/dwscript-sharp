using System;
using System.Runtime.InteropServices;

namespace DWScript.Interop
{
	[ComImport]
	[Guid("BA4F1915-F9A0-460B-A4D3-1DC5FC9560B6")]
	[InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
	public interface ICOMEnumerable
	{
		ICOMEnumerator GetEnumerator();
	}
}
