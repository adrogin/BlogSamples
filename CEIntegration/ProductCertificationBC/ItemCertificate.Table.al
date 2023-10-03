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
    }

    keys
    {
        key(PK; "Certificate No.")
        {
            Clustered = true;
        }
    }
}
