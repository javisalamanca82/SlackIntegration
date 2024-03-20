report 50001 "Slack - Send Formated Message"
{
    ApplicationArea = All;
    Caption = 'Slack - Send Formated Message';
    UsageCategory = Tasks;
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    field(Webhook; Webhook)
                    {
                        Caption = 'Webhook';
                        ToolTip = 'Defines the Webhook where to send the simple slack message.';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    var
        JsonObject: JsonObject;
        Payload: Text;
        ContentTxtHeader: Label 'This is *first* formated message in BC23: \n';
        ContentTxtLine1: Label '• Line 1 \n';
        ContentTxtLine2: Label '• Line 2 \n';
        ContentTxtLine3: Label '• Line 3';
        ContentTxt: Label '{"text": ''%1%2%3%4''}';
    begin
        if Webhook = '' then
            Error(EmptyWebhookErr);

        Payload := StrSubstNo(StrSubstNo(ContentTxt, ContentTxtHeader, ContentTxtLine1, ContentTxtLine2, ContentTxtLine3));
        SlackManagement.SendMessageWithWebhook(Webhook, Payload);
    end;

    var
        SlackManagement: Codeunit "Slack Management";
        Webhook: Text;
        EmptyWebhookErr: Label 'The Webhook cannot be empty';
}
