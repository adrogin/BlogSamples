table 50901 "Item Certificate"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Certificate No."; Text[100])
        {
            Caption = 'Certificate No.';
        }
        field(2; "Item Id"; Guid)
        {
            Caption = 'Item ID';
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(4; "Item Dscription"; Text[100])
        {
            Caption = 'Item Description';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }
        field(5; "Certification Status"; Enum "Product Certification Status")
        {
            Caption = 'Certification Status';
        }
    }

    keys
    {
        key(PK; "Certificate No.")
        {
            Clustered = true;
        }
    }
}
