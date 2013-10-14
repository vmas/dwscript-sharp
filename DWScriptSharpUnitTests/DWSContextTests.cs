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
			var f = new DWSMethodDefinition("Test", (x, a) => a);
			f.Args.Add(new DWSParameterDefinition("a", "Integer"));
			f.ReturnTypeName = "Integer";
			context.DefineMethod(f);

			context.EvaluateScript(@"var a : Integer = Test(1);");
			Assert.IsNull(this.LastErrorMessage);

			this.ResetErrors();
			context.EvaluateScript("var a : Integer = Test();");
			Assert.IsNotNull(this.LastErrorMessage);
			GC.KeepAlive(f);
		}

		[Test]
		public void DefineMethod_AsIntegerFunctionWithDefaultParam()
		{
			var f = new DWSMethodDefinition("Test", (x, a) => 1);
			f.Args.Add(new DWSParameterDefinition("a", "Integer") { DefaultValue = "1" });
			f.ReturnTypeName = "Integer";
			context.DefineMethod(f);

			context.EvaluateScript(@"var a : Integer = Test(1);");
			Assert.IsNull(this.LastErrorMessage);

			this.ResetErrors();
			context.EvaluateScript("a := Test();");
			Assert.IsNull(this.LastErrorMessage);
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
	
	}
}
