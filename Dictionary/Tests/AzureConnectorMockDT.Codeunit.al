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
            Response.Add(LowerCase(Language), LibraryUtility.GenerateRandomAlphabeticText(LIbraryRandom.RandInt(100), LiteralOption::Literal));

        exit(Response);
    end;

    var
        LibraryUtility: Codeunit "Library - Utility";
        LIbraryRandom: Codeunit "Library - Random";
        LiteralOption: Option Capitalized,Literal;
}