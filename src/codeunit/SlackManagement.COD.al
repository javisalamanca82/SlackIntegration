codeunit 50000 "Slack Management"
{
    var
        RestClient: Codeunit "Rest Client";
        RestAPIManagement: Codeunit "Rest API Management";
        RestAPIMethod: Enum "REST API Method";

    procedure SendMessageWithWebhook(Webhook: text; Payload: Text)
    begin
        RestAPIManagement.SendRequest(Webhook, RestAPIMethod::POST, Payload, 'application/json')
    end;

    procedure SendSimpleMessageWithWebhookWithRestClient(Webhook: text; Payload: Text)
    var
        Content: Codeunit "Http Content";
        Response: Codeunit "Http Response Message";
        ErrorTxt: Label 'Error Code %1: %2.';
    begin
        Content.AddContentEncoding(Payload);
        Response := RestClient.Post(Webhook, Content);
        if not Response.GetIsSuccessStatusCode() then
            Error(ErrorTxt, Response.GetHttpStatusCode(), Response.GetErrorMessage());
    end;

    procedure SendContent(Uri: Text; Content: Text)
    begin
        RestAPIManagement.SendRequest(Uri, RestAPIMethod::POST, Content, 'application/x-www-form-urlencoded')
    end;

    procedure BuildFormData(SlackTocken: Text; Content: Text; Channel: Text; FileType: Text; FileName: Text; FileDescription: Text): Text
    var
        FormDataText: Text;
    begin
        FormDataText := StrSubstNo('token=%1', SlackTocken);
        FormDataText += StrSubstNo('&channels=%1', Channel);
        FormDataText += StrSubstNo('&content=%1', Content);
        FormDataText += StrSubstNo('&filetype=%1', FileType);
        FormDataText += StrSubstNo('&filename=%1', FileName);
        FormDataText += StrSubstNo('&initial_comment=%1', FileDescription);
        exit(FormDataText);
    end;
}

