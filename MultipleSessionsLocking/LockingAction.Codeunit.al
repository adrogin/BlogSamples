codeunit 50700 "Locking Action"
{
    TableNo = "Session Parameters";

    trigger OnRun()
    var
        TempSessionParameters: Record "Session Parameters" temporary;
    begin
        // Reading session parameters into a temporary table to start a clean transaction and avoid polluting the test session with queries against setup tables
        // SetTransaction Type does not work after any database query
        ReadParametersToTempTable(TempSessionParameters, Rec);
        Commit();
        DoLockingAction(TempSessionParameters);
    end;

    local procedure DoLockingAction(var SessionParameters: Record "Session Parameters")
    var
        LockingTest: Record "Locking Test";
        LockingScenarios: Codeunit "Locking Scenarios";
    begin
        SessionParameters.FindSet();
        repeat
            SetTransactionType(SessionParameters."Transaction Type");

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
                    LockingScenarios.InsertRecords(SessionParameters."First Record No.", SessionParameters."Last Record No.");
                SessionParameters.Action::Modify:
                    LockingTest.ModifyAll(Description, System.CreateGuid());
                SessionParameters.Action::Delete:
                    LockingTest.DeleteAll();
            end;

            SessionEventLogger.LogWait(SessionId(), SessionParameters."Wait Time After Locking");
            Sleep(SessionParameters."Wait Time After Locking");

            if SessionParameters."Commit After Action" then
                CommitTransaction();
        until SessionParameters.Next() = 0;
    end;

    local procedure ReadParametersToTempTable(var TempSessionParameters: Record "Session Parameters" temporary; var SrcSessionParameters: Record "Session Parameters")
    begin
        TempSessionParameters.Reset();
        TempSessionParameters.DeleteAll();

        SrcSessionParameters.SetRange("Session No.", SrcSessionParameters."Session No.");
        SrcSessionParameters.FindSet();
        repeat
            TempSessionParameters := SrcSessionParameters;
            TempSessionParameters.Insert();
        until SrcSessionParameters.Next() = 0;
    end;

    procedure SetLoggerInstance(SessionEventLoggerInstance: Codeunit "Session Event Logger")
    begin
        SessionEventLogger := SessionEventLoggerInstance;
    end;

    procedure GetLoggerInstance(): Codeunit "Session Event Logger"
    begin
        exit(SessionEventLogger);
    end;

    local procedure CommitTransaction()
    begin
        SessionEventLogger.LogCommit(SessionId());
        Commit();
    end;

    local procedure SetTransactionType(NewTransactionType: Enum "Session Transaction Type")
    begin
        if NewTransactionType = Enum::"Session Transaction Type"::Default then
            exit;

        case NewTransactionType of
            NewTransactionType::UpdateNoLocks:
                CurrentTransactionType := TransactionType::UpdateNoLocks;
            NewTransactionType::Update:
                CurrentTransactionType := TransactionType::Update;
            NewTransactionType::Browse:
                CurrentTransactionType := TransactionType::Browse;
            NewTransactionType::Report:
                CurrentTransactionType := TransactionType::Report;
            NewTransactionType::Snapshot:
                CurrentTransactionType := TransactionType::Snapshot;
        end;

        SessionEventLogger.LogTransactionTypeChange(SessionId(), NewTransactionType);
    end;

    var
        SessionEventLogger: Codeunit "Session Event Logger";
}