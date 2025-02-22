table 50181 "My Document Line"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Document No."; Code[20]) { }
        field(2; "Line No."; Integer) { }
        field(3; Description; Text[50]) { }
        field(4; "Description 2"; Text[50]) { }
        field(5; "Item No."; Code[20]) { }
        field(6; Quantity; Decimal) { }
        field(7; "Dimension 1 Value"; Code[20]) { }
        field(8; "Dimension 2 Value"; Code[20]) { }
        field(9; "Dimension 3 Value"; Code[20]) { }
        field(10; "Dimension 4 Value"; Code[20]) { }
        field(11; "Some Dummy Field 1"; Code[10]) { }
        field(12; "Some Dummy Field 2"; Code[10]) { }
        field(13; "Some Dummy Field 3"; Code[10]) { }
        field(14; "Some Dummy Field 4"; Code[10]) { }
        field(15; "Some Dummy Field 5"; Code[10]) { }
        field(16; "Some Dummy Field 6"; Code[10]) { }
        field(17; "Some Dummy Field 7"; Code[10]) { }
        field(18; "Some Dummy Field 8"; Code[10]) { }
        field(19; "Some Dummy Field 9"; Code[10]) { }
        field(20; "Some Dummy Field 10"; Code[10]) { }
    }
    
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Qty; "Item No.", "Dimension 1 Value", "Dimension 2 Value")
        {
            SumIndexFields = Quantity;
        }
    }
}
