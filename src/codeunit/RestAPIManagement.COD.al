codeunit 50001 "Rest API Management"
{
    var
        ResponseMessage: HttpResponseMessage;

    procedure GetResponseAsText(): Text
    var
        ResponseText: Text;
    begin
        ResponseMessage.Content().ReadAs(ResponseText);
        exit(responseText);
    end;

    [TryFunction]
    procedure SendRequest(Uri: Text; MethodType: Enum "REST API Method"; PayLoad: Text; ContentType: Text)
    var
        Client: HttpClient;
        Content: HttpContent;
        Headers: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        StatusResponse: Integer;
        NotAllowedMethodErr: Label 'Method %1 is not allowed.';
    begin
        if PayLoad <> '' then begin
            Content.WriteFrom(PayLoad);
            Content.GetHeaders(Headers);

            Headers.Clear();
            Headers.Add('Content-Type', ContentType);
            RequestMessage.Content(Content);
        end;

        RequestMessage.SetRequestUri(Uri);
        RequestMessage.Method(Format(MethodType));
        Client.Send(RequestMessage, ResponseMessage);

        if not ResponseMessage.IsSuccessStatusCode() then
            Error('Error Status Code: %1', ResponseMessage.HttpStatusCode());
    end;
}