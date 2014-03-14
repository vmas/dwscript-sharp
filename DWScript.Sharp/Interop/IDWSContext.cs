using System;
using System.Runtime.InteropServices;

namespace DWScript.Interop
{
	[ComImport]
	[Guid("FFE89EEB-45BF-43E0-826C-7BB5D95F5027")]
	[InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
	public interface IDWSContext
	{
		void SetErrorCallback([MarshalAs(UnmanagedType.FunctionPtr)] DWSErrorCallbackDelegate callback);
		void SetIncludeCallback([MarshalAs(UnmanagedType.FunctionPtr)] DWSIncludeCallbackDelegate callback);
		void DefineType([MarshalAs(UnmanagedType.Interface)] IDWSGenericTypeDefinition typeDefinition);
		void DefineRecordType([MarshalAs(UnmanagedType.Interface)] IDWSGenericTypeDefinition typedefinition);
		void DefineArrayType([MarshalAs(UnmanagedType.Interface)] IDWSGenericArrayDefinition typedefinition);
		[return: MarshalAs(UnmanagedType.Interface)]
		object AddFunction([MarshalAs(UnmanagedType.Interface)] IDWSGenericMethodDefinition methodDefinition);
		[return: MarshalAs(UnmanagedType.LPWStr)]
		string Evaluate([MarshalAs(UnmanagedType.LPWStr)] string code);
		void Stop();
		void DefineEnumType([MarshalAs(UnmanagedType.Interface)] IDWSGenericTypeDefinition typedefinition);
	}
}
