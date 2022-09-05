table 90150 "Dictionary Entry DT"
{
    Caption = 'Dictionary Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Source Language"; Text[10])
        {
            Caption = 'Source Language';
        }
        field(3; "Dest. Language"; Text[10])
        {
            Caption = 'Destination Language';
        }
        field(4; "Source Text"; Text[250])
        {
            Caption = 'Source Text';
        }
        field(5; "Dest. Text"; Text[250])
        {
            Caption = 'Destination Text';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(SrcDest; "Source Language", "Dest. Language") { }
        key(SourceText; "Source Text", "Source Language") { }
        key(DestSrc; "Dest. Language", "Source Language") { }
    }
}