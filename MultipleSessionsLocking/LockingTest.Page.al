page 50701 "Locking Test"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            grid(Sessions)
            {
                group(Session1)
                {
                    Caption = 'Session 1';

                    part(LockingSessionEvents1; "Locking Session Events")
                    {
                        ApplicationArea = All;
                    }
                }
                group(Session2)
                {
                    Caption = 'Session 2';

                    part(LockingSessionEvents2; "Locking Session Events")
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(TestScenarios)
            {
                Caption = 'Test Scenarios';
                Image = Lock;

                action(ModifyOneFirst)
                {
                    ApplicationArea = All;
                    Caption = 'Modify - One record first';
                    Image = UpdateDescription;
                    ToolTip = 'Run the locking test with the first session modifying one record, an the second session modifying a range.';

                    trigger OnAction()
                    begin
                        FilterSessionEventViews(LockingMgt.RunLockingScenarioModifyOneBeforeRange());
                    end;
                }
                action(ModifyRangeFirst)
                {
                    ApplicationArea = All;
                    Caption = 'Modify - Range first';
                    Image = UpdateDescription;
                    ToolTip = 'Run the locking test with the first session modifying a range, and the second session modifying one record.';

                    trigger OnAction()
                    begin
                        FilterSessionEventViews(LockingMgt.RunLockingScenarioModifyRangeBeforeOne());
                    end;
                }
                action(ModifyOneFirstReadRangeRepeatableRead)
                {
                    ApplicationArea = All;
                    Caption = 'Read - One record first';
                    Image = UpdateDescription;
                    ToolTip = 'Run the locking test with the first session modifying one record, and the second session reading a range with RepeatableRead isolation.';

                    trigger OnAction()
                    begin
                        FilterSessionEventViews(LockingMgt.RunLockingScenarioModifyOneBeforeReadingRangeRepeatableRead());
                    end;
                }
                action(ReadRangeFirstRepeatableRead)
                {
                    ApplicationArea = All;
                    Caption = 'Read - Range first';
                    Image = UpdateDescription;
                    ToolTip = 'Run the locking test with the first session reading a range with RepeatableRead isolation, and the second session modifying one record.';

                    trigger OnAction()
                    begin
                        FilterSessionEventViews(LockingMgt.RunLockingScenarioReadRangeRepeatableReadBeforeModifyOne());
                    end;
                }
                action(ReadRangeFirstRepeatableReadModifyNone)
                {
                    ApplicationArea = All;
                    Caption = 'Read and modify - Nothing in range';
                    Image = UpdateDescription;
                    ToolTip = 'Run the locking test with the first session reading a range with RepeatableRead isolation, and the second session attempting to modify.';

                    trigger OnAction()
                    begin
                        FilterSessionEventViews(LockingMgt.RunLockingScenarioReadRangeRepeatableReadBeforeModifyNone());
                    end;
                }
                action(DeadlockLockingTwoRecordsInReverse)
                {
                    ApplicationArea = All;
                    Caption = 'Deadlock: locking two records in reverse';
                    Image = UpdateDescription;
                    ToolTip = 'Session 1 locks record 1, then 2; session 2 locks in reverse order which leads to a deadlock.';

                    trigger OnAction()
                    begin
                        FilterSessionEventViews(LockingMgt.RunLockingScenarioTwoRecordsDeadlock());
                    end;
                }
                action(DeadlockLockingOneRecord)
                {
                    ApplicationArea = All;
                    Caption = 'Deadlock: locking and updating one record';
                    Image = UpdateDescription;
                    ToolTip = 'Both sessions read record 1 with Repeatable Read isolation and after 2 seconds attempt to update it.';

                    trigger OnAction()
                    begin
                        FilterSessionEventViews(LockingMgt.RunLockingScenarioOneRecordDeadlock());
                    end;
                }
            }
            group(TestManagement)
            {
                Caption = 'Test Management';
                Image = Setup;

                action(StopTestSessions)
                {
                    ApplicationArea = All;
                    Caption = 'Stop Test Sessions';
                    Image = Stop;
                    ToolTip = 'Stop test session that are currently running';

                    trigger OnAction()
                    begin
                        LockingMgt.StopActiveSessions();
                    end;
                }
                action(InitializeTable)
                {
                    ApplicationArea = All;
                    Caption = 'Initialize Table';
                    Image = New;
                    ToolTip = 'Initialize the demo data. This action deletes all records from the Locking Test table and generates a new recordset.';

                    trigger OnAction()
                    begin
                        LockingMgt.InitializeTestTable();
                        Message('Ready to run test scenarios.');
                    end;
                }
            }
        }
        area(Navigation)
        {
            action(Refresh)
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                Image = Refresh;
                ToolTip = 'Refresh the events from the background sessions.';

                trigger OnAction()
                begin
                    RefreshEventViews();
                end;
            }
        }
        area(Promoted)
        {
            actionref(PromotedRefresh; Refresh) { }
        }
    }

    trigger OnOpenPage()
    begin
        SetSessionViewFilters(LockingMgt.GetLastSessionIDs());
    end;

    local procedure FilterSessionEventViews(SessionIds: List of [Integer])
    begin
        SetSessionViewFilters(SessionIds);
    end;

    local procedure RefreshEventViews()
    begin
        CurrPage.LockingSessionEvents1.Page.Update(false);
        CurrPage.LockingSessionEvents2.Page.Update(false);
    end;

    local procedure SetSessionViewFilters(SessionIds: List of [Integer])
    begin
        CurrPage.LockingSessionEvents1.Page.SetSessionIdFilter(SessionIds.Get(1));
        CurrPage.LockingSessionEvents2.Page.SetSessionIdFilter(SessionIds.Get(2));
        RefreshEventViews();
    end;

    var
        LockingMgt: Codeunit "Locking Mgt.";
}
