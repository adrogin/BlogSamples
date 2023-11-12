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
}