codeunit 50700 "Locking Action"
{
    TableNo = "Session Parameters";

    trigger OnRun()
    begin
        DoLockingAction(Rec);
    end;

    local procedure DoLockingAction(SessionParametersSet: Record "Session Parameters")
    var
        SessionParameters: Record "Session Parameters";
        LockingTest: Record "Locking Test";
        LockingMgt: Codeunit "Locking Mgt.";
    begin
        SessionParameters.SetRange("Session No.", SessionParametersSet."Session No.");
        SessionParameters.FindSet();
        repeat
            SessionEventLogger.LogWait(SessionId(), SessionParameters."Wait Time Before Locking");
            Sleep(SessionParameters."Wait Time Before Locking");
            SessionEventLogger.LogAction(SessionId(), SessionParameters);

            case SessionParameters."Lock Type" of
                SessionParameters."Lock Type"::"Read Uncommitted":
                    LockingTest.ReadIsolation := LockingTest.ReadIsolation::ReadUncommitted;
                SessionParameters."Lock Type"::"Read Committed":
                    LockingTest.ReadIsolation := LockingTest.ReadIsolation::ReadCommitted;
                SessionParameters."Lock Type"::"Repeatable Read":
                    LockingTest.ReadIsolation := LockingTest.ReadIsolation::RepeatableRead;
                SessionParameters."Lock Type"::UpdLock:
                    LockingTest.ReadIsolation := LockingTest.ReadIsolation::UpdLock;
                SessionParameters."Lock Type"::LockTable:
                    LockingTest.LockTable();
            end;

            if SessionParameters.Action in [SessionParameters.Action::Read, SessionParameters.Action::Modify, SessionParameters.Action::Delete] then
                LockingTest.SetRange("Entry No.", SessionParameters."First Record No.", SessionParameters."Last Record No.");

            case SessionParameters.Action of
                SessionParameters.Action::Read:
                    begin
                        LockingTest.FindSet();
                        LockingTest.Next(SessionParameters."Last Record No.");
                    end;
                SessionParameters.Action::Insert:
                    LockingMgt.InsertOneRecord(LockingMgt.GetMaxEntryNo() + 1);
                SessionParameters.Action::Modify:
                    LockingTest.ModifyAll(Description, System.CreateGuid());
                SessionParameters.Action::Delete:
                    LockingTest.DeleteAll();
            end;

            SessionEventLogger.LogWait(SessionId(), SessionParameters."Wait Time After Locking");
            Sleep(SessionParameters."Wait Time After Locking");
        until SessionParameters.Next() = 0;
    end;

    procedure SetLoggerInstance(SessionEventLoggerInstance: Codeunit "Session Event Logger")
    begin
        SessionEventLogger := SessionEventLoggerInstance;
    end;

    procedure GetLoggerInstance(): Codeunit "Session Event Logger"
    begin
        exit(SessionEventLogger);
    end;

    var
        SessionEventLogger: Codeunit "Session Event Logger";
}