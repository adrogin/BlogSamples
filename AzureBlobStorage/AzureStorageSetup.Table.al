table 50100 "Azure Storage Setup"
{
    DataClassification = EndUserIdentifiableInformation;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Storage Account Name"; Text[100])
        {
            Caption = 'Storage Account Name';
        }
        field(3; "Access Key"; Text[100])
        {
            Caption = 'Access Key';
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
