table 50161 "My Dimension"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; Code; Code[20])
        {
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}