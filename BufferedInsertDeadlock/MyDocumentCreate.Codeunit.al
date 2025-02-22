codeunit 50181 "My Document - Create"
{
    procedure InsertHeader(DocumentNo: Code[20]; ItemNo: Code[20])
    var
        MyDocumentHeader: Record "My Document Header";
    begin
        MyDocumentHeader."No." := DocumentNo;
        MyDocumentHeader.Description := 'Document description';
        MyDocumentHeader."Item No." := ItemNo;
        MyDocumentHeader.Quantity := Random(100);
        MyDocumentHeader.Insert();
    end;

    procedure InsertLine(DocumentNo: Code[20]; LineNo: Integer; ItemNo: Code[20]; Dim1Value: Code[20]; Dim2Value: Code[20])
    var
        MyDocumentLine: Record "My Document Line";
    begin
        MyDocumentLine."Document No." := DocumentNo;
        MyDocumentLine."Line No." := LineNo;
        MyDocumentLine.Description := 'Line description';
        MyDocumentLine."Description 2" := 'Line description 2';
        MyDocumentLine."Item No." := ItemNo;
        MyDocumentLine.Quantity := Random(10);
        MyDocumentLine."Dimension 1 Value" := Dim1Value;
        MyDocumentLine."Dimension 2 Value" := Dim2Value;
        MyDocumentLine."Dimension 3 Value" := 'Dim3Value';
        MyDocumentLine."Dimension 4 Value" := 'Dim4Value';
        MyDocumentLine."Some Dummy Field 1" := '';
        MyDocumentLine."Some Dummy Field 2" := '';
        MyDocumentLine."Some Dummy Field 3" := '';
        MyDocumentLine."Some Dummy Field 4" := '';
        MyDocumentLine."Some Dummy Field 5" := '';
        MyDocumentLine."Some Dummy Field 6" := '';
        MyDocumentLine."Some Dummy Field 7" := '';
        MyDocumentLine."Some Dummy Field 8" := '';
        MyDocumentLine."Some Dummy Field 9" := '';
        MyDocumentLine."Some Dummy Field 10" := '';
        MyDocumentLine.Insert();
    end;
}