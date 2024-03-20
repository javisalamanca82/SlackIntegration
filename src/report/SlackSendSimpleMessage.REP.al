report 50000 "Slack - Send Simple Message"
{
    ApplicationArea = All;
    Caption = 'Slack - Send Simple Message';
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
        ContentTxt: Label 'This is first message in BC23';
    begin
        if Webhook = '' then
            Error(EmptyWebhookErr);

        JsonObject.Add('text', ContentTxt);
        JsonObject.WriteTo(Payload);

        SlackManagement.SendMessageWithWebhook(Webhook, Payload);
    end;

    var
        SlackManagement: Codeunit "Slack Management";
        Webhook: Text;
        EmptyWebhookErr: Label 'The Webhook cannot be empty';
}
