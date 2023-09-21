page 50101 "Azure Storage Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Azure Storage Setup";

    layout
    {
        area(Content)
        {
            group(Setup)
            {
                Caption = 'Setup';

                field(StorageAccountName; Rec."Storage Account Name")
                {
                    ApplicationArea = All;
                }
                field(AccessKey; Rec."Access Key")
                {
                    ApplicationArea = All;
                    HideValue = true;
                }
            }
        }
    }
}
