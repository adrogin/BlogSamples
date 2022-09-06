page 90150 "Dictionary View DT"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Dictionary Entry DT";
    Caption = 'Dictionary';
    SaveValues = true;

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
                    exit(LookupLanguage(Text, false));
                end;

                trigger OnValidate()
                begin
                    Rec.SetFilter("Source Language", SourceLanguageFilter);
                    CurrPage.Update(false);
                end;
            }
            field(DestLanguageControl; DestLanguageView)
            {
                ApplicationArea = All;
                Caption = 'Destination Language';
                ToolTip = 'Select the destination language to filter dictionary entries.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    exit(LookupLanguage(Text, true));
                end;

                trigger OnValidate()
                begin
                    Rec.SetFilter("Dest. Language", DestLanguageView.Replace(' ', '').Replace(',', '|'));
                    CurrPage.Update(false);
                end;
            }
            field(SourceTxtInputControl; SourceText)
            {
                ApplicationArea = All;
                Caption = 'Text to Translate';
                ToolTip = 'Type a word or a phrase to find it in the dictionary or to send it to the translation service.';

                trigger OnValidate()
                var
                    SrcFilter: Text;
                begin
                    SrcFilter := SourceText.Trim();
                    if SrcFilter = '' then
                        Rec.SetRange("Source Text")
                    else
                        Rec.SetFilter("Source Text", '@*' + SourceText + '*');

                    CurrPage.Update(false);
                end;
            }

            repeater(Translations)
            {
                field(SourceLang; Rec."Source Language")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Language in which the text is entered. It is used as the source language for translation.';
                }
                field(SourceTxtViewControl; Rec."Source Text")
                {
                    ApplicationArea = All;
                    ToolTip = 'Text in the selected source language.';
                }
                field(DestLang; Rec."Dest. Language")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Language to which the text is translated';
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
                    DictionaryMgt.Translate(SourceText, SourceLanguageFilter, FilterText2List(DestLanguageView));
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SourceLanguageFilter := CopyStr(Rec.GetFilter("Source Language"), 1, MaxStrLen(SourceLanguageFilter));
        DestLanguageView := CopyStr(Rec.GetFilter("Dest. Language"), 1, MaxStrLen(DestLanguageView));
        SourceText := CopyStr(Rec.GetFilter("Source Text"), 1, MaxStrLen(SourceText));
    end;

    local procedure FilterText2List(FilterText: Text): List of [Text]
    begin
        exit(FilterText.Replace(' ', '').Split(','));
    end;

    local procedure LookupLanguage(var LookupText: Text; MultipleSelectionAllowed: Boolean): Boolean
    var
        DictLanguage: Record "Dict. Language DT";
        DictLanguageList: Page "Dict. Language List DT";
    begin
        DictLanguageList.LookupMode(true);

        if DictLanguageList.RunModal() <> Action::LookupOK then
            exit(false);

        LookupText := '';
        if MultipleSelectionAllowed then begin
            DictLanguageList.SetSelectionFilter(DictLanguage);
            LookupText := DictionaryMgt.LanguageRecSetToText(DictLanguage);
        end
        else begin
            DictLanguageList.GetRecord(DictLanguage);
            LookupText := DictLanguage.Code;
        end;

        exit(true);
    end;

    var
        DictionaryMgt: Codeunit "Dictionary Mgt. DT";
        SourceLanguageFilter: Text;
        DestLanguageView: Text;
        SourceText: Text;
}
