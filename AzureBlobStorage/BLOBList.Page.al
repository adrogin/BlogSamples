page 50100 "BLOB List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Name/Value Buffer";
    SourceTableTemporary = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Caption = 'BLOB List';

    layout
    {
        area(Content)
        {
            repeater(BLOBObjects)
            {
                Caption = 'BLOB Objects';

                field(Name; Rec.Value)
                {
                    ApplicationArea = All;
                    Caption = 'BLOB Name';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(UploadFile)
            {
                ApplicationArea = All;
                Caption = 'Upload File';
                ToolTip = 'Upload a file from the local file system to the Azure BLOB Storage';

                trigger OnAction();
                var
                    BlobStorageOperations: Codeunit "BLOB Storage Operations";
                begin
                    BlobStorageOperations.UploadFile();
                end;
            }
        }
    }
}
