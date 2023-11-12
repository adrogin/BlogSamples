enum 50700 "Session Lock Type"
{
    Extensible = true;

    value(0; Default)
    {
        Caption = 'Default';
    }
    value(1; "Read Uncommitted")
    {
        Caption = 'Read Uncommitted';
    }
    value(2; "Read Committed")
    {
        Caption = 'Read Committed';
    }
    value(3; "Repeatable Read")
    {
        Caption = 'Repeatable Read';
    }
    value(4; LockTable)
    {
        Caption = 'LockTable';
    }
}