enum 90150 "Translation Service DT" implements "Translator Connector DT"
{
    Extensible = true;

    value(1; "Azure Translator")
    {
        Caption = 'Azure Translator';
        Implementation = "Translator Connector DT" = "Azure Translator Connector DT";
    }
}