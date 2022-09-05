interface "Translator Connector DT"
{
    procedure Translate(TextToTranslate: Text; SourceLanguage: Text; DestLanguage: List of [Text]): Dictionary of [Text, Text];
}