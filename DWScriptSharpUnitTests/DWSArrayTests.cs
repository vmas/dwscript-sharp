using System;
using DWScript;
using NUnit.Framework;

namespace UnitTests
{
	[TestFixture]
	class DWSArrayTests : TestsBase
	{
		[Test]
		public void DynamicArray_TestStringArrayLength()
		{
			context.DefineType(new DWSArrayDefinition("TStringArray", "String"));

			var action = new DWSMethodDefinition("Test", (x, a) => {
				var array = new DWSArray(a[0]);
				int length = 0;
				Assert.DoesNotThrow(() => length = array.Length);
				Assert.AreEqual(3, length);
			});
			action.Args.Add(new DWSParameterDefinition("a", "TStringArray"));
			context.DefineMethod(action);
			context.EvaluateScript("Test(['a', 'b', 'c']);");
			Assert.IsNull(this.LastErrorMessage);
			GC.KeepAlive(action);
		}

		[Test]
		public void DynamicArray_TestStringArrayElements()
		{
			context.DefineType(new DWSArrayDefinition("TStringArray", "String"));

			var action = new DWSMethodDefinition("Test", (x, a) =>
			{
				var array = new DWSArray(a[0]);
				Assert.AreEqual("a", array[0]);
				Assert.AreEqual("b", array[1]);
				Assert.AreEqual("c", array[2]);
			});
			action.Args.Add(new DWSParameterDefinition("a", "TStringArray"));
			context.DefineMethod(action);
			context.EvaluateScript("Test(['a', 'b', 'c']);");
			Assert.IsNull(this.LastErrorMessage);
			GC.KeepAlive(action);
		}

		[Test]
		public void DynamicArray_TestCreateDynamicStringArrayInScript()
		{
			bool isCallied = false;

			var action = new DWSMethodDefinition("Test", (x, a) => isCallied = true);
			context.DefineMethod(action);
			context.EvaluateScript(@"

var a : array of string;
a.Add('asdf');
Test();

");
			Assert.IsNull(this.LastErrorMessage);
			Assert.IsTrue(isCallied);
			GC.KeepAlive(action);
		}
	}
}
