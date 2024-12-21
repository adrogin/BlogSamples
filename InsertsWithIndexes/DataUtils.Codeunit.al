codeunit 50160 "Data Utils"
{
    procedure CreateDimensionCodes()
    var
        MyDimension: Record "My Dimension";
        DimensionsList: List of [Code[20]];
        DimCode: Code[20];
        I: Integer;
    begin
        MyDimension.DeleteAll();

        for I := 1 to 10000 do begin
            repeat
                DimCode := Format(CreateGuid()).Substring(1, 20);
            until not DimensionsList.Contains(DimCode);

            DimensionsList.Add(DimCode);
        end;

        foreach DimCode in DimensionsList do begin
            MyDimension.Code := DimCode;
            MyDimension.Insert();
        end;
    end;

    local procedure LoadDimensions(): List of [Code[20]]
    var
        MyDimension: Record "My Dimension";
        DimensionsList: List of [Code[20]];
        DimensionTableEmptyErr: Label 'MyDimension table is empty. Run the "Create Dimensions" action to prepare the data for the test.';
    begin
        if not MyDimension.FindSet() then
            Error(DimensionTableEmptyErr);

        repeat
            DimensionsList.Add(MyDimension.Code);
        until MyDimension.Next() = 0;

        exit(DimensionsList);
    end;

    procedure CreateEntries(DimensionsList: List of [Code[20]]; NoOfEntries: Integer)
    var
        MyTableWithIndexes: Record "My Table With Indexes";
        I: Integer;
    begin
        MyTableWithIndexes.DeleteAll();

        for I := 1 to NoOfEntries do
            CreateOneEntry(DimensionsList, I);
    end;

    procedure RunTest(NoOfIterations: Integer; NofOfEntriesIncrement: Integer)
    var
        MyTableWithIndexes: Record "My Table With Indexes";
        TestResult: Record "Test Result";
        DimensionsList: List of [Code[20]];
        NextTestNo: Integer;
        IterationNo: Integer;
        StartTime: Time;
        TotalTime: Integer;
        I: Integer;
    begin
        DimensionsList := LoadDimensions();

        if TestResult.FindLast() then
            NextTestNo := TestResult."Test Run" + 1
        else
            NextTestNo := 1;

        TestResult.Init();
        TestResult."Test Run" := NextTestNo;

        for IterationNo := 1 to NoOfIterations do begin
            TestResult.Iteration := IterationNo;
            TotalTime := 0;

            for I := 1 to 5 do begin
                MyTableWithIndexes.DeleteAll();
                Commit();

                StartTime := Time();
                CreateEntries(DimensionsList, IterationNo * NofOfEntriesIncrement);
                TotalTime += Time() - StartTime;
            end;

            TestResult."Run Time" := Round(TotalTime / 5, 1);
            TestResult.Insert();
        end;
    end;

    local procedure CreateOneEntry(DimensionsList: List of [Code[20]]; EntryNo: Integer)
    var
        MyTableWithIndexes: Record "My Table With Indexes";
    begin
        MyTableWithIndexes."Entry No." := EntryNo;
        MyTableWithIndexes."Dimension Value 1" := GetRandomDimCode(DimensionsList);
        MyTableWithIndexes."Dimension Value 2" := GetRandomDimCode(DimensionsList);
        MyTableWithIndexes."Dimension Value 3" := GetRandomDimCode(DimensionsList);
        MyTableWithIndexes."Dimension Value 4" := GetRandomDimCode(DimensionsList);
        MyTableWithIndexes."Dimension Value 5" := GetRandomDimCode(DimensionsList);
        MyTableWithIndexes."Dimension Value 6" := GetRandomDimCode(DimensionsList);
        MyTableWithIndexes."Dimension Value 7" := GetRandomDimCode(DimensionsList);
        MyTableWithIndexes."Dimension Value 8" := GetRandomDimCode(DimensionsList);
        MyTableWithIndexes."Dimension Value 9" := GetRandomDimCode(DimensionsList);
        MyTableWithIndexes."Dimension Value 10" := GetRandomDimCode(DimensionsList);
        MyTableWithIndexes.Amount := Random(1000);
        MyTableWithIndexes.Insert();
    end;

    local procedure GetRandomDimCode(DimensionsList: List of [Code[20]]): Code[20]
    begin
        exit(DimensionsList.Get(Random(DimensionsList.Count)));
    end;
}
