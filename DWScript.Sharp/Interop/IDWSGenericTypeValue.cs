using System;
using System.Runtime.InteropServices;

namespace DWScript.Interop
{
	[ComImport]
	[Guid("072BAA05-8607-48DA-B218-9A29706F4BF5")]
	[InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
	public interface IDWSGenericTypeValue
	{
		[return: MarshalAs(UnmanagedType.LPWStr)]
		string GetName();
		[return: MarshalAs(UnmanagedType.LPWStr)]
		string GetTypeName();
		[return: MarshalAs(UnmanagedType.Interface)]
		ICOMEnumerable GetFields();
		[return: MarshalAs(UnmanagedType.Interface)]
		IDWSGenericTypeValue GetMethod([MarshalAs(UnmanagedType.LPWStr)] string name);
		[return: MarshalAs(UnmanagedType.Interface)]
		IDWSGenericTypeValue Call();


		[return: MarshalAs(UnmanagedType.LPWStr)]
		string GetValueAsString();
		long GetValueAsInt64();
		double GetValueAsDouble();
		[return: MarshalAs(UnmanagedType.I1)]
		bool GetValueAsBoolean();
		[return: MarshalAs(UnmanagedType.Interface)]
		IDWSGenericTypeValue GetValueAsObject();

		void SetValue([MarshalAs(UnmanagedType.LPWStr)] string value);
		void SetValue(long value);
		void SetValue(double value);
		void SetValue(bool value);
		void SetValue([MarshalAs(UnmanagedType.Interface)] IDWSGenericTypeValue value);

		[return: MarshalAs(UnmanagedType.Interface)]
		IDWSGenericTypeValue GetField([MarshalAs(UnmanagedType.LPWStr)] string name);
		void SetField([MarshalAs(UnmanagedType.LPWStr)] string name, [MarshalAs(UnmanagedType.Interface)] IDWSGenericTypeValue value);


		[return: MarshalAs(UnmanagedType.Interface)]
		IDWSGenericTypeValue GetElementByIndex(int index);
		void SetElementByIndex(int index, [MarshalAs(UnmanagedType.Interface)] IDWSGenericTypeValue value);
		void SetLength(int length);

		[return: MarshalAs(UnmanagedType.Interface)]
		IDWSProgramInfo GetProgramInfo();
		[return: MarshalAs(UnmanagedType.LPWStr)]
		string GetElementsTypeName();
	}
}
