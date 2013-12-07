using System;
using DWScript;
using NUnit.Framework;

namespace UnitTests
{
	[TestFixture]
	class DWSContextTests : TestsBase
	{


		[Test]
		public void DefineMethod_AsProcedure()
		{
			var action = new DWSMethodDefinition("Test", (x, a) => { });
			context.DefineMethod(action);
			context.EvaluateScript("Test();");
			Assert.IsNull(this.LastErrorMessage);
			GC.KeepAlive(action);
		}

		[Test]
		public void DefineMethod_AsIntegerFunction()
		{
			var f = new DWSMethodDefinition("Test", (x, a) => 1);
			f.ReturnTypeName = "Integer";
			context.DefineMethod(f);
			context.EvaluateScript("Test();");
			Assert.IsNull(this.LastErrorMessage);
			GC.KeepAlive(f);
		}

		[Test]
		public void DefineMethod_AsIntegerFunctionWithParam()
		{
			var f = new DWSMethodDefinition("Test", (x, a) => a[0]);
			f.Args.Add(new DWSParameterDefinition("a", "Integer"));
			f.ReturnTypeName = "Integer";
			context.DefineMethod(f);
			
			string rv = context.EvaluateScript(@"var a : Integer = Test(123); Print(IntToStr(a));");
			Assert.IsNull(this.LastErrorMessage);
			Assert.AreEqual("123", rv);

			this.ResetErrors();
			context.EvaluateScript("a := Test();");
			Assert.IsNotNull(this.LastErrorMessage);
			GC.KeepAlive(f);
		}

		[Test]
		public void DefineMethod_AsIntegerFunctionWithDefaultParam()
		{
			var f = new DWSMethodDefinition("Test", (x, a) => 123);
			f.Args.Add(new DWSParameterDefinition("a", "Integer") { DefaultValue = "1" });
			f.ReturnTypeName = "Integer";
			context.DefineMethod(f);

			string rv;
			rv = context.EvaluateScript(@"var a : Integer = Test(1); Print(IntToStr(a));");
			Assert.IsNull(this.LastErrorMessage);
			Assert.AreEqual("123", rv);

			this.ResetErrors();
			rv = context.EvaluateScript("a := Test(); Print(IntToStr(a));");
			Assert.IsNull(this.LastErrorMessage);
			Assert.AreEqual("123", rv);

			GC.KeepAlive(f);
		}

		[Test]
		public void DefineMethod_WithEmptyArrayAsDefaultParam()
		{
			var action = new DWSMethodDefinition("Test", (x, a) => { });
			action.Args.Add(new DWSParameterDefinition("a", "array of string") { DefaultValue = "[]" });
			context.DefineMethod(action);

			context.EvaluateScript(@"Test(['hello']);");
			Assert.IsNull(this.LastErrorMessage);

			this.ResetErrors();
			context.EvaluateScript("Test();");
			Assert.IsNull(this.LastErrorMessage);
			GC.KeepAlive(action);
		}

		[Test]
		public void DefineMethod_AsRecordFunction()
		{
			var t = new DWSTypeDefinition("TCustomType");
			t.Fields.Add(new DWSFieldDefinition("x", "Integer"));
			t.Fields.Add(new DWSFieldDefinition("y", "Integer"));
			t.IsStruct = true;
			context.DefineType(t);

			var f = new DWSMethodDefinition("Test", (x, a) => {
				var v = x.CreateTypedValue("TCustomType");
				v["x"] = 123;
				return v;
			});
			f.ReturnTypeName = "TCustomType";
			context.DefineMethod(f);

			string rv = context.EvaluateScript(@"var a : TCustomType = Test(); Print(IntToStr(a.x));");
			Assert.IsNull(this.LastErrorMessage);
			Assert.AreEqual("123", rv);

			GC.KeepAlive(f);
		}

		[Test]
		public void DefineMethod_AsOverloadedProcedure()
		{
			var actionA = new DWSMethodDefinition("Test", (x, a) => { });
			actionA.Overloaded = true;
			context.DefineMethod(actionA);

			var actionB = new DWSMethodDefinition("Test", (x, a) => { });
			actionB.Args.Add(new DWSParameterDefinition("a", "Integer"));
			actionB.Overloaded = true;
			context.DefineMethod(actionB);

			context.EvaluateScript("Test(); Test(1);");
			Assert.IsNull(this.LastErrorMessage);
			GC.KeepAlive(actionA);
			GC.KeepAlive(actionB);
		}

		[Test]
		public void DefineType_AsType()
		{
			var t = new DWSTypeDefinition("TCustomType");
			t.Fields.Add(new DWSFieldDefinition("x", "Integer"));
			t.Fields.Add(new DWSFieldDefinition("y", "Integer"));
			context.DefineType(t);
			
			context.EvaluateScript(@"var a : TCustomType; a := TCustomType.Create(); a.x := 1; a.y := 2;");
			Assert.IsNull(this.LastErrorMessage);
		}

		[Test]
		public void DefineType_AsRecordType()
		{
			var t = new DWSTypeDefinition("TCustomType");
			t.Fields.Add(new DWSFieldDefinition("x", "Integer"));
			t.Fields.Add(new DWSFieldDefinition("y", "Integer"));
			t.IsStruct = true;
			context.DefineType(t);

			context.EvaluateScript(@"var a : TCustomType; a.x := 1; a.y := 2;");
			Assert.IsNull(this.LastErrorMessage);
		}

		[Test]
		public void DefineType_AsArray()
		{
			context.DefineType(new DWSArrayDefinition("TCustomArrayType", "String"));

			context.EvaluateScript(@"var a : TCustomArrayType; a := ['a', 'b', 'c'];");
			Assert.IsNull(this.LastErrorMessage);
		}

		[Test]
		public void EvaluateScript_ExecuteAndGetResult()
		{
			string msg = context.EvaluateScript(@"Print('Hello, World!');");
			Assert.AreEqual("Hello, World!", msg);
			Assert.IsNull(this.LastErrorMessage);
		}

		[Test]
		public void EvaluateScript_ExecuteAndThrowException()
		{
			context.EvaluateScript(@"raise Exception.Create('exceptionName');");
			Assert.AreEqual("Runtime Error: User defined exception: exceptionName [line: 1, column: 40]\r\n", this.LastErrorMessage);
		}


		[Test]
		public void EvaluateScript_ExecuteAndThrowCLRException()
		{
			var exception = new InvalidOperationException();
			var action = new DWSMethodDefinition("Test", (x, a) => { throw exception; });
			context.DefineMethod(action);
			context.EvaluateScript(@"Test();");
			Assert.AreEqual(string.Format("Runtime Error: {0} in Test [line: 1, column: 1]\r\n", exception.Message.Replace(".", "")), this.LastErrorMessage);
		}

		[Test]
		public void EvaluateScript_ExecuteWithInclusionDirectives()
		{
			string s;
			using (var context = new CustomContext(runtime.NewContext()))
			{
				string error = null;
				context.Error += (o, e) => { error = e.Message; };
				context.SourceGetter = ((name) => name == "filename" ? "var a := 'hello';" : null);
				s = context.EvaluateScript("{$INCLUDE 'filename'}\r\nPrint(a);");
				Assert.IsNull(error);
				Assert.AreEqual("hello", s);

				context.SourceGetter = null;
				s = context.EvaluateScript("{$INCLUDE 'filename'}\r\nPrint(a);");
				Assert.AreEqual("Compile Error: Could not find file \"filename\" on input paths [line: 1, column: 11]\r\n", error);
			}

		}
	}
}
