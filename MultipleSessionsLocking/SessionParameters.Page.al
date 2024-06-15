page 50702 "Session Parameters"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Session Parameters";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(WaitBeforeLocking; Rec."Wait Time Before Locking")
                {
                    ApplicationArea = All;
                }
                field(LockType; Rec."Lock Type")
                {
                    ApplicationArea = All;
                }
                field(Action; Rec.Action)
                {
                    ApplicationArea = All;
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
}