table 50702 "Locking Session Event"
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Session ID"; Integer)
        {
            Caption = 'Session ID';
        }
        field(2; "Event ID"; Integer)
        {
            Caption = 'Event ID';
        }
        field(3; "Event Type"; Enum "Session Event Type")
        {
            Caption = 'Event Type';
        }
        field(4; Message; Text[250])
        {
            Caption = 'Message';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Session ID", "Event ID")
        {
            Clustered = true;
        }
    }
}