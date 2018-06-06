﻿namespace RemObjects.Elements.RTL.Delphi;

interface

uses
  RemObjects.Elements.RTL.Delphi;

type
  TButton = public partial class(TWinControl)
  protected
    method CreateWindowHandle(aParams: TCreateParams); override;
  end;

  TEdit = public partial class(TWinControl)
  protected
    method CreateWindowHandle(aParams: TCreateParams); override;
    method PlatformGetMaxLength: Integer;
    method PlatformSetMaxLength(aValue: Integer);
    method PlatformGetReadOnly: Boolean;
    method PlatformSetReadOnly(aValue: Boolean);
    method PlatformGetText: String;
    method PlatformSetText(aValue: String);
  end;


implementation

method TButton.CreateWindowHandle(aParams: TCreateParams);
begin
  var lArray := 'BUTTON'.ToCharArray(true);
  var lCaption := 'Button1'.ToCharArray(true);
  var lParent := if Parent <> nil then Parent.Handle else nil;
  var hInstance := rtl.GetModuleHandle(nil); // TODO

  fHandle := rtl.CreateWindowEx(0, @lArray[0], @lCaption[0], rtl.WS_CHILD or rtl.WS_TABSTOP, Left, Top, 150, 60, lParent, nil, hInstance, nil);
  fOldWndProc := InternalCalls.Cast<TWndProc>(^Void(rtl.GetWindowLongPtr(fHandle, rtl.GWL_WNDPROC)));
  rtl.SetWindowLongPtr(fHandle, rtl.GWL_WNDPROC, NativeUInt(^Void(@GlobalWndProc)));
  rtl.SetWindowLongPtr(fHandle, rtl.GWL_USERDATA, NativeUInt(InternalCalls.Cast(self)));

  // display the window on the screen
  rtl.ShowWindow(fHandle, rtl.SW_SHOW);
end;

method TEdit.CreateWindowHandle(aParams: TCreateParams);
begin
  var lArray := 'EDIT'.ToCharArray(true);
  var lCaption := 'Edit1'.ToCharArray(true);
  var lParent := if Parent <> nil then Parent.Handle else nil;
  var hInstance := rtl.GetModuleHandle(nil); // TODO

  fHandle := rtl.CreateWindowEx(0, @lArray[0], @lCaption[0], rtl.WS_BORDER or rtl.WS_CHILD or rtl.WS_TABSTOP, Left, Top, 180, 40, lParent, nil, hInstance, nil);
  //fOldWndProc := InternalCalls.Cast<TWndProc>(^Void(rtl.GetWindowLongPtr(fHandle, rtl.GWL_WNDPROC)));
  //rtl.SetWindowLongPtr(fHandle, rtl.GWL_WNDPROC, NativeUInt(^Void(@GlobalWndProc)));
  rtl.SetWindowLongPtr(fHandle, rtl.GWL_USERDATA, NativeUInt(InternalCalls.Cast(self)));

  // display the window on the screen
  rtl.ShowWindow(fHandle, rtl.SW_SHOW);
end;

method TEdit.PlatformGetMaxLength: Integer;
begin
  result := rtl.SendMessage(fHandle, rtl.EM_GETLIMITTEXT, 0, 0);
end;

method TEdit.PlatformSetMaxLength(aValue: Integer);
begin
  rtl.SendMessage(fHandle, rtl.EM_SETLIMITTEXT, aValue, 0);
end;

method TEdit.PlatformGetReadOnly: Boolean;
begin
  result := (rtl.GetWindowLongPtr(fHandle, rtl.GWL_STYLE) and rtl.ES_READONLY) > 0;
end;

method TEdit.PlatformSetReadOnly(aValue: Boolean);
begin
  rtl.SendMessage(fHandle, rtl.EM_SETREADONLY, Integer(aValue), 0);
end;

method TEdit.PlatformGetText: String;
begin
  var lMaxLength := rtl.GetWindowTextLength(fHandle);
  var lBuffer := new Char[lMaxLength + 1];
  rtl.GetWindowText(fHandle, @lBuffer[0], lMaxLength);
end;

method TEdit.PlatformSetText(aValue: String);
begin
  var lBuffer := aValue.ToCharArray(true);
  rtl.SetWindowText(fHandle, @lBuffer[0]);
end;

end.