page 50160 "Insert with Indexes Test"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;

    actions
    {
        area(Processing)
        {
            action(PrepareData)
            {
                Caption = 'Prepare Test Data';
                ApplicationArea = All;
                ToolTip = 'Generate dimension codes for the test.';

                trigger OnAction()
                begin
                    DataUtils.CreateDimensionCodes();
                end;
            }
            action(RunTest)
            {
                Caption = 'Run incremental test';
                ToolTip = 'Run Test: 10 iterations, +1000 entries each iteration.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    DataUtils.RunTest(10, 1000);
                end;
            }
            action(RunLongTest)
            {
                Caption = 'Run single iteration test';
                ToolTip = 'Run Test: Single iteration, 100000 entries';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    DataUtils.RunTest(1, 100000);
                end;
            }
        }
    }

    var
        DataUtils: Codeunit "Data Utils";
}