unit DWSGenericType;

interface

uses Classes,
	dwsCOMTypes,
//	dwsVCLGUIFunctions, Dialogs,
	dwsExprs,
	SysUtils,
	Windows;

type

	IDWSGenericTypeValue = interface
		['{072BAA05-8607-48DA-B218-9A29706F4BF5}']
		function GetName(out rv: TUnicodeString): HResult; stdcall;
		function GetTypeName(out rv: TUnicodeString): HResult; stdcall;
		function GetFields(out rv: ICOMEnumerable): HResult; stdcall;
		function GetMethod(name: TUnicodeString; out rv: IDWSGenericTypeValue): HRESULT; stdcall;
		function Call(out rv: IDWSGenericTypeValue): HResult; stdcall;
		function GetValueAsString(out rv: TUnicodeString): HResult; stdcall;
		function GetValueAsInt64(out rv: Int64): HResult; stdcall;
		function GetValueAsDouble(out rv: Double): HResult; stdcall;
		function GetValueAsBoolean(out rv: boolean): HResult; stdcall;
		function GetValueAsObject(out rv: IDWSGenericTypeValue): HResult; stdcall;
		function SetStringValue(value: TUnicodeString): HResult; stdcall;
		function SetInt64Value(value: Int64): HResult; stdcall;
		function SetDoubleValue(value: Double): HResult; stdcall;
		function SetBooleanValue(value: boolean): HResult; stdcall;
		function SetObjectValue(value: IDWSGenericTypeValue): HResult; stdcall;
		function GetField(name : TUnicodeString; out value: IDWSGenericTypeValue): HResult; stdcall;
		function SetField(name : TUnicodeString; value: IDWSGenericTypeValue): HResult; stdcall;
		function GetElement(index: Int32; out rv: IDWSGenericTypeValue): HResult; stdcall;
		function SetElement(index: Int32; value: IDWSGenericTypeValue): HResult; stdcall;
		function SetLength(len: Int32): HResult; stdcall;
		function GetProgramInfo(out rv: IUnknown): HRESULT; stdcall;
		function GetElementsTypeName(out rv: TUnicodeString): HRESULT; stdcall;
	end;

	IDWSNativeGenericTypeValue = interface
		['{C8F97B35-68B6-4064-9C4D-4C8DBB7EEB4A}']
		function GetInfo() : IInfo;
	end;

	IDWSFieldDefinition = interface
		['{B6445511-CC01-45FC-9B28-434F7FDFE0C3}']
		function GetName(out rv: TUnicodeString): HResult; stdcall;
		function GetTypeName(out rv: TUnicodeString): HResult; stdcall;
		function GetHasDefaultValue(out rv: Boolean): HResult; stdcall;
		function GetDefaultValue(out rv: TUnicodeString): HResult; stdcall;
		function GetModifier(out rv: Integer): HRESULT; stdcall;
		function GetIsVarParam(out rv: Boolean): HRESULT; stdcall;
	end;

	IDWSElementDefinition = interface
		['{28CF73E3-175E-45DE-97DF-EFF1F8D9B52C}']
		function GetName(out rv: TUnicodeString): HResult; stdcall;
		function GetValue(out rv: Integer): HResult; stdcall;
    end;

	// TDWSGenericType
	//
	TDWSGenericTypeValue = class(
		TCOMObject,
		IDWSGenericTypeValue,
		IDWSNativeGenericTypeValue,
		ICOMEnumerable)
	private
	private
		_name: string;
	private
		_value: IInfo;
		//function CreateValue(name: string; v : IInfo) : IDWSGenericTypeValue;
	public
		constructor Create(name: string; obj: IInfo); virtual;
		// destructor Destroy; override;
		function GetName(out rv: TUnicodeString): HResult; stdcall;
		function GetTypeName(out rv: TUnicodeString): HResult; stdcall;
		function GetFields(out rv: ICOMEnumerable): HResult; stdcall;
		function GetMethod(name: TUnicodeString; out rv: IDWSGenericTypeValue): HRESULT; stdcall;
		function GetValueAsString(out rv: TUnicodeString): HResult; stdcall;
		function GetValueAsInt64(out rv: Int64): HResult; stdcall;
		function GetValueAsDouble(out rv: Double): HResult; stdcall;
		function GetValueAsBoolean(out rv: boolean): HResult; stdcall;
		function GetValueAsObject(out rv: IDWSGenericTypeValue): HResult; stdcall;
		function SetStringValue(value: TUnicodeString): HResult; stdcall;
		function SetInt64Value(value: Int64): HResult; stdcall;
		function SetDoubleValue(value: Double): HResult; stdcall;
		function SetBooleanValue(value: boolean): HResult; stdcall;
		function SetObjectValue(value: IDWSGenericTypeValue): HResult; stdcall;
		function Call(out rv: IDWSGenericTypeValue): HResult; stdcall;
		function GetField(name : TUnicodeString; out rv: IDWSGenericTypeValue): HResult; stdcall;
		function SetField(name : TUnicodeString; value: IDWSGenericTypeValue): HResult; stdcall;
		function GetElement(index: Int32; out rv: IDWSGenericTypeValue): HResult; stdcall;
		function SetElement(index: Int32; value: IDWSGenericTypeValue): HResult; stdcall;
		function SetLength(len: Int32): HResult; stdcall;
		function GetProgramInfo(out rv: IUnknown): HRESULT; stdcall;
		function GetElementsTypeName(out rv: TUnicodeString): HRESULT; stdcall;

		function GetInfo() : IInfo;

		function GetEnumerator(out rv: ICOMEnumerator): HResult; stdcall;
		{
		  function GetName(out rv: TUnicodeString): HResult; stdcall;
		  function SetName(name: string): HResult; stdcall;
		}

		// property ScriptObj : Variant read FScriptObj write FScriptObj;
	end;

	TDWSInfoEnumerator = class(TCOMObject, ICOMEnumerator)
	private
		_enumerator: TStringsEnumerator;
		_info: IInfo;
	public
		constructor Create(info: IInfo; enumerator: TStringsEnumerator);
		destructor Destroy; override;
		function GetCurrent(out rv: IUnknown): HResult; stdcall;
		function MoveNext(out rv: boolean): HResult; stdcall;
	end;

	IDWSProgramInfo = interface
		['{6CDAC2C3-0175-4566-AEFB-7F1B1E59E39C}']
		function GetVariable(name: TUnicodeString; out rv: IDWSGenericTypeValue): HRESULT; stdcall;
		function GetTypeReference(name: TUnicodeString; out rv: IDWSGenericTypeValue): HRESULT; stdcall;
		function SetResultAsString(value: TUnicodeString): HRESULT; stdcall;
		function SetResultAsBoolean(value: Boolean): HRESULT; stdcall;
		function SetResultAsInt64(value: Int64): HRESULT; stdcall;
		function SetResultAsDouble(value: Double): HRESULT; stdcall;
		function SetResultAsObject(value: IDWSGenericTypeValue): HRESULT; stdcall;
		function CreateTypedValue(typeName: TUnicodeString; out rv: IDWSGenericTypeValue): HRESULT; stdcall;
	end;

	TDWSProgramInfo = class(TCOMObject, IDWSProgramInfo)
	private
		_info: TProgramInfo;
	public
		constructor Create(Info: TProgramInfo);
		function GetVariable(name: TUnicodeString; out rv: IDWSGenericTypeValue): HRESULT; stdcall;
		function GetTypeReference(name: TUnicodeString; out rv: IDWSGenericTypeValue): HRESULT; stdcall;
		function SetResultAsString(value: TUnicodeString): HRESULT; stdcall;
		function SetResultAsBoolean(value: Boolean): HRESULT; stdcall;
		function SetResultAsInt64(value: Int64): HRESULT; stdcall;
		function SetResultAsDouble(value: Double): HRESULT; stdcall;
		function SetResultAsObject(value: IDWSGenericTypeValue): HRESULT; stdcall;
		function CreateTypedValue(typeName : TUnicodeString; out rv: IDWSGenericTypeValue): HRESULT; stdcall;
	end;

implementation

function CreateValue(name: string; v : IInfo) : IDWSGenericTypeValue;
var
	rv : IDWSGenericTypeValue;
begin
	if( v <> nil) then begin
		TDWSGenericTypeValue.Create(name, v).GetInterface(IDWSGenericTypeValue, rv);
		rv._AddRef;
	end else begin
		rv := nil;
	end;
	Result := rv;
end;

constructor TDWSGenericTypeValue.Create(name: string; obj: IInfo);
begin
	_name := name;
	_value := obj;
end;

function TDWSGenericTypeValue.GetProgramInfo(out rv: IUnknown): HRESULT; stdcall;
begin
	TDWSProgramInfo.Create(_value.Exec.Info).GetInterface(IUnknown, rv);
	Result := S_OK;
end;

function TDWSGenericTypeValue.GetInfo() : IInfo;
begin
	Result := _value;
end;

function TDWSGenericTypeValue.GetName(out rv: TUnicodeString): HResult; stdcall;
begin
	rv := _name;
	Result := S_OK;
end;

function TDWSGenericTypeValue.GetTypeName(out rv: TUnicodeString): HResult; stdcall;
begin
	rv := _value.TypeSym.Name;
	Result := S_OK;
end;

function TDWSGenericTypeValue.GetEnumerator(out rv: ICOMEnumerator): HResult; stdcall;
var
	enumerator : TStringsEnumerator;
begin
	enumerator := _value.FieldMemberNames.GetEnumerator();
	if(enumerator <> nil) then begin
		TDWSInfoEnumerator.Create(_value, enumerator).GetInterface(ICOMEnumerator, rv);
		rv._AddRef();
	end else begin
		rv := nil;
	end;
	Result := S_OK;
end;

function TDWSGenericTypeValue.GetFields(out rv: ICOMEnumerable): HResult; stdcall;
begin
	self.GetInterface(ICOMEnumerable, rv);
	rv._AddRef();
	Result := S_OK;
end;

function TDWSGenericTypeValue.GetField(name : TUnicodeString; out rv: IDWSGenericTypeValue): HResult; stdcall;
begin
	rv := CreateValue(name, _value.Member[name]);
	Result := S_OK;
end;

function TDWSGenericTypeValue.SetField(name : TUnicodeString; value: IDWSGenericTypeValue): HResult; stdcall;
var
	v : TDWSGenericTypeValue;
begin
	v := value as TDWSGenericTypeValue;
	if (v <> nil) then begin
		_value.Member[name].Data := v._value.Data;
		Result := S_OK;
	end else begin
		Result := E_INVALIDARG;
	end;
end;

function TDWSGenericTypeValue.GetMethod(name: TUnicodeString; out rv: IDWSGenericTypeValue): HRESULT; stdcall;
begin
	rv := CreateValue(name, _value.Method[name]);
	Result := S_OK;
end;

function TDWSGenericTypeValue.Call(out rv: IDWSGenericTypeValue): HResult; stdcall;
begin
	rv := CreateValue('Result', _value.Call());
	Result := S_OK;
end;

function TDWSGenericTypeValue.GetElement(index: Int32; out rv: IDWSGenericTypeValue): HResult; stdcall;
begin
	rv := CreateValue(IntToStr(index), _value.Element([index]));
	Result := S_OK;
end;

function TDWSGenericTypeValue.SetElement(index: Int32; value: IDWSGenericTypeValue): HResult; stdcall;
var
	v : TDWSGenericTypeValue;
begin
	v := value as TDWSGenericTypeValue;
	if (v <> nil) then begin
		_value.Element([index]).Data := v._value.Data;
		Result := S_OK;
	end else begin
		Result := E_INVALIDARG;
	end;
end;

function TDWSGenericTypeValue.GetElementsTypeName(out rv: TUnicodeString): HRESULT; stdcall;
begin
	rv := _value.TypeSym.Typ.Name;
	Result := S_OK;
end;

function TDWSGenericTypeValue.SetLength(len: Int32): HResult; stdcall;
begin
	_value.Exec.Info.Func['SetLength'].Call([_value.Value, len]);
	Result := S_OK;
end;

function TDWSGenericTypeValue.GetValueAsString(out rv: TUnicodeString): HResult; stdcall;
begin
	rv := _value.ValueAsString;
	Result := S_OK;
end;

function TDWSGenericTypeValue.GetValueAsInt64(out rv: Int64): HResult; stdcall;
begin
	rv := _value.ValueAsInteger;
	Result := S_OK;
end;

function TDWSGenericTypeValue.GetValueAsDouble(out rv: Double): HResult; stdcall;
begin
	rv := _value.ValueAsFloat;
	Result := S_OK;
end;

function TDWSGenericTypeValue.GetValueAsBoolean(out rv: boolean): HResult; stdcall;
begin
	rv := _value.ValueAsBoolean;
	Result := S_OK;
end;

function TDWSGenericTypeValue.GetValueAsObject(out rv: IDWSGenericTypeValue): HResult; stdcall;
begin
	self.GetInterface(IDWSGenericTypeValue, rv);
	rv._AddRef;
	Result := S_OK;
end;

function TDWSGenericTypeValue.SetStringValue(value: TUnicodeString): HResult; stdcall;
begin
	_value.Value := string(value);
	Result := S_OK;
end;

function TDWSGenericTypeValue.SetInt64Value(value: Int64): HResult; stdcall;
begin
	_value.Value := value;
	Result := S_OK;
end;

function TDWSGenericTypeValue.SetDoubleValue(value: Double): HResult; stdcall;
begin
	_value.Value := value;
	Result := S_OK;
end;

function TDWSGenericTypeValue.SetBooleanValue(value: boolean): HResult; stdcall;
begin
	_value.Value := value;
	Result := S_OK;
end;

function TDWSGenericTypeValue.SetObjectValue(value: IDWSGenericTypeValue): HResult; stdcall;
var
	v : TDWSGenericTypeValue;
begin
	v := value as TDWSGenericTypeValue;
	if (v <> nil) then begin
		_value.Data := v._value.Data;
		Result := S_OK;
	end else begin
		Result := E_INVALIDARG;
	end;
end;


constructor TDWSInfoEnumerator.Create(info: IInfo; enumerator: TStringsEnumerator);
begin
	_info := info;
	_enumerator := enumerator;
end;

destructor TDWSInfoEnumerator.Destroy;
begin
	_enumerator.Free;
end;

function TDWSInfoEnumerator.GetCurrent(out rv: IUnknown): HResult; stdcall;
var
	name: string;
begin
	name := _enumerator.Current;
	if (name <> '') then begin
		TDWSGenericTypeValue.Create(name, _info.Member[name]).GetInterface(IUnknown, rv);
		rv._AddRef();
		Result := S_OK;
	end else begin
		Result := E_UNEXPECTED;
	end;
end;

function TDWSInfoEnumerator.MoveNext(out rv: boolean): HResult; stdcall;
begin
	rv := _enumerator.MoveNext();
	Result := S_OK;
end;


{$REGION ' TDWSProgramInfo implementation '}

constructor TDWSProgramInfo.Create(Info: TProgramInfo);
begin
	_info := Info;
end;

function TDWSProgramInfo.GetVariable(name: TUnicodeString; out rv: IDWSGenericTypeValue): HRESULT; stdcall;
var
	v : IInfo;
begin
	v := _info.Vars[name];
	if( v <> nil) then begin
		TDWSGenericTypeValue.Create(name, v).GetInterface(IDWSGenericTypeValue, rv);
		rv._AddRef;
	end else begin
		rv := nil;
	end;
	Result := S_OK;
end;

function TDWSProgramInfo.CreateTypedValue(typeName: TUnicodeString; out rv: IDWSGenericTypeValue): HRESULT; stdcall;
var
	v : IInfo;
begin
	v := _info.GetTemp(typeName);
	if (v.TypeSym.ClassName() = 'TClassSymbol')
		then v := v.Method['Create'].Call();

	if( v <> nil) then begin
		TDWSGenericTypeValue.Create('value of ' + typeName, v).GetInterface(IDWSGenericTypeValue, rv);
		rv._AddRef;
	end else begin
		rv := nil;
	end;
	Result := S_OK;
end;

function TDWSProgramInfo.GetTypeReference(name: TUnicodeString; out rv: IDWSGenericTypeValue): HRESULT; stdcall;
var
	v : IInfo;
begin
	v := _info.GetTemp(name);
	if( v <> nil) then begin
		TDWSGenericTypeValue.Create(name, v).GetInterface(IDWSGenericTypeValue, rv);
		rv._AddRef;
	end else begin
		rv := nil;
	end;
	Result := S_OK;
end;

function TDWSProgramInfo.SetResultAsString(value: TUnicodeString): HRESULT; stdcall;
begin
	_info.ResultAsString := value;
	Result := S_OK;
end;
function TDWSProgramInfo.SetResultAsBoolean(value: Boolean): HRESULT; stdcall;
begin
	_info.ResultAsBoolean := value;
	Result := S_OK;
end;
function TDWSProgramInfo.SetResultAsInt64(value: Int64): HRESULT; stdcall;
begin
	_info.ResultAsInteger := value;
	Result := S_OK;
end;
function TDWSProgramInfo.SetResultAsDouble(value: Double): HRESULT; stdcall;
begin
	_info.ResultAsFloat := value;
	Result := S_OK;
end;
function TDWSProgramInfo.SetResultAsObject(value: IDWSGenericTypeValue): HRESULT; stdcall;
var
	nativeObj : IDWSNativeGenericTypeValue;
	v : IInfo;
begin
	nativeObj := value as IDWSNativeGenericTypeValue;
	if(nativeObj <> nil) then begin
		v := nativeObj.GetInfo();
		if v <> nil then begin
			_info.ResultVars.Data := v.Data;
			Result := S_OK;
		end else begin
			Result := E_INVALIDARG;
		end;
	end else begin
		Result := E_INVALIDARG;
	end;
end;

{$ENDREGION TDWSProgramInfo}

end.
