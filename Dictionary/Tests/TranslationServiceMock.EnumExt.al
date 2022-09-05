enumextension 90156 "Translation Service Mock" extends "Translation Service DT"
{
    value(90000; "Azure Translator Test Mock")
    {
        Caption = 'Azure Translator Test Mock';
        Implementation = "Translator Connector DT" = "Azure Connector Mock DT";
    }
}