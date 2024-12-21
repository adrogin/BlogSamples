table 50160 "My Table With Indexes"
{
    DataClassification = CustomerContent;
    // ColumnStoreIndex =
    //     "Dimension Value 1", "Dimension Value 2", "Dimension Value 3", "Dimension Value 4", "Dimension Value 5",
    //     "Dimension Value 6", "Dimension Value 7", "Dimension Value 8", "Dimension Value 9", "Dimension Value 10",
    //     Amount;

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; Amount; Decimal)
        {
        }
        field(3; "Dimension Value 1"; Code[20])
        {
        }
        field(4; "Dimension Value 2"; Code[20])
        {
        }
        field(5; "Dimension Value 3"; Code[20])
        {
        }
        field(6; "Dimension Value 4"; Code[20])
        {
        }
        field(7; "Dimension Value 5"; Code[20])
        {
        }
        field(8; "Dimension Value 6"; Code[20])
        {
        }
        field(9; "Dimension Value 7"; Code[20])
        {
        }
        field(10; "Dimension Value 8"; Code[20])
        {
        }
        field(11; "Dimension Value 9"; Code[20])
        {
        }
        field(12; "Dimension Value 10"; Code[20])
        {
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        // key(Dim1; "Dimension Value 1") { SumIndexFields = Amount; }
        // key(Dim2; "Dimension Value 2") { SumIndexFields = Amount; }
        // key(Dim3; "Dimension Value 3") { SumIndexFields = Amount; }
        // key(Dim4; "Dimension Value 4") { SumIndexFields = Amount; }
        // key(Dim5; "Dimension Value 5") { SumIndexFields = Amount; }
        // key(Dim6; "Dimension Value 6") { SumIndexFields = Amount; }
        // key(Dim7; "Dimension Value 7") { SumIndexFields = Amount; }
        // key(Dim8; "Dimension Value 8") { SumIndexFields = Amount; }
        // key(Dim9; "Dimension Value 9") { SumIndexFields = Amount; }
        // key(Dim10; "Dimension Value 10") { SumIndexFields = Amount; }
    }
}