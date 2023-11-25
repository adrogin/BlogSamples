page 50713 "Cart Content"
{
    PageType = ListPart;
    SourceTable = "Shopping Cart";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(CartItems)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'The number of the customer owning the shopping cart.';
                }
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'The number of the item which the customer put in the cart.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'The quantity of the item in the cart, in the base unit of measure.';
                }
            }
        }
    }
}