page 90153 "Translator Setup DT"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Translator Setup DT";
    Caption = 'Translator Setup';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(TranslationProvider; Rec."Translation Provider")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the translation service.';
                }
                field(URI; Rec.URI)
                {
                    ApplicationArea = All;
                    ToolTip = 'URI of the translation service.';
                }
                field(RequestParameters; Rec."Request Parameters")
                {
                    ApplicationArea = All;
                    ToolTip = 'Parameters to be added to the request string.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Headers)
            {
                ApplicationArea = All;
                Caption = 'Request Headers';
                ToolTip = 'Configure HTTP request headers';
                RunObject = page "Translation Request Headers DT";
                Image = SetupAddressCountryRegion;
            }
        }
    }
}