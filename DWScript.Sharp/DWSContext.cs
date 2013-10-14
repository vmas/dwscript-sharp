using System;
using DWScript.Interop;
using System.Runtime.InteropServices;
using System.Text.RegularExpressions;

namespace DWScript
{
	public class DWSContext : IDisposable
	{
		private IDWSContext _context;
		private DWSErrorCallbackDelegate _errorCallback;

		public event EventHandler<DWSExecutionErrorEventArgs> Error;

		public DWSContext(IDWSContext context)
		{
			_errorCallback = ErrorCallback;

			_context = context;
			_context.SetErrorCallback(_errorCallback);
		}

		public void DefineMethod(DWSMethodDefinition method)
		{
			method.Init(_context.AddFunction(method));
		}

		public void DefineType(DWSTypeDefinition type)
		{
			_context.AddType(type);
		}

		public void DefineType(DWSArrayDefinition type)
		{
			_context.DefineArrayType(type);
		}

		public string EvaluateScript(string code)
		{
			return _context.Evaluate(code);
		}

		public void Stop()
		{
			_context.Stop();
		}

		private void ErrorCallback(string message)
		{
			message = Regex.Replace(message, @"\[line:\s(?<lineno>\d+),", new MatchEvaluator(m => "[line: " + (int.Parse(m.Groups["lineno"].Value) - 1).ToString() + ","));
			if (Error != null)
				Error(this, new DWSExecutionErrorEventArgs(message));
		}

		public void Dispose()
		{
			Marshal.ReleaseComObject(_context);
			_context = null;
		}
	}
}
