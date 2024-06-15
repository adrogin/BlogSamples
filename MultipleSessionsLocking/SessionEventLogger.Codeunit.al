codeunit 50703 "Session Event Logger"
{
    procedure LogAction(SessionId: Integer; SessionParameters: Record "Session Parameters")
    begin
        Log(SessionId, Enum::"Session Event Type"::"Database Query", FormatEventMessage(SessionParameters));
    end;

    procedure LogCommit(SessionId: Integer)
    var
        CommitEventLbl: Label 'Commit';
    begin
        Log(SessionId, Enum::"Session Event Type"::Commit, CommitEventLbl);
    end;

    procedure LogEvent(SessionId: Integer; EventType: Enum "Session Event Type"; LogMessage: Text)
    begin
        Log(SessionId, EventType, LogMessage);
    end;

    procedure LogTransactionTypeChange(SessionId: Integer; TransactionType: Enum "Session Transaction Type")
    var
        ChangeTransactionTypeLbl: Label 'Setting the trnsaction type to %1', Comment = '%1: New trnsaction type to be set.';
    begin
        Log(SessionId, Enum::"Session Event Type"::"Set Transaction Type", StrSubstNo(ChangeTransactionTypeLbl, TransactionType));
    end;

    procedure LogWait(SessionId: Integer; WaitTime: Integer)
    var
        WaitEventLbl: Label 'Waiting for %1 ms.', Locked = true;
    begin
        if WaitTime > 0 then
            Log(SessionId, Enum::"Session Event Type"::Wait, StrSubstNo(WaitEventLbl, WaitTime));
    end;

    procedure Initialize(SessionId: Integer)
    var
        LockingSessionEvent: Record "Locking Session Event";
    begin
        LockingSessionEvent.SetRange("Session ID", SessionId);
        LockingSessionEvent.DeleteAll();

        TempLockingSessionEvent.DeleteAll();
    end;

    procedure FlushLogBuffer(SessionId: Integer)
    var
        LockingSessionEvent: Record "Locking Session Event";
        NextEventId: Integer;
    begin
        if TempLockingSessionEvent.FindSet() then begin
            LockingSessionEvent.SetRange("Session ID", SessionId);
            if LockingSessionEvent.FindLast() then
                NextEventId := LockingSessionEvent."Event ID" + 1
            else
                NextEventId := 1;

            repeat
                LockingSessionEvent := TempLockingSessionEvent;
                LockingSessionEvent."Event ID" := NextEventId;
                LockingSessionEvent.Insert();
                NextEventId += 1;
            until TempLockingSessionEvent.Next() = 0;
        end;

        TempLockingSessionEvent.DeleteAll();
    end;

    local procedure Log(SessionId: Integer; EventType: Enum "Session Event Type"; LogMessage: Text)
    begin
        TempLockingSessionEvent.SetRange("Session ID", SessionId);
        if TempLockingSessionEvent.FindLast() then
            TempLockingSessionEvent.Init();

        TempLockingSessionEvent."Session ID" := SessionId;
        TempLockingSessionEvent."Event ID" += 1;
        TempLockingSessionEvent."Event Type" := EventType;
        TempLockingSessionEvent.Message := CopyStr(LogMessage, 1, MaxStrLen(TempLockingSessionEvent.Message));
        TempLockingSessionEvent."Event DateTime" := CurrentDateTime();
        TempLockingSessionEvent.Insert();
    end;

    local procedure FormatEventMessage(SessionParameters: Record "Session Parameters"): Text[250]
    var
        ReadOneMessageLbl: Label 'Reading record %1 with %2 method.', Locked = true;
        ReadMultipleMessageLbl: Label 'Reading records from %1 to %2 with %3 method.', Locked = true;
        InsertMessageLbl: Label 'Inserting record %1.', Locked = true;
        DeleteOneMessageLbl: Label 'Deleting record %1.', Locked = true;
        DeleteMultipleMessageLbl: Label 'Deleting records from %1 to %2.', Locked = true;
        UpdateOneMessageLbl: Label 'Modifying record %1.', Locked = true;
        UpdateMultipleMessageLbl: Label 'Modifying records from %1 to %2.', Locked = true;
    begin
        case SessionParameters.Action of
            "Session Action"::"Read":
                begin
                    if SessionParameters."First Record No." = SessionParameters."Last Record No." then
                        exit(StrSubstNo(ReadOneMessageLbl, SessionParameters."First Record No.", SessionParameters."Lock Type"));
                    exit(StrSubstNo(ReadMultipleMessageLbl, SessionParameters."First Record No.", SessionParameters."Last Record No.", SessionParameters."Lock Type"));
                end;
            "Session Action"::"Insert":
                exit(StrSubstNo(InsertMessageLbl, SessionParameters."First Record No."));
            "Session Action"::"Delete":
                begin
                    if SessionParameters."First Record No." = SessionParameters."Last Record No." then
                        exit(StrSubstNo(DeleteOneMessageLbl, SessionParameters."First Record No."));
                    exit(StrSubstNo(DeleteMultipleMessageLbl, SessionParameters."First Record No.", SessionParameters."Last Record No."));
                end;
            "Session Action"::"Modify":
                begin
                    if SessionParameters."First Record No." = SessionParameters."Last Record No." then
                        exit(StrSubstNo(UpdateOneMessageLbl, SessionParameters."First Record No."));
                    exit(StrSubstNo(UpdateMultipleMessageLbl, SessionParameters."First Record No.", SessionParameters."Last Record No."));
                end;
        end;
    end;

    var
        TempLockingSessionEvent: Record "Locking Session Event" temporary;
}