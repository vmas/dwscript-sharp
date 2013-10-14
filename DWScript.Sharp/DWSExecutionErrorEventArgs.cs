using System;
using System.Collections.Generic;
using System.Text;

namespace DWScript
{
	public class DWSExecutionErrorEventArgs : EventArgs
	{
		private string _message;

		public DWSExecutionErrorEventArgs(string message)
		{
			_message = message;
		}

		public string Message
		{
			get { return _message; }
		}
	}
}
