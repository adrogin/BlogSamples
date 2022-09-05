codeunit 90157 "Dictionary Entry Tests DT"
{
    Subtype = Test;

    [Test]
    procedure SaveDictEntriesVerifyText()
    var
        SourceText: Text;
        Language: Text;
        ToLanguagesList: List of [Text];
        TranslatedText: Dictionary of [Text, Text];
        I: Integer;
    begin
        Initialize();

        for I := 1 to LibraryRandom.RandIntInRange(3, 5) do begin
            Language := GenerateRandomText(10);
            ToLanguagesList.Add(Language);
            TranslatedText.Add(Language, GenerateRandomText(100))
        end;

        SourceText := GenerateRandomText(100);
        Language := GenerateRandomText(10);

        DictionaryMgt.SaveTranslatedEntries(Language, ToLanguagesList, SourceText, TranslatedText);

        VerifyDictionaryEntries(Language, ToLanguagesList, SourceText, TranslatedText);
    end;

    [Test]
    procedure TranslateToOneLanguageAndSave()
    var
        SourceText: Text;
        FromLanguage: Text;
        ToLanguage: Text;
        ToLanguagesList: List of [Text];
    begin
        Initialize();

        SourceText := GenerateRandomText(100);
        FromLanguage := GenerateRandomText(10);
        ToLanguage := GenerateRandomText(10);
        ToLanguagesList.Add(ToLanguage);

        DictionaryMgt.Translate(SourceText, FromLanguage, ToLanguagesList);

        VerifyEntryExists(FromLanguage, ToLanguage, SourceText);
    end;

    [Test]
    procedure TranslateToMultipleLanguagesAndSave()
    var
        SourceText: Text;
        FromLanguage: Text;
        ToLanguage: Text;
        ToLanguagesList: List of [Text];
        I: Integer;
    begin
        Initialize();

        SourceText := GenerateRandomText(100);
        FromLanguage := GenerateRandomText(10);

        for I := 1 to LibraryRandom.RandIntInRange(3, 5) do
            ToLanguagesList.Add(GenerateRandomText(10));

        DictionaryMgt.Translate(SourceText, FromLanguage, ToLanguagesList);

        foreach ToLanguage in ToLanguagesList do
            VerifyEntryExists(FromLanguage, ToLanguage, SourceText);
    end;

    local procedure Initialize()
    var
        TranslatorSetup: Record "Translator Setup DT";
    begin
        if IsInitialized then
            exit;

        if not TranslatorSetup.Get() then begin
            TranslatorSetup.Init();
            TranslatorSetup.Insert(true);
        end;

        TranslatorSetup."Translation Provider" := TranslatorSetup."Translation Provider"::"Azure Translator Test Mock";
        TranslatorSetup.Modify(true);

        Commit();
        IsInitialized := true;
    end;

    local procedure FilterDictionary(var DictionaryEntry: Record "Dictionary Entry DT"; FromLanguage: Text; ToLanguage: Text; SourceText: Text)
    begin
        DictionaryEntry.SetRange("Source Language", FromLanguage);
        DictionaryEntry.SetRange("Dest. Language", ToLanguage);
        DictionaryEntry.SetRange("Source Text", SourceText);
    end;

    local procedure GenerateRandomText(MaxLength: Integer): Text
    begin
        exit(LibraryUtility.GenerateRandomAlphabeticText(LibraryRandom.RandInt(MaxLength), LiteralOption::Literal));
    end;

    local procedure VerifyDictEntry(FromLanguage: Text; Tolanguage: Text; SourceText: Text; TranslatedText: Text)
    var
        DictionaryEntry: Record "Dictionary Entry DT";
        UnexpectedEntryErr: Label 'Unexpected dictionary entry.';
    begin
        FilterDictionary(DictionaryEntry, FromLanguage, Tolanguage, SourceText);
        DictionaryEntry.FindFirst();
        Assert.AreEqual(TranslatedText, DictionaryEntry."Dest. Text", UnexpectedEntryErr);
    end;

    local procedure VerifyDictionaryEntries(FromLanguage: Text; Tolanguages: List of [Text]; SourceText: Text; TranslatedText: Dictionary of [Text, Text])
    var
        Language: Text;
        TextEntry: Text;
    begin
        foreach Language in Tolanguages do begin
            TranslatedText.Get(Language, TextEntry);
            VerifyDictEntry(FromLanguage, Language, SourceText, TextEntry);
        end;
    end;

    local procedure VerifyEntryExists(FromLanguage: Text; Tolanguage: Text; SourceText: Text)
    var
        DictionaryEntry: Record "Dictionary Entry DT";
    begin
        FilterDictionary(DictionaryEntry, FromLanguage, Tolanguage, SourceText);
        Assert.RecordIsNotEmpty(DictionaryEntry);
    end;

    var
        LibraryUtility: Codeunit "Library - Utility";
        LibraryRandom: Codeunit "Library - Random";
        DictionaryMgt: Codeunit "Dictionary Mgt. DT";
        Assert: Codeunit Assert;
        LiteralOption: Option Capitalized,Literal;
        IsInitialized: Boolean;
}