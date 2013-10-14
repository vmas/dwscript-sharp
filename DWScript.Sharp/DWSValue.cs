﻿using System;
using System.Collections.Generic;
using DWScript.Interop;
using System.Runtime.InteropServices;

namespace DWScript
{
	public class DWSValue
	{
		private IDWSGenericTypeValue _value;

		public DWSValue(IDWSGenericTypeValue value)
		{
			if (value == null)
				throw new ArgumentNullException("value");
			if (!Marshal.IsComObject(value))
				throw new ArgumentOutOfRangeException("value");

			_value = value;
		}

		public string Name
		{
			get { return _value.GetName(); }
		}

		public string TypeName
		{
			get { return _value.GetTypeName(); }
		}

		public object this[string name]
		{
			get { return Get(name).Value; }
			set { Get(name).Value = value; }
		}

		public virtual DWSValue Get(string name)
		{
			return new DWSValue(_value.GetField(name));
		}

		public virtual void Set(string name, DWSValue value)
		{
			_value.SetField(name, value.GetNativeValue());
		}

		public object Value
		{
			get
			{
				switch (_value.GetTypeName().ToUpperInvariant())
				{
					case "INTEGER":
						return _value.GetValueAsInt64();
					case "BOOLEAN":
						return _value.GetValueAsBoolean();
					case "FLOAT":
					case "REAL":
					case "DOUBLE":
						return _value.GetValueAsDouble();
					case "STRING":
						return _value.GetValueAsString();
					default:
						return new DWSValue(_value.GetValueAsObject());
				}
			}

			set
			{
				Type t = value.GetType();
				if (t.IsPrimitive)
				{
					switch (t.Name)
					{
						case "Int32":
						case "Int16":
						case "Int64":
						case "Byte":
						case "SByte":
							_value.SetValue(Convert.ToInt64(value));
							break;
						case "Boolean":
							_value.SetValue((bool)value);
							break;
						case "Double":
						case "Single":
						case "Decimal":
							_value.SetValue(Convert.ToDouble(value));
							break;
					}
				}
				else if (typeof(IDWSGenericTypeValue).IsAssignableFrom(t))
				{
					_value.SetValue((IDWSGenericTypeValue)value);
				}
				else if (typeof(DWSValue).IsAssignableFrom(t))
				{
					_value.SetValue(((DWSValue)value).GetNativeValue());
				}
				else
				{
					throw new ArgumentOutOfRangeException();
				}
			}
		}

		internal IDWSGenericTypeValue GetNativeValue()
		{
			return _value;
		}
	}
}
