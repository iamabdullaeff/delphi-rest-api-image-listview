unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, IPPeerClient,
  REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Controls.Presentation,
  FMX.StdCtrls, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt,System.JSON,DBXJSON,XSuperObject,XSuperJSON,
  FMX.ListBox, FMX.Layouts, FMX.Objects , FMX.Devgear.HelperClass,
  Data.Bind.GenData, Fmx.Bind.GenData;

type
  TForm1 = class(TForm)
    ToolBar1: TToolBar;
    ListView1: TListView;
    Button1: TButton;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    this_element_id:integer;
  end;

var
  {Global variables here}
  Form1: TForm1;
  default_image: TResourceStream;
  page_number:integer;
  last_index:integer;

implementation

{$R *.fmx}

//uses Unit2;

procedure TForm1.Button1Click(Sender: TObject);
var
  X: ISuperObject;
  data_status:ISuperObject;
  enum: TSuperEnumerator<IJSONAncestor>;
  data_body_element:ISuperObject;
  list_title,list_desc,list_image,list_id:string;
begin
    page_number:=0;
    RESTClient1.BaseURL:='http://api.domain.com/v1/controller/function/function';
    RESTClient1.Params.Clear;
    RESTClient1.Params.Add;
    RESTClient1.Params.Add;
    RESTClient1.Params.Add;
    RESTClient1.Params[0].name:='masterkey';
    RESTClient1.Params[0].Value:='*********';
    RESTClient1.Params[1].name:='page_number';
    RESTClient1.Params[1].Value:=IntToStr(page_number);
    RESTClient1.Params[2].name:='limit';
    RESTClient1.Params[2].Value:='10';
    RESTRequest1.Execute;
    RESTRequest1.Execute;
    X := SO(RESTResponse1.Content);
    data_status:=X['status'].AsObject;
    if data_status['code'].AsString='200' then
    begin
        ListView1.Items.Clear;
        ListView1.BeginUpdate;
        enum := X['body'].AsArray.GetEnumerator;
        while enum.MoveNext do
        begin
            data_body_element := enum.Current.AsObject;
            list_id:=data_body_element.S['id'];
            list_title:=data_body_element.S['manufacturer']+' '+data_body_element.S['model'];
            list_desc:='Model Number: '+data_body_element.S['model_number'];
            list_image:=data_body_element.S['image_url'];
            ListView1.Items.Add;
            ListView1.Items.AppearanceItem[enum.Index].Text:=list_title;
            ListView1.Items.AppearanceItem[enum.Index].Detail:=list_desc;
            ListView1.Items.AppearanceItem[enum.Index].Tag:=StrToInt(list_id);
            if list_image='' then
              ListView1.Items.AppearanceItem[enum.Index].Bitmap.LoadFromStream(default_image)
            else
            ListView1.Items.AppearanceItem[enum.Index].Bitmap.LoadThumbnailFromUrl(list_image,10,10);

        end;
        ListView1.EndUpdate;
        page_number:=1;
        last_index:=enum.Index+1;
    end
    else
    begin
      ShowMessage(data_status['message'].AsString);
    end;
end;


procedure TForm1.Button2Click(Sender: TObject);
var
  X: ISuperObject;
  data_status:ISuperObject;
  enum: TSuperEnumerator<IJSONAncestor>;
  data_body_element:ISuperObject;
  list_title,list_desc,list_id,list_image:string;
begin
    RESTClient1.BaseURL:='http://api.domain.com/v1/controller/function/function';
    RESTClient1.Params.Clear;
    RESTClient1.Params.Add;
    RESTClient1.Params.Add;
    RESTClient1.Params.Add;
    RESTClient1.Params[0].name:='masterkey';
    RESTClient1.Params[0].Value:='*********';
    RESTClient1.Params[1].name:='page_number';
    RESTClient1.Params[1].Value:=IntToStr(page_number);
    RESTClient1.Params[2].name:='limit';
    RESTClient1.Params[2].Value:='10';
    RESTRequest1.Execute;
    X := SO(RESTResponse1.Content);
    data_status:=X['status'].AsObject;
    if data_status['code'].AsString='200' then
    begin
        ListView1.BeginUpdate;
        enum := X['body'].AsArray.GetEnumerator;
        while enum.MoveNext do
        begin
            data_body_element := enum.Current.AsObject;
            list_id:=data_body_element.S['id'];
            list_title:=data_body_element.S['manufacturer']+' '+data_body_element.S['model'];
            list_desc:='Model Number: '+data_body_element.S['model_number'];
            list_image:=data_body_element.S['image_url'];
            ListView1.Items.Add;
            ListView1.Items.AppearanceItem[last_index+enum.Index].Text:=list_title;
            ListView1.Items.AppearanceItem[last_index+enum.Index].Detail:=list_desc;
            ListView1.Items.AppearanceItem[last_index+enum.Index].Tag:=StrToInt(list_id);
            if list_image='' then
              ListView1.Items.AppearanceItem[last_index+enum.Index].Bitmap.LoadFromStream(default_image)
            else
            ListView1.Items.AppearanceItem[last_index+enum.Index].Bitmap.LoadThumbnailFromUrl(list_image,10,10);
            ListView1.Items.AppearanceItem[last_index+enum.Index].Objects.DetailObject.WordWrap:=false;
        end;
        ListView1.EndUpdate;
        page_number:=page_number+1;
        last_index:=last_index+enum.Index+1;
    end
    else
    begin
      ShowMessage(data_status['message'].AsString);
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
default_image := TResourceStream.Create(hInstance, 'no_image', RT_RCDATA);
page_number:=0;
end;

procedure TForm1.ListView1ItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  this_element_id:=AItem.Tag;
  //ShowMessage(IntToStr(this_element_id));
  //Form2.Show;
  //Form1.Hide;
end;

end.
