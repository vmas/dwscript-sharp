using System;
using System.Runtime.InteropServices;

namespace DWScript.Interop
{
	[ComImport]
	[Guid("6CDAC2C3-0175-4566-AEFB-7F1B1E59E39C")]
	[InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
	public interface IDWSProgramInfo
	{
		[return: MarshalAs(UnmanagedType.Interface)]
		IDWSGenericTypeValue GetVariable([MarshalAs(UnmanagedType.LPWStr)] string name);
		[return: MarshalAs(UnmanagedType.Interface)]
		IDWSGenericTypeValue GetTypeReference([MarshalAs(UnmanagedType.LPWStr)] string name);
		void SetResultValue([MarshalAs(UnmanagedType.LPWStr)] string value);
		void SetResultValue(bool value);
		void SetResultValue(long value);
		void SetResultValue(double value);
		void SetResultValue([MarshalAs(UnmanagedType.Interface)] IDWSGenericTypeValue value);
		[return: MarshalAs(UnmanagedType.Interface)]
		IDWSGenericTypeValue CreateTypedValue([MarshalAs(UnmanagedType.LPWStr)] string typeName);
	}
}
