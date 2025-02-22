table 50180 "My Document Header"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "No."; Code[20]) { }
        field(2; Description; Text[50]) { }
        field(3; "Item No."; Code[20]) { }
        field(4; Quantity; Decimal) { }
    }
    
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Qty; "Item No.")
        {
            SumIndexFields = Quantity;
        }
    }
}