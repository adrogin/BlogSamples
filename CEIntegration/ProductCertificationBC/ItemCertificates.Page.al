page 50900 "Item Certifiates"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Item Certificate";

    layout
    {
        area(Content)
        {
            repeater(Certificates)
            {
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Item Dscription"; Rec."Item Dscription")
                {
                    ApplicationArea = All;
                }
                field(CertificateNo; Rec."Certificate No.")
                {
                    ApplicationArea = All;
                }
                field("Certificate Status"; Rec."Certification Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
