report 50002 "Slack - Send Content Message"
{
    ApplicationArea = All;
    Caption = 'Slack - Send Content Message';
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
                    field(APIUrl; APIUrl)
                    {
                        Caption = 'APIUrl';
                        ToolTip = 'Defines the API Url where to send the simple slack message.';
                        ApplicationArea = All;
                    }
                    field(SlackToken; SlackToken)
                    {
                        Caption = 'Slack Token';
                        ToolTip = 'Defines the Slack Token where to send the simple slack message.';
                        ApplicationArea = All;
                    }
                    field(SlackChannel; SlackChannel)
                    {
                        Caption = 'Slack Channel';
                        ToolTip = 'Defines the Slack Channel where to send the simple slack message.';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    var
        JsonObject: JsonObject;
        Content: Text;
        i: Integer;
        CRLF: Text[2];
        Separator: Label ';';
        Field1: Label 'Name %1';
        Field2: Label 'Address %1';
        FileDescription: Label 'This is the first content message in BC23';
    begin
        CRLF[1] := 13;
        CRLF[2] := 10;

        if APIUrl = '' then
            Error(EmptyAPIUrlErr);

        Content := 'Id;Name;Address;Quantity';
        for i := 1 to 10 do begin
            Content += CRLF;
            Content +=
                format(i) + Separator +
                StrSubstNo(Field1, i) + Separator +
                StrSubstNo(Field2, i) + Separator +
                Format(i * 10);
        end;
        SlackManagement.SendContent(APIUrl, SlackManagement.BuildFormData(SlackToken, Content, SlackChannel, 'csv', 'MyTextFile', FileDescription));
    end;

    var
        SlackManagement: Codeunit "Slack Management";
        APIUrl: Text;
        SlackChannel: Text;
        SlackToken: Text;
        EmptyAPIUrlErr: Label 'The API Url and Slack Channel cannot be empty';
}
