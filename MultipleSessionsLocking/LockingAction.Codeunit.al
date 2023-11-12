codeunit 50700 "Locking Action"
{
    TableNo = "Session Parameters";

    trigger OnRun()
    begin
        DoLockingAction(Rec);
    end;

    local procedure DoLockingAction(SessionParameters: Record "Session Parameters")
    var
        LockingTest: Record "Locking Test";
        LockingMgt: Codeunit "Locking Mgt.";
    begin
        Sleep(SessionParameters."Wait Time Before Locking");

        case SessionParameters."Lock Type" of
            SessionParameters."Lock Type"::"Read Uncommitted":
                LockingTest.ReadIsolation := LockingTest.ReadIsolation::ReadUncommitted;
            SessionParameters."Lock Type"::"Read Committed":
                LockingTest.ReadIsolation := LockingTest.ReadIsolation::ReadCommitted;
            SessionParameters."Lock Type"::"Repeatable Read":
                LockingTest.ReadIsolation := LockingTest.ReadIsolation::RepeatableRead;
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

        Sleep(SessionParameters."Wait Time After Locking");
    end;
}