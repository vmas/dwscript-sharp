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

	[UnmanagedFunctionPointer(CallingConvention.StdCall)]
	public delegate int DWSCOMCallbackDelegate([MarshalAs(UnmanagedType.Interface)] IDWSProgramInfo comObj);

	[UnmanagedFunctionPointer(CallingConvention.StdCall)]
	public delegate int DWSIncludeCallbackDelegate([MarshalAs(UnmanagedType.LPWStr)] string scriptName, [MarshalAs(UnmanagedType.LPWStr)] out string scriptSource);

}
