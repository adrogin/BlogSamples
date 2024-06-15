enum 50703 "Session Transaction Type"
{
    Extensible = true;

    value(0; Default)
    {
        Caption = 'Default (No change)';
    }
    value(1; UpdateNoLocks)
    {
        Caption = 'UpdateNoLocks';
    }
    value(2; Update)
    {
        Caption = 'Update';
    }
    value(3; Snapshot)
    {
        Caption = 'Snapshot';
    }
    value(4; Browse)
    {
        Caption = 'Browse';
    }
    value(5; Report)
    {
        Caption = 'Report';
    }
}