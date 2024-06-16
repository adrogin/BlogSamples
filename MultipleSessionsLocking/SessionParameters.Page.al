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
                }
                field(WaitBeforeLocking; Rec."Wait Time Before Locking")
                {
                    ApplicationArea = All;
                }
                field(Action; Rec.Action)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetLockTypeEditable();
                    end;
                }
                field(LockType; Rec."Lock Type")
                {
                    ApplicationArea = All;
                    Editable = LockTypeEditable;
                }
                field(FirstRecordNo; Rec."First Record No.")
                {
                    ApplicationArea = All;
                }
                field(LastRecordNo; Rec."Last Record No.")
                {
                    ApplicationArea = All;
                }
                field(CommitAfterAction; Rec."Commit After Action")
                {
                    ApplicationArea = All;
                }
                field(WaitAfterLocking; Rec."Wait Time After Locking")
                {
                    ApplicationArea = All;
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