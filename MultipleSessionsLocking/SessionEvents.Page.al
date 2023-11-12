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
                field(EventDateTime; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(EventTimeControl; EventTime)
                {
                    ApplicationArea = All;
                    Caption = 'Event Time';
                }
                field(EventType; Rec."Event Type")
                {
                    ApplicationArea = All;
                }
                field(EventMessage; Rec.Message)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EventTime := DT2Time(Rec.SystemCreatedAt);
    end;

    procedure SetSessionIdFilter(SessionId: Integer)
    begin
        Rec.SetRange("Session ID", SessionId);
    end;

    var
        EventTime: Time;
}