codeunit 50701 "Locking Mgt."
{
    procedure RunLockingScenarioModifyOneBeforeRange(): List of [Integer]
    var
        SessionIds: List of [Integer];
    begin
        InitializeTestScenario();
        SessionIds.Add(ModifyRecordsFromTop(1, 0, 35000));
        SessionIds.Add(ModifyRecordsFromBottom(15000, 2000, 10000));

        exit(SessionIds);
    end;

    procedure RunLockingScenarioModifyRangeBeforeOne(): List of [Integer]
    var
        SessionIds: List of [Integer];
    begin
        InitializeTestScenario();
        SessionIds.Add(ModifyRecordsFromTop(15000, 0, 35000));
        SessionIds.Add(ModifyRecordsFromBottom(1, 2000, 0));

        exit(SessionIds);
    end;

    procedure RunLockingScenarioModifyOneBeforeReadingRangeRepeatableRead(): List of [Integer]
    var
        SessionIds: List of [Integer];
    begin
        InitializeTestScenario();
        SessionIds.Add(ModifyRecordsFromTop(1, 0, 35000));
        SessionIds.Add(ReadRecordsFromBottom(15000, 2000, 0, Enum::"Session Lock Type"::"Repeatable Read"));

        exit(SessionIds);
    end;

    procedure RunLockingScenarioReadRangeRepeatableReadBeforeModifyOne(): List of [Integer]
    var
        SessionIds: List of [Integer];
    begin
        InitializeTestScenario();
        SessionIds.Add(ReadRecordsFromTop(15000, 0, 35000, Enum::"Session Lock Type"::"Repeatable Read"));
        SessionIds.Add(ModifyRecordsFromBottom(1, 2000, 0));

        exit(SessionIds);
    end;

    procedure RunLockingScenarioReadRangeRepeatableReadBeforeModifyNone(): List of [Integer]
    var
        SessionParameters: Record "Session Parameters";
        SessionIds: List of [Integer];
    begin
        InitializeTestScenario();
        SessionIds.Add(ReadRecordsFromTop(15000, 0, 35000, Enum::"Session Lock Type"::"Repeatable Read"));

        // Setting the first and the last entry no. to -1, so that Modify does not find anything to update
        SessionParameters := InitSessionParameters(Enum::"Session Action"::Modify, -1, -1, 2000, 0);
        SessionIds.Add(StartSessionWithParameters(SessionParameters));

        exit(SessionIds);
    end;

    procedure InitializeTestTable()
    var
        LockingTest: Record "Locking Test";
        I: Integer;
    begin
        LockingTest.DeleteAll();

        for I := 1 to GetMaxEntryNo() do
            InsertOneRecord(I);
    end;

    procedure InsertOneRecord(EntryNo: Integer)
    var
        LockingTest: Record "Locking Test";
    begin
        LockingTest."Entry No." := EntryNo;
        LockingTest.Description := System.CreateGuid();
        LockingTest.Insert();
    end;

    procedure GetMaxEntryNo(): Integer
    begin
        exit(20000);
    end;

    procedure LogSessionEvent(SessionId: Integer; EventType: Enum "Session Event Type"; EventMessage: Text)
    var
        LockingSessionEvent: Record "Locking Session Event";
    begin
        LockingSessionEvent.SetRange("Session ID", SessionId);
        if LockingSessionEvent.FindLast() then
            LockingSessionEvent.Init();

        LockingSessionEvent."Session ID" := SessionId;
        LockingSessionEvent."Event ID" += 1;
        LockingSessionEvent."Event Type" := EventType;
        LockingSessionEvent.Message := CopyStr(EventMessage, 1, MaxStrLen(LockingSessionEvent.Message));
        LockingSessionEvent.Insert();
    end;

    procedure ModifyRecordsFromTop(NoOfRecords: Integer; WaitTimeBefore: Integer; WaitTimeAfter: Integer): Integer
    var
        SessionParameters: Record "Session Parameters";
    begin
        SessionParameters := InitSessionParameters(Enum::"Session Action"::Modify, 1, NoOfRecords, WaitTimeBefore, WaitTimeAfter);
        exit(StartSessionWithParameters(SessionParameters));
    end;

    procedure ModifyRecordsFromBottom(NoOfRecords: Integer; WaitTimeBefore: Integer; WaitTimeAfter: Integer): Integer
    var
        SessionParameters: Record "Session Parameters";
    begin
        SessionParameters := InitSessionParameters(
            Enum::"Session Action"::Modify, GetMaxEntryNo() - NoOfRecords + 1, GetMaxEntryNo(), WaitTimeBefore, WaitTimeAfter);
        exit(StartSessionWithParameters(SessionParameters));
    end;

    procedure ReadRecordsFromTop(NoOfRecords: Integer; WaitTimeBefore: Integer; WaitTimeAfter: Integer; LockType: Enum "Session Lock Type"): Integer
    var
        SessionParameters: Record "Session Parameters";
    begin
        SessionParameters := InitSessionParameters(Enum::"Session Action"::Read, 1, NoOfRecords, WaitTimeBefore, WaitTimeAfter, LockType);
        exit(StartSessionWithParameters(SessionParameters));
    end;

    procedure ReadRecordsFromBottom(NoOfRecords: Integer; WaitTimeBefore: Integer; WaitTimeAfter: Integer; LockType: Enum "Session Lock Type"): Integer
    var
        SessionParameters: Record "Session Parameters";
    begin
        SessionParameters := InitSessionParameters(
            Enum::"Session Action"::Read, GetMaxEntryNo() - NoOfRecords + 1, GetMaxEntryNo(), WaitTimeBefore, WaitTimeAfter, LockType);
        exit(StartSessionWithParameters(SessionParameters));
    end;

    procedure GetLastSessionIDs(): List of [Integer]
    var
        LockingSessionEvent: Record "Locking Session Event";
        SessionIDs: List of [Integer];
    begin
        if LockingSessionEvent.FindSet() then
            repeat
                if not SessionIDs.Contains(LockingSessionEvent."Session ID") then
                    SessionIDs.Add(LockingSessionEvent."Session ID");
            until LockingSessionEvent.Next() = 0;

        exit(SessionIDs);
    end;

    procedure IsSessionActive(SessionID: Integer): Boolean
    var
        ActiveSession: Record "Active Session";
    begin
        ActiveSession.SetRange("Session ID", SessionID);
        exit(not ActiveSession.IsEmpty());
    end;

    local procedure InitializeTestScenario()
    begin
        VerifyTestNotRunning();
        ClearTables();
    end;

    local procedure InitSessionParameters(
        Action: Enum "Session Action"; FirstRecorsNo: Integer; LastRecordNo: Integer; WaitTimeBefore: Integer; WaitTimeAfter: Integer; LockType: Enum "Session Lock Type"): Record "Session Parameters"
    var
        SessionParameters: Record "Session Parameters";
    begin
        SessionParameters.Action := Action;
        SessionParameters."First Record No." := FirstRecorsNo;
        SessionParameters."Last Record No." := LastRecordNo;
        SessionParameters."Wait Time Before Locking" := WaitTimeBefore;
        SessionParameters."Wait Time After Locking" := WaitTimeAfter;
        SessionParameters."Lock Type" := LockType;
        SessionParameters.Insert();

        exit(SessionParameters);
    end;

    local procedure InitSessionParameters(
        Action: Enum "Session Action"; FirstRecorsNo: Integer; LastRecordNo: Integer; WaitTimeBefore: Integer; WaitTimeAfter: Integer): Record "Session Parameters"
    begin
        exit(InitSessionParameters(Action, FirstRecorsNo, LastRecordNo, WaitTimeBefore, WaitTimeAfter, Enum::"Session Lock Type"::Default));
    end;

    local procedure StartSessionWithParameters(SessionParameters: Record "Session Parameters"): Integer
    var
        SessionId: Integer;
    begin
        StartSession(SessionId, Codeunit::"Locking Session Controller", CompanyName, SessionParameters);
        exit(SessionId);
    end;

    procedure ClearTables()
    var
        SessionParameters: Record "Session Parameters";
        LockingSessionEvent: Record "Locking Session Event";
    begin
        SessionParameters.DeleteAll();
        LockingSessionEvent.DeleteAll();
    end;

    procedure StopActiveSessions()
    var
        SessionIDs: List of [Integer];
        SessionId: Integer;
    begin
        SessionIDs := GetLastSessionIDs();
        foreach SessionId in SessionIDs do
            if IsSessionActive(SessionId) then begin
                StopSession(SessionId);
                LogSessionEvent(SessionId, Enum::"Session Event Type"::Stopped, 'Session was stopped by the user');
            end;
    end;

    local procedure VerifyTestNotRunning()
    var
        SessionIDs: List of [Integer];
        SessionId: Integer;
        TestSessionActiveErr: Label 'Test session is currently active. Wait for the current test to complete or stop it before starting a new test.';
    begin
        SessionIDs := GetLastSessionIDs();
        if SessionIDs.Count = 0 then
            exit;

        foreach SessionId in SessionIDs do
            if IsSessionActive(SessionId) then
                Error(TestSessionActiveErr);
    end;
}