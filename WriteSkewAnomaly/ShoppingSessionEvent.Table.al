table 50712 "Shopping Session Event"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Session ID"; Integer)
        {
            Caption = 'Session ID';
        }
        field(2; "Event No."; Integer)
        {
            Caption = 'Event No.';
        }
        field(3; Message; Text[250])
        {
            Caption = 'Message';
        }
    }

    keys
    {
        key(PK; "Session ID", "Event No.")
        {
            Clustered = true;
        }
        key(EventDateTime; SystemCreatedAt) { }
    }
}