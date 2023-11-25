codeunit 50713 "Shopping Scenario Mgt."
{
    procedure RunCustomerSessions()
    var
        Customer: Record Customer;
        ShoppingCart: Record "Shopping Cart";
        ShoppingSessionEvent: Record "Shopping Session Event";
        SessionId: Integer;
    begin
        ShoppingSessionEvent.DeleteAll();
        ShoppingCart.DeleteAll();
        Commit();

        Customer.Get('10000');
        StartSession(SessionId, Codeunit::"Customer Session", CompanyName(), Customer);

        Sleep(1000);
        Customer.Get('20000');
        StartSession(SessionId, Codeunit::"Customer Session", CompanyName(), Customer);
    end;
}