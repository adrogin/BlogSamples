page 50700 "Locking Session Events"
{
    PageType = ListPart;
    SourceTable = "Locking Session Event";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Events)
            {
                field(EventTimeControl; EventTime)
                {
                    ApplicationArea = All;
                    Caption = 'Event Time';
                    ToolTip = 'The time of the event.';
                }
                field(EventType; Rec."Event Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates the start, stop, and error session events.';
                }
                field(EventMessage; Rec.Message)
                {
                    ApplicationArea = All;
                    ToolTip = 'Displays the error message if the session was interrupted by an error.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EventTime := DT2Time(Rec."Event DateTime");
    end;

    procedure SetSessionIdFilter(SessionId: Integer)
    begin
        Rec.SetRange("Session ID", SessionId);
    end;

    var
        EventTime: Time;
}