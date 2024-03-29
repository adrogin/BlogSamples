codeunit 90157 "Dictionary Entry Tests DT"
{
    Subtype = Test;
    TestPermissions = Disabled;

    [Test]
    procedure SaveDictEntriesVerifyText()
    var
        SourceText: Text;
        Language: Text;
        ToLanguagesList: List of [Text];
        TranslatedText: Dictionary of [Text, Text];
        I: Integer;
    begin
        // [SCENARIO] Translated text entries can be saved in the dictionary

        Initialize();

        // [GIVEN] List of translations in multiple languages
        for I := 1 to LibraryRandom.RandIntInRange(3, 5) do begin
            Language := GenerateRandomText(10);
            ToLanguagesList.Add(Language);
            TranslatedText.Add(Language, GenerateRandomText(100))
        end;

        // [GIVEN] Source text for translation
        SourceText := GenerateRandomText(100);
        Language := GenerateRandomText(10);

        // [WHEN] Call SaveTranslatedEntries with the source text and the translations list
        DictionaryMgt.SaveTranslatedEntries(Language, ToLanguagesList, SourceText, TranslatedText);

        // [THEN] A dictionary entry is created for each translated text
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
        // [SCENARIO] Translate text to one language - translated text is saved in the dictionary

        Initialize();

        // [GIVEN] A text to translate, source language and one destination language
        SourceText := GenerateRandomText(100);
        FromLanguage := GenerateRandomText(10);
        ToLanguage := GenerateRandomText(10);
        ToLanguagesList.Add(ToLanguage);

        // [WHEN] Call Translate
        DictionaryMgt.Translate(SourceText, FromLanguage, ToLanguagesList);

        // [THEN] Dictinary entry is created
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
        // [SCENARIO] Translate text to multiple languages - translated texts are saved in the dictionary

        Initialize();

        // [GIVEN] A text to translate, source language and one destination language
        SourceText := GenerateRandomText(100);
        FromLanguage := GenerateRandomText(10);

        for I := 1 to LibraryRandom.RandIntInRange(3, 5) do
            ToLanguagesList.Add(GenerateRandomText(10));

        // [WHEN] Call Translate
        DictionaryMgt.Translate(SourceText, FromLanguage, ToLanguagesList);

        // [THEN] Dictinary entry is created for each language
        foreach ToLanguage in ToLanguagesList do
            VerifyEntryExists(FromLanguage, ToLanguage, SourceText);
    end;

    [Test]
    procedure CannotSelectSameLanguageAsSourceAndTarget()
    var
        SourceText: Text;
        FromLanguage: Text;
        ToLanguagesList: List of [Text];
        SameLangAsSourceAndDestErr: Label 'Same language cannot be selected as the source and target language at the same time';
    begin
        // [SCENARIO] Translation request fails if the same language is selected as both source and target language

        Initialize();

        // [GIVEN] Set the source text to translate
        SourceText := GenerateRandomText(100);

        // [GIVEN] Select the source language and list of target languages. One of the target languages is the same as source.
        FromLanguage := GenerateRandomText(10);
        ToLanguagesList.Add(GenerateRandomText(10));
        ToLanguagesList.Add(FromLanguage);
        ToLanguagesList.Add(GenerateRandomText(10));

        // [WHEN] Call Translate
        asserterror DictionaryMgt.Translate(SourceText, FromLanguage, ToLanguagesList);

        // [THEN] The call fails. Error message reads that the source and target language cannot match.
        Assert.ExpectedError(SameLangAsSourceAndDestErr);
    end;

    [Test]
    procedure UppercaseLanguageCodeTranslationAddedToDictionary()
    var
        SourceText: Text;
        FromLanguage: Text;
        ToLanguages: List of [Text];
    begin
        // [SCENARIO] Response from the translation service can be successfully processed when the taret language code is in uppercase

        Initialize();

        // [GIVEN] Set the source text for the translation
        SourceText := GenerateRandomText(100);

        // [GIVEN] Set the source language code
        FromLanguage := GenerateRandomText(10);

        // [GIVEN] Set the target language code. Code is uppercased.
        ToLanguages.Add(UpperCase(GenerateRandomText(10)));

        // [WHEN] Translate the text and save the translation
        DictionaryMgt.Translate(SourceText, FromLanguage, ToLanguages);

        // [THEN] Dictionary entry is created
        VerifyEntryExists(FromLanguage, ToLanguages.Get(1), SourceText);
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