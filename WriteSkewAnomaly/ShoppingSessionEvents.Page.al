page 50712 "Shopping Session Events"
{
    PageType = ListPart;
    SourceTable = "Shopping Session Event";
    SourceTableView = sorting(SystemCreatedAt) order(ascending);
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(ShoppingCardEvents)
            {
                field(EventTime; DT2Time(Rec.SystemCreatedAt))
                {
                    ApplicationArea = All;
                    Caption = 'Event Time';
                    ToolTip = 'The time when the event was logged.';
                }
                field("Session ID"; Rec."Session ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'System ID of the background session.';
                }
                field(Message; Rec.Message)
                {
                    ApplicationArea = All;
                    ToolTip = 'The text description ofthe session event.';
                }
            }
        }
    }
}