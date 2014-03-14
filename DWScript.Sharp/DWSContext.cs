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
		private DWSIncludeCallbackDelegate _includeCallback;

		public event EventHandler<DWSExecutionErrorEventArgs> Error;

		public DWSContext(IDWSContext context)
		{
			if (context == null)
				throw new ArgumentNullException("context");

			_errorCallback = ErrorCallback;
			_includeCallback = IncludeCallback;

			_context = context;
			_context.SetErrorCallback(_errorCallback);
			_context.SetIncludeCallback(_includeCallback);
		}

		public void DefineMethod(DWSMethodDefinition method)
		{
			method.Init(Context.AddFunction(method));
		}

		public void DefineType(DWSTypeDefinition type)
		{
			if (type.IsStruct)
				Context.DefineRecordType(type);
			else
				Context.DefineType(type);
		}

		public void DefineType(DWSArrayDefinition type)
		{
			Context.DefineArrayType(type);
		}

		public void DefineType(DWSEnumDefinition type)
		{
			Context.DefineEnumType(type);
		}

		public string EvaluateScript(string code)
		{
			return Context.Evaluate(code);
		}

		public void Stop()
		{
			Context.Stop();
		}


		protected IDWSContext Context
		{
			get
			{
				if (_context == null)
					throw new ObjectDisposedException(this.GetType().FullName);
				return _context;
			}
		}

		protected virtual string OnInclude(string scriptName)
		{
			return null;
		}

		private void ErrorCallback(string message)
		{
			message = Regex.Replace(message, @"\[line:\s(?<lineno>\d+),", new MatchEvaluator(m => "[line: " + (int.Parse(m.Groups["lineno"].Value) - 1).ToString() + ","));
			if (Error != null)
				Error(this, new DWSExecutionErrorEventArgs(message));
		}

		private int IncludeCallback(string scriptName, out string scriptSource)
		{
			scriptSource = null;
			try
			{
				scriptSource = OnInclude(scriptName);
			}
			catch(Exception ex)
			{
				return Marshal.GetHRForException(ex);
			}
			return 0;
		}

		public void Dispose()
		{
			if (_context != null)
			{
				Marshal.ReleaseComObject(_context);
				_context = null;
			}
		}
	}
}
