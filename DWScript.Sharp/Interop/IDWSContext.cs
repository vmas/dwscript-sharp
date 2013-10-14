using System;
using System.Runtime.InteropServices;

namespace DWScript.Interop
{
	[ComImport]
	[Guid("A4E0EADC-E8F2-4388-B2BD-7B5DA5B1694D")]
	[InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
	public interface IDWSContext
	{
		void SetErrorCallback([MarshalAs(UnmanagedType.FunctionPtr)] DWSErrorCallbackDelegate callback);		
		void AddType([MarshalAs(UnmanagedType.Interface)] IDWSGenericTypeDefinition typeDefinition);
		void DefineArrayType([MarshalAs(UnmanagedType.Interface)] IDWSGenericArrayDefinition typedefinition);
		[return: MarshalAs(UnmanagedType.Interface)]
		object AddFunction([MarshalAs(UnmanagedType.Interface)] IDWSGenericMethodDefinition methodDefinition);
		[return: MarshalAs(UnmanagedType.LPWStr)]
		string Evaluate([MarshalAs(UnmanagedType.LPWStr)] string code);
		void Stop();
		[return: MarshalAs(UnmanagedType.LPWStr)]
		string Test();
	}
}
