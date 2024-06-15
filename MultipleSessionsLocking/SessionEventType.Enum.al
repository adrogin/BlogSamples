enum 50702 "Session Event Type"
{
    Extensible = true;

    value(0; Start)
    {
        Caption = 'Start';
    }
    value(1; Complete)
    {
        Caption = 'Complete';
    }
    value(2; Error)
    {
        Caption = 'Error';
    }
    value(3; Stopped)
    {
        Caption = 'Stopped';
    }
    value(4; "Database Query")
    {
        Caption = 'Database query';
    }
    value(5; Wait)
    {
        Caption = 'Wait';
    }
    value(6; Commit)
    {
        Caption = 'Commit';
    }
    value(7; "Set Transaction Type")
    {
        Caption = 'Set Transaction Type';
    }
}