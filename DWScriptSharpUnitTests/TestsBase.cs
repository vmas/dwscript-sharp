using System;
using DWScript;
using DWScript.Interop;
using NUnit.Framework;
using System.Runtime.InteropServices;

namespace UnitTests
{
	public class TestsBase
	{
		protected IDWSRuntime runtime;
		protected DWSContext context;
		private string _lastErrorMessage;

		[SetUp]
		public virtual void BeforeEachTestSetup()
		{
			this.ResetErrors();
			runtime = NativeMethods.DWS_NewRuntime();
			context = new DWSContext(runtime.NewContext());
			context.Error += context_Error;
		}

		[TearDown]
		public virtual void AfterEachTestTearDown()
		{
			context.Error -= context_Error;
			context.Dispose();
		}

		void context_Error(object sender, DWSExecutionErrorEventArgs e)
		{
			_lastErrorMessage = e.Message;
		}

		public string LastErrorMessage
		{
			get { return _lastErrorMessage; }
		}

		protected void ResetErrors()
		{
			_lastErrorMessage = null;
		}
	}
}
