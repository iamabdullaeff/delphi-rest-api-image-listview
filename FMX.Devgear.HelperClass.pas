unit FMX.Devgear.HelperClass;

interface

uses
  System.Classes, FMX.Graphics;

type
  TBitmapHelper = class helper for TBitmap
  public
    procedure LoadFromUrl(AUrl: string);

    procedure LoadThumbnailFromUrl(AUrl: string; const AFitWidth, AFitHeight: Integer);
  end;

implementation

uses
  System.SysUtils, System.Types, IdHttp, IdTCPClient, AnonThread;

procedure TBitmapHelper.LoadFromUrl(AUrl: string);
var
  _Thread: TAnonymousThread<TMemoryStream>;
begin
  _Thread := TAnonymousThread<TMemoryStream>.Create(
    function: TMemoryStream
    var
      Http: TIdHttp;
    begin
      Result := TMemoryStream.Create;
      Http := TIdHttp.Create(nil);
      try
        try
          Http.Request.UserAgent:='Mozilla/5.0 (Windows NT 6.1; WOW64;rv:12.0) Gecko/20100101 Firefox/12.0';
          Http.Get(AUrl, Result);
        except
          Result.Free;
        end;
      finally
        Http.Free;
      end;
    end,
    procedure(AResult: TMemoryStream)
    begin
      if AResult.Size > 0 then
        LoadFromStream(AResult);
      AResult.Free;
    end,
    procedure(AException: Exception)
    begin
    end
  );
end;

procedure TBitmapHelper.LoadThumbnailFromUrl(AUrl: string; const AFitWidth,
  AFitHeight: Integer);
var
  Bitmap: TBitmap;
  scale: Single;
begin
  LoadFromUrl(AUrl);
  if (Width>0) and (Height>0) then
  begin
      scale := RectF(0, 0, Width, Height).Fit(RectF(0, 0, AFitWidth, AFitHeight));
      Bitmap := CreateThumbnail(Round(Width / scale), Round(Height / scale));
  end
  else
  begin
      scale := RectF(0, 0, 0, 0).Fit(RectF(0, 0, 0, 0));
      Bitmap := CreateThumbnail(Round(0 / scale), Round(0 / scale));
  end;
  try
    Assign(Bitmap);
  finally
    Bitmap.Free;
  end;
end;

end.
