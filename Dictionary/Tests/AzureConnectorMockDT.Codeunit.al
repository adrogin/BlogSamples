codeunit 90156 "Azure Connector Mock DT" implements "Translator Connector DT"
{
    procedure Translate(TextToTranslate: Text; SourceLanguage: Text; DestLanguage: List of [Text]): Dictionary of [Text, Text]
    begin
        exit(BuildResponse(DestLanguage));
    end;

    local procedure BuildResponse(DestLanguage: List of [Text]): Dictionary of [Text, Text]
    var
        Language: Text;
        Response: Dictionary of [Text, Text];
    begin
        foreach Language in DestLanguage do
            Response.Add(Language, LibraryUtility.GenerateRandomAlphabeticText(LIbraryRandom.RandInt(100), LiteralOption::Literal));

        exit(Response);
    end;

    // local procedure BuildResponseContent(TextToTranslate: Text; SourceLanguage: Text; DestLanguage: List of [Text]): Dictionary of [Text, Text]
    // var
    //     Root: JsonArray;
    //     TextSnippet: JsonObject;
    //     Translation: JsonObject;
    //     TranslationsArr: JsonArray;
    //     Lang: Text;
    // begin
    //     foreach Lang in DestLanguage do begin
    //         Translation.Add('to', Lang);
    //         Translation.Add('text', LibraryUtility.GenerateRandomAlphabeticText(LIbraryRandom.RandInt(100), LiteralOption::Literal));
    //         TranslationsArr.Add(Translation);
    //     end;

    //     TextSnippet.Add('translations', TranslationsArr);
    //     Root.Add(TextSnippet);

    //     exit(Root);
    // end;

    var
        LibraryUtility: Codeunit "Library - Utility";
        LIbraryRandom: Codeunit "Library - Random";
        LiteralOption: Option Capitalized,Literal;
}