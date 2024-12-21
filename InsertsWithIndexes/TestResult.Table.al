table 50162 "Test Result"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Test Run"; Integer)
        { }
        field(2; Iteration; Integer)
        { }
        field(3; Description; Text[100])
        { }
        field(4; "Run Time"; Integer)
        { }
    }

    keys
    {
        key(PK; "Test Run", Iteration)
        {
            Clustered = true;
        }
    }
}