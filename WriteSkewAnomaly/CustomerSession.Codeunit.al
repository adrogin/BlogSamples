codeunit 50712 "Customer Session"
{
    TableNo = Customer;

    trigger OnRun()
    begin
        RunShoppingScenario(Rec."No.");
    end;

    procedure RunShoppingScenario(CustomerNo: Code[20])
    var
        ShoppingCartMgt: Codeunit "Shopping Cart Mgt.";
    begin
        ShoppingCartMgt.AddItemToCart(CustomerNo, 'LS-150', 3);
        Commit();

        Sleep(5000);
        ShoppingCartMgt.UpdateItemQty(CustomerNo, 'LS-150', 5);
        Sleep(5000);
    end;
}