table 90151 "Dict. Language DT"
{
    Caption = 'Dictionary Language';
    DataClassification = CustomerContent;
    LookupPageId = "Dict. Language List DT";

    fields
    {
        field(1; "Code"; Text[10])
        {
            Caption = 'Code';
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}