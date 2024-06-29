page 50702 "Session Parameters"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Session Parameters";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(TransactionType; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sets the TransactionType property for the current transaction.';
                }
                field(WaitBeforeLocking; Rec."Wait Time Before Locking")
                {
                    ApplicationArea = All;
                    ToolTip = 'Wait tim in ms before the data acccess action.';
                }
                field(Action; Rec.Action)
                {
                    ApplicationArea = All;
                    ToolTip = 'Data access action: Read, Insert, Modify, or Delete.';

                    trigger OnValidate()
                    begin
                        SetLockTypeEditable();
                    end;
                }
                field(LockType; Rec."Lock Type")
                {
                    ApplicationArea = All;
                    Editable = LockTypeEditable;
                    ToolTip = 'This setting applies to Read actions only. Specifies the locking type - one of the ReadIsolation options or LockTable.';
                }
                field(FirstRecordNo; Rec."First Record No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'An integer number identifying the first record in the range affected by the data access action.';
                }
                field(LastRecordNo; Rec."Last Record No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'An integer number identifying the last record in the range affected by the data access action.';
                }
                field(CommitAfterAction; Rec."Commit After Action")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the transaction must be committed after the action.';
                }
                field(WaitAfterLocking; Rec."Wait Time After Locking")
                {
                    ApplicationArea = All;
                    ToolTip = 'Wait tim in ms after the data acccess action.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetLockTypeEditable();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetLockTypeEditable();
    end;

    local procedure SetLockTypeEditable()
    begin
        LockTypeEditable := Rec.Action = Rec.Action::Read;
    end;

    var
        LockTypeEditable: Boolean;
}