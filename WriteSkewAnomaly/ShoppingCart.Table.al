table 50711 "Shopping Cart"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
        }
        field(2; Position; Integer)
        {
            Caption = 'Position';
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(4; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
    }

    keys
    {
        key(PK; "Customer No.", Position)
        {
            Clustered = true;
        }
        key(Item; "Item No.")
        {
            SumIndexFields = Quantity;
        }
    }
}