codeunit 90150 "Azure Translator Connector DT" implements "Translator Connector DT"
{
    procedure Translate(TextToTranslate: Text; SourceLanguage: Text; DestLanguage: List of [Text]): Dictionary of [Text, Text]
    var
        TranslatorSetup: Record "Translator Setup DT";
        RequestMsg: HttpRequestMessage;
        ResponseMsg: HttpResponseMessage;
        Client: HttpClient;
    begin
        TranslatorSetup.Get();
        TranslatorSetup.TestField(URI);

        RequestMsg.Method := 'POST';
        RequestMsg.SetRequestUri(TranslatorSetup.URI + BuildParamString(SourceLanguage, DestLanguage));

        RequestMsg.Content.WriteFrom(BuildRequestBody(TextToTranslate));
        SetMessageHeaders(RequestMsg);
        SetContentHeaders(RequestMsg);

        Client.Send(RequestMsg, ResponseMsg);
        if not ResponseMsg.IsSuccessStatusCode() then
            Error(GetResponseError(ResponseMsg));

        exit(ParseResponse(ResponseMsg.Content));
    end;

    local procedure BuildParamString(SourceLanguage: Text; DestLanguages: List of [Text]): Text
    var
        Parameters: Text;
        LangCode: Text;
    begin
        Parameters := '?api-version=3.0&from=' + SourceLanguage;

        foreach LangCode in DestLanguages do
            Parameters := Parameters + '&to=' + LangCode;

        exit(Parameters);
    end;

    procedure BuildRequestBody(TextToTranslate: Text): Text
    var
        JArr: JsonArray;
        JObj: JsonObject;
        JText: Text;
    begin
        JObj.Add('Text', TextToTranslate);
        JArr.Add(JObj);
        JArr.WriteTo(JText);

        exit(JText);
    end;

    local procedure GetResponseError(var ResponseMsg: HttpResponseMessage): Text
    var
        ResponseText: Text;
    begin
        ResponseMsg.Content.ReadAs(ResponseText);
        exit(ResponseText);
    end;

    local procedure ParseResponse(Content: HttpContent): Dictionary of [Text, Text]
    var
        ResponseText: Text;
        ResponseArray: JsonArray;
        Translations: JsonToken;
        Translation: JsonToken;
        Values: JsonToken;
        TranslationsDict: Dictionary of [Text, Text];
        LangCode: JsonToken;
        TranslationText: JsonToken;
    begin
        Content.ReadAs(ResponseText);
        ResponseArray.ReadFrom(ResponseText);
        // This array contains translations of multiple source texts if batch translation is requested.
        // Dictionary client does not support this mode at the moment. Request contains only a single word/phrase.
        ResponseArray.Get(0, Translations);
        Translations.AsObject().Get('translations', Values);

        foreach Translation in Values.AsArray() do begin
            Translation.AsObject().Get('to', LangCode);
            Translation.AsObject().Get('text', TranslationText);
            TranslationsDict.Add(LangCode.AsValue().AsText(), TranslationText.AsValue().AsText());
        end;

        exit(TranslationsDict);
    end;

    local procedure SetContentHeaders(var RequestMsg: HttpRequestMessage)
    var
        Headers: HttpHeaders;
    begin
        RequestMsg.Content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/json');
    end;

    local procedure SetMessageHeaders(var RequestMsg: HttpRequestMessage)
    var
        TranslationRequestHdr: Record "Translation Request Header DT";
        Headers: HttpHeaders;
    begin
        if TranslationRequestHdr.FindSet() then begin
            RequestMsg.GetHeaders(Headers);

            repeat
                Headers.Add(TranslationRequestHdr.Name, TranslationRequestHdr.Value);
            until TranslationRequestHdr.Next() = 0;
        end;
    end;
}