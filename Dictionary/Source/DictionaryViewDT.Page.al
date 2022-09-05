page 90150 "Dictionary View DT"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Dictionary Entry DT";

    layout
    {
        area(Content)
        {
            field(SourceLanguageControl; SourceLanguageFilter)
            {
                ApplicationArea = All;
                Caption = 'Source Language';
                ToolTip = 'Select the source language to filter dictionary entries.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    exit(LookupLanguage(Text));
                end;

                trigger OnValidate()
                begin
                    Rec.SetFilter("Source Language", SourceLanguageFilter);
                    CurrPage.Update(false);
                end;
            }
            field(DestLanguageControl; DestLanguageFilter)
            {
                ApplicationArea = All;
                Caption = 'Destination Language';
                ToolTip = 'Select the destination language to filter dictionary entries.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    exit(LookupLanguage(Text));
                end;

                trigger OnValidate()
                begin
                    Rec.SetFilter("Dest. Language", DestLanguageFilter);
                    CurrPage.Update(false);
                end;
            }
            field(SourceTxtInputControl; SourceText)
            {
                ApplicationArea = All;
                Caption = 'Text to Translate';
                ToolTip = 'Type a word or a phrase to find it in the dictionary or to send it to the translation service.';
            }

            repeater(Translations)
            {
                field(SourceTxtViewControl; Rec."Source Text")
                {
                    ApplicationArea = All;
                    ToolTip = 'Text in the selected source language.';
                }
                field(DestText; Rec."Dest. Text")
                {
                    ApplicationArea = All;
                    ToolTip = 'Translated text in the selected destination language.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Translate)
            {
                ApplicationArea = All;
                Caption = 'Translate';
                ToolTip = 'Send the text to the translation service';
                Promoted = true;
                PromotedIsBig = true;
                Image = Translation;

                trigger OnAction();
                var
                    DictionaryMgt: Codeunit "Dictionary Mgt. DT";
                begin
                    DictionaryMgt.Translate(SourceText, SourceLanguageFilter, FilterText2List(DestLanguageFilter));
                end;
            }
        }
    }

    local procedure FilterText2List(FilterText: Text): List of [Text]
    begin
        exit(FilterText.Split('|'));
    end;

    local procedure LookupLanguage(var LookupText: Text): Boolean
    var
        DictLanguage: Record "Dict. Language DT";
    begin
        if Page.RunModal(0, DictLanguage) <> Action::LookupOK then
            exit(false);

        LookupText := DictLanguage.Code;
        exit(true);
    end;

    var
        SourceLanguageFilter: Text[10];
        DestLanguageFilter: Text[10];
        SourceText: Text[250];
}
