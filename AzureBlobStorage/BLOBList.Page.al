page 50100 "BLOB List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ABS Container Content";
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

                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                }
                field(FullName; Rec."Full Name")
                {
                    ApplicationArea = All;
                    Caption = 'Full Name';
                }
                field(Level; Rec.Level)
                {
                    ApplicationArea = All;
                    Caption = 'Level';
                }
                field(ParentDirectory; Rec."Parent Directory")
                {
                    ApplicationArea = All;
                    Caption = 'Parent Directory';
                }
                field(ContentType; Rec."Content Type")
                {
                    ApplicationArea = All;
                    Caption = 'Content Type';
                }
                field(ContentLength; Rec."Content Length")
                {
                    ApplicationArea = All;
                    Caption = 'Content Length';
                }
                field(BlobType; Rec."Blob Type")
                {
                    ApplicationArea = All;
                    Caption = 'Blob Type';
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
                ToolTip = 'Upload a file from the local file system to the Azure BLOB Storage.';

                trigger OnAction();
                var
                    BlobStorageOperations: Codeunit "BLOB Storage Operations";
                begin
                    BlobStorageOperations.UploadFile();
                end;
            }
            action(ListBlobs)
            {
                ApplicationArea = All;
                Caption = 'List Blobs';
                ToolTip = 'Retrieve the list of BLOBs from the Azure BLOB Storage.';

                trigger OnAction();
                var
                    BlobStorageOperations: Codeunit "BLOB Storage Operations";
                begin
                    BlobStorageOperations.ListBlobsInContainer(Rec);
                end;
            }
            action(DeleteBlob)
            {
                ApplicationArea = All;
                Caption = 'Delete BLOB';
                ToolTip = 'Delete the selected BLOB.';

                trigger OnAction();
                var
                    BlobStorageOperations: Codeunit "BLOB Storage Operations";
                begin
                    BlobStorageOperations.DeleteBlob(Rec."Full Name");
                end;
            }
        }
    }
}
