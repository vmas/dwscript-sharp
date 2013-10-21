using System;
using System.Runtime.InteropServices;

namespace DWScript.Interop
{
	public static class NativeMethods
	{
		private const string DWSriptLib = "DWScript.dll";
		
		[DllImport(DWSriptLib, CallingConvention = CallingConvention.Cdecl)]
		[return: MarshalAs(UnmanagedType.Interface)]
		public static extern IDWSRuntime DWS_NewRuntime();
	}

	[UnmanagedFunctionPointer(CallingConvention.Cdecl)]
	public delegate void DWSErrorCallbackDelegate([MarshalAs(UnmanagedType.LPWStr)] string error);

	[UnmanagedFunctionPointer(CallingConvention.Cdecl)]
	public delegate void DWSCOMCallbackDelegate([MarshalAs(UnmanagedType.Interface)] IDWSProgramInfo comObj);
	
}
