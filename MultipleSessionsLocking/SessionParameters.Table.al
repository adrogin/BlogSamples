table 50701 "Session Parameters"
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Session No."; Integer)
        {
            Caption = 'Session No.';
            AutoIncrement = true;
        }
        field(2; Action; Enum "Session Action")
        {
            Caption = 'Action';
        }
        field(3; "First Record No."; Integer)
        {
            Caption = 'First Record No.';
        }
        field(4; "Last Record No."; Integer)
        {
            Caption = 'Last Record No.';
        }
        field(5; "Wait Time Before Locking"; Integer)
        {
            Caption = 'Wait Time Before Locking';
        }
        field(6; "Wait Time After Locking"; Integer)
        {
            Caption = 'Wait Time After Locking';
        }
        field(7; "Lock Type"; Enum "Session Lock Type")
        {
            Caption = 'Lock Type';
        }
    }

    keys
    {
        key(PK; "Session No.")
        {
            Clustered = true;
        }
    }
}