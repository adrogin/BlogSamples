page 90151 "Dict. Language List DT"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Dict. Language DT";

    layout
    {
        area(Content)
        {
            repeater(Languages)
            {
                field(LangCode; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Code of the language as it appears in Microsoft Cognitive Services.';
                }
                field(LangName; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the language';
                }
            }
        }
    }
}