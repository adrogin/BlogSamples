page 50180 "Deadlock Test"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;

    actions
    {
        area(Processing)
        {
            action(RunDeadlockTest)
            {
                Caption = 'Run Deadlock Test';
                ApplicationArea = All;

                trigger OnAction()
                var
                    SessionId: Integer;
                begin
                    StartSession(SessionId, Codeunit::"Insert Document 1");
                    StartSession(SessionId, Codeunit::"Insert Document 2");
                end;
            }
            action(InsertDocument)
            {
                Caption = 'Insert Document';
                ApplicationArea = All;

                trigger OnAction()
                var
                    InsertDocument2: Codeunit "Insert Document 2";
                begin
                    InsertDocument2.Run();
                end;
            }
            action(DeleteDocuments)
            {
                Caption = 'Delete Documents';
                ApplicationArea = All;

                trigger OnAction()
                var
                    MyDocumentHeader: Record "My Document Header";
                    MyDocumentLine: Record "My Document Line";
                begin
                    MyDocumentHeader.DeleteAll();
                    MyDocumentLine.DeleteAll();
                end;
            }
        }
    }
}