codeunit 50702 "Locking Session Controller"
{
    TableNo = "Session Parameters";

    trigger OnRun()
    begin
        LockingMgt.LogSessionEvent(SessionId(), Enum::"Session Event Type"::Start, '');
        Commit();

        if Codeunit.Run(Codeunit::"Locking Action", Rec) then
            LockingMgt.LogSessionEvent(SessionId(), Enum::"Session Event Type"::Complete, '')
        else
            LockingMgt.LogSessionEvent(SessionId(), Enum::"Session Event Type"::Error, GetLastErrorText());
    end;

    var
        LockingMgt: Codeunit "Locking Mgt.";
}