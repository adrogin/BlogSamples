codeunit 50702 "Locking Session Controller"
{
    TableNo = "Session Parameters";

    trigger OnRun()
    begin
        DoLockingActions(Rec);
    end;

    local procedure DoLockingActions(SessionParameters: Record "Session Parameters")
    var
        SessionEventLogger: Codeunit "Session Event Logger";
        LockingAction: Codeunit "Locking Action";
    begin
        SessionEventLogger.LogEvent(SessionId(), Enum::"Session Event Type"::Start, '');
        SessionEventLogger.FlushLogBuffer(SessionId());
        Commit();

        LockingAction.SetLoggerInstance(SessionEventLogger);
        if LockingAction.Run(SessionParameters) then
            SessionEventLogger.LogEvent(SessionId(), Enum::"Session Event Type"::Complete, '')
        else
            SessionEventLogger.LogEvent(SessionId(), Enum::"Session Event Type"::Error, GetLastErrorText());

        SessionEventLogger := LockingAction.GetLoggerInstance();
        SessionEventLogger.FlushLogBuffer(SessionId());
    end;
}