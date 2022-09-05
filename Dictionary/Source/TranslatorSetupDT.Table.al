table 90152 "Translator Setup DT"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Translation Provider"; Enum "Translation Service DT")
        {
            Caption = 'Translation Provider';
        }
        field(3; URI; Text[250])
        {
            Caption = 'URL';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(4; "Request Parameters"; Text[250])
        {
            Caption = 'Request Parameters';
            DataClassification = AccountData;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}