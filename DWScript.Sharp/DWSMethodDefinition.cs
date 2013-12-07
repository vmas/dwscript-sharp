using System;
using System.Collections.Generic;
using DWScript.Interop;
using System.Runtime.InteropServices;

namespace DWScript
{
	public class DWSMethodDefinition : IDWSGenericMethodDefinition 
	{
		private string _name;
		private DelphiArray<DWSParameterDefinition> _args;
		private DWSCOMCallbackDelegate _comCallback;
		private Delegate _callback;
		private object _proxy;

		public DWSMethodDefinition(string name, NativeFunction callback)
		{
			_name = name;
			_callback = callback;
			_args = new DelphiArray<DWSParameterDefinition>();
			_comCallback = Callback;
		}

		public DWSMethodDefinition(string name, NativeAction callback)
		{
			_name = name;
			_callback = callback;
			_args = new DelphiArray<DWSParameterDefinition>();
			_comCallback = Callback;
		}

		internal void Init(object methodProxy)
		{
			_proxy = methodProxy;
		}

		public virtual bool Overloaded { get; set; }

		public virtual string ReturnTypeName { get; set; }

		public IList<DWSParameterDefinition> Args
		{
			get
			{
				return _args;
			}
		}

		string IDWSGenericMethodDefinition.GetName()
		{
			return _name;
		}

		ICOMEnumerable IDWSGenericMethodDefinition.GetArgs()
		{
			return _args; 
		}

		string IDWSGenericMethodDefinition.GetReturnTypeName()
		{
			return this.ReturnTypeName;
		}

		protected virtual int Callback(IDWSProgramInfo comObj)
		{
			try
			{
				var args = new DWSValue[this.Args.Count];
				var argDefs = this.Args;
				for (int i = argDefs.Count - 1; i >= 0; i--)
				{
					args[i] = new DWSValue(comObj.GetVariable(argDefs[i].Name));
				}
				object rv = _callback.DynamicInvoke(new DWSProgramContext(comObj), args);
				if (this.ReturnTypeName != null)
				{
					var result = new DWSValue(comObj.CreateTypedValue(this.ReturnTypeName));
					result.Value = rv;
					comObj.SetResultValue(result.GetNativeValue());
				}
			}
			catch (Exception ex)
			{
				return Marshal.GetHRForException(ex.InnerException ?? ex);
			}
			return 0;
		}

		IntPtr IDWSGenericMethodDefinition.GetCallback()
		{
			return Marshal.GetFunctionPointerForDelegate(_comCallback);
		}

		bool IDWSGenericMethodDefinition.GetIsOverloaded()
		{
			return this.Overloaded;
		}
	}
}
