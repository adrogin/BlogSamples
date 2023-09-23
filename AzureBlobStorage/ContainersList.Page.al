page 50102 "Containers List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ABS Container";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(Containers)
            {
                Caption = 'Containers';

                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    [NonDebuggable]
    procedure InitializeContainersList()
    var
        BlobStorageOperations: Codeunit "BLOB Storage Operations";
    begin
        Rec.DeleteAll();
        BlobStorageOperations.ListContainers(Rec);
    end;
}
