table 50701 "Session Parameters"
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Session No."; Integer)
        {
            Caption = 'Session No.';
        }
        field(2; "Action No."; Integer)
        {
            Caption = 'Action No.';
        }
        field(3; Action; Enum "Session Action")
        {
            Caption = 'Action';
        }
        field(4; "First Record No."; Integer)
        {
            Caption = 'First Record No.';
        }
        field(5; "Last Record No."; Integer)
        {
            Caption = 'Last Record No.';
        }
        field(6; "Wait Time Before Locking"; Integer)
        {
            Caption = 'Wait Time Before Locking';
        }
        field(7; "Wait Time After Locking"; Integer)
        {
            Caption = 'Wait Time After Locking';
        }
        field(8; "Lock Type"; Enum "Session Lock Type")
        {
            Caption = 'Lock Type';
        }
        field(9; "Transaction Type"; Enum "Session Transaction Type")
        {
            Caption = 'Transaction Type';
        }
        field(10; "Commit After Action"; Boolean)
        {
            Caption = 'Commit After Action';
        }
    }

    keys
    {
        key(PK; "Session No.", "Action No.")
        {
            Clustered = true;
        }
    }
}