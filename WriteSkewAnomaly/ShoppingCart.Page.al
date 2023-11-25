page 50711 "Shopping Cart"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(ShoppingCartList)
            {
                ShowCaption = false;

                part(CartContent; "Cart Content")
                {
                    ApplicationArea = All;
                }
            }
            group(Events)
            {
                ShowCaption = false;

                part(ShoppingCartEvents; "Shopping Session Events")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RunCustomerSessions)
            {
                ApplicationArea = All;
                Caption = 'Run Customer Sessions';
                ToolTip = 'Start the background sessions simulating concurrent customers updating their shopping carts.';
                Image = Start;

                trigger OnAction();
                var
                    ShoppingScenarioMgt: Codeunit "Shopping Scenario Mgt.";
                begin
                    ShoppingScenarioMgt.RunCustomerSessions();
                end;
            }
            action(UpdatePage)
            {
                ApplicationArea = All;
                Caption = 'Update Page';
                ToolTip = 'Get the updated shopping carts and session events from background sessions.';
                Image = Refresh;

                trigger OnAction()
                begin
                    CurrPage.Update(false);
                end;
            }
        }
        area(Promoted)
        {
            actionref(RunSessionsPromoted; RunCustomerSessions) { }
            actionref(UpdatePagePromoted; UpdatePage) { }
        }
    }
}