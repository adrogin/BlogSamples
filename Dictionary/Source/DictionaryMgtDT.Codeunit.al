codeunit 90151 "Dictionary Mgt. DT"
{
    procedure FindEntry(FromLanguage: Text[10]; ToLanguage: Text[10]; EntyText: Text): Text
    begin

    end;

    procedure Translate(TextToTranslate: Text; FromLanguage: Text; ToLanguage: List of [Text]): Boolean
    var
        TranslatorConnector: Interface "Translator Connector DT";
        TranslatedText: Dictionary of [Text, Text];
    begin
        if (TextToTranslate = '') or (FromLanguage = '') or (ToLanguage.Count() = 0) then
            exit(false);

        InitializeInterface(TranslatorConnector);
        TranslatedText := TranslatorConnector.Translate(TextToTranslate, FromLanguage, ToLanguage);

        SaveTranslatedEntries(FromLanguage, ToLanguage, TextToTranslate, TranslatedText);

        exit(true);
    end;

    local procedure InitializeInterface(var TranslatorConnector: Interface "Translator Connector DT")
    var
        TranslatorSetup: Record "Translator Setup DT";
    begin
        TranslatorSetup.Get();
        TranslatorConnector := TranslatorSetup."Translation Provider";
    end;

    procedure SaveTranslatedEntries(FromLanguage: Text; ToLanguages: List of [Text]; SourceText: Text; TranslatedText: Dictionary of [Text, Text])
    var
        Lang: Text;
        TextEntry: Text;
    begin
        foreach Lang in ToLanguages do begin
            TranslatedText.Get(Lang, TextEntry);
            InsertDictionaryEntry(FromLanguage, Lang, SourceText, TextEntry);
        end;
    end;

    procedure InsertDictionaryEntry(FromLanguage: Text; ToLanguage: Text; SourceText: Text; TranslatedText: Text)
    var
        DictionaryEntry: Record "Dictionary Entry DT";
    begin
        DictionaryEntry."Source Language" := CopyStr(FromLanguage, 1, MaxStrLen(DictionaryEntry."Source Language"));
        DictionaryEntry."Dest. Language" := CopyStr(ToLanguage, 1, MaxStrLen(DictionaryEntry."Dest. Language"));
        DictionaryEntry."Source Text" := CopyStr(SourceText, 1, MaxStrLen(DictionaryEntry."Source Text"));
        DictionaryEntry."Dest. Text" := CopyStr(TranslatedText, 1, MaxStrLen(DictionaryEntry."Dest. Text"));
        DictionaryEntry.Insert(true);
    end;
}