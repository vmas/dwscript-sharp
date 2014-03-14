using System;
using System.Collections.Generic;
using System.Text;
using DWScript;
using DWScript.Interop;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Threading;

namespace TestApp
{
	class Program
	{
		private static readonly DWSErrorCallbackDelegate _debugCallback = DebugCallback;

		private static int GetRefCount(object obj)
		{
			IntPtr pUnk = Marshal.GetIUnknownForObject(obj);
			return Marshal.Release(pUnk);
		}

		static void Main(string[] args)
		{
			var runtime = DWScript.Interop.NativeMethods.DWS_NewRuntime();
			var context = new DWSContext(runtime.NewContext());
			context.Error += (s,e) => { Debug.Print(e.Message); };
			Test4(context);
			GC.KeepAlive(runtime);
		}

		private static void Test4(DWSContext context)
		{
			var a = new DWSEnumDefinition("TEnum");
			a.Add("ENUM_VALUE1", 0);
			a.Add("ENUM_VALUE2", 1);
			a.Add("ENUM_VALUE3", 2);
			context.DefineType(a);

			var method = new DWSMethodDefinition("CreateArrayTest", new NativeAction((cx, args) =>
			{
				var v = new DWSElement(args[0]);
				bool s = false;
			}));
			method.Args.Add(new DWSParameterDefinition("a", "TEnum") { DefaultValue = "ENUM_VALUE3" });
			context.DefineMethod(method);
			context.EvaluateScript("CreateArrayTest();");

			GC.KeepAlive(method);
		}

		private static void Test3(DWSContext context)
		{
			var a = new DWSArrayDefinition("TIntArray", "Integer");
			context.DefineType(a);
			var method = new DWSMethodDefinition("CreateArrayTest", new NativeAction(CreteArrayTest));
			context.DefineMethod(method);
			context.EvaluateScript("CreateArrayTest();");

			GC.KeepAlive(method);
		}

		private static void CreteArrayTest(DWSProgramContext context, DWSValue[] agrs)
		{
			try
			{
				var v = context.CreateTypedValue("TIntArray");
				var array = new DWSArray(v);
				array.Resize(10);
				//var ival = context.CreateTypedValue("Integer");
				//ival.Value = 14;
				//array.Set("2", ival);
				array[0] = 12;
			}
			catch
			{
			}
		}

		private static void Test1(DWSContext context)
		{
			var t = new DWSTypeDefinition("TPoint");
			t.Fields.Add(new DWSFieldDefinition("x", "Integer"));
			t.Fields.Add(new DWSFieldDefinition("y", "Integer"));


			var m = new DWSMethodDefinition("ReturnFirstArg", (c, a) =>
			{
				var v = c.CreateTypedValue("TPoint");

				object o = v.Value;
				v["x"] = 10;
				return v;
			});

			m.Args.Add(new DWSParameterDefinition("a", "Integer"));
			m.ReturnTypeName = "TPoint";

			context.DefineType(t);
			context.DefineMethod(m);
			string s = context.EvaluateScript("var t : TPoint = ReturnFirstArg(2); ReturnFirstArg(t.x);");
			GC.KeepAlive(m);
 
		}

		private static void Test2(DWSContext context)
		{
			ThreadPool.QueueUserWorkItem(x =>
			{
				Thread.Sleep(5000);
				context.Stop();
			});
			// run infinite loop
			string s = context.EvaluateScript(@"
var i : float = 0;
while i <= 0 do
begin
	i := i - 0.000001;
end;");
			
		}

		private static void DebugCallback(string message)
		{
			Debug.Print(message);
		}
	
	}
}
