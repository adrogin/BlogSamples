codeunit 50180 "Insert Document 1"
{
    trigger OnRun()
    var
        MyDocumentCreate: Codeunit "My Document - Create";
    begin
        MyDocumentCreate.InsertHeader('DOC1', 'ITEM1');
        MyDocumentCreate.InsertLine('DOC1', 10000, 'ITEM2', 'Dim1Value', 'Dim2Value');
        Sleep(500);
    end;
}