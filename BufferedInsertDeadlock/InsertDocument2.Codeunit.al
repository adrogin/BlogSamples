codeunit 50182 "Insert Document 2"
{
    trigger OnRun()
    var
        MyDocumentCreate: Codeunit "My Document - Create";
    begin
        MyDocumentCreate.InsertHeader('DOC2', 'ITEM1');
        
        MyDocumentCreate.InsertLine('DOC2', 10000, 'ITEM2', 'Dim1Value', 'Dim2Value');
        MyDocumentCreate.InsertLine('DOC2', 20000, 'ITEM3', 'Dim1Value', 'Dim2Value');
        MyDocumentCreate.InsertLine('DOC2', 30000, 'ITEM4', 'Dim1Value', 'Dim2Value');
        MyDocumentCreate.InsertLine('DOC2', 40000, 'ITEM5', 'Dim1Value', 'Dim2Value');
        MyDocumentCreate.InsertLine('DOC2', 50000, 'ITEM6', 'Dim1Value', 'Dim2Value');
        Sleep(1000);
    end;
}