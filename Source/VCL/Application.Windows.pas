﻿namespace RemObjects.Elements.RTL.Delphi.VCL;

interface

type
  TApplication = public partial class(TComponent)
  public
    method CreateForm(InstanceClass: TComponentClass; var aFormRef); partial;
    method Initialize; partial;
    method Run; partial;
    method Terminate; partial;
  end;

implementation

method TApplication.CreateForm(InstanceClass: TComponentClass; var aFormRef);
begin
  var lCtor: MethodInfo;
  var FormRef: TForm := TForm(aFormRef);

  var lCtors := InstanceClass.Methods.Where(a -> ((MethodFlags.Constructor in a.Flags) and (a.Arguments.Count > 0)));
  if lCtors.Count > 1 then begin
    for each lTemp in lCtors do begin
      var lArguments := lTemp.Arguments.ToList;
      if lArguments[0].Type = typeOf(TComponent) then begin
        lCtor := lTemp;
        break;
      end;
    end;
  end
  else
    lCtor := lCtors.FirstOrDefault;

  if lCtor = nil then raise new Exception('No default constructor could be found!');
  var lNew := DefaultGC.New(InstanceClass.RTTI, InstanceClass.SizeOfType);
  FormRef := InternalCalls.Cast<TForm>(lNew);
  lCtor.Invoke(FormRef, [nil]);
  aFormRef := FormRef;
end;

method TApplication.Initialize;
begin

end;

method TApplication.Run;
begin
  var lMsg: rtl.MSG;

  while not Finished do begin
    if rtl.PeekMessageW(@lMsg, nil, 0, 0, rtl.PM_REMOVE) then begin
      rtl.TranslateMessage(@lMsg);
      rtl.DispatchMessage(@lMsg);
    end;

    if lMsg.message = rtl.WM_QUIT then
      Terminate;
  end;
end;

method TApplication.Terminate;
begin
  fFinished := true;
end;

end.