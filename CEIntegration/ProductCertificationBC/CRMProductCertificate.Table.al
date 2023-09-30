table 50900 "CRM Product Certificate"
{
    Caption = 'CRM Product Certificate';
    ExternalName = 'avd_productcertificate';
    TableType = CRM;

    fields
    {
        field(1; ProductCertificateId; Guid)
        {
            Caption = 'Certificate ID';
            ExternalName = 'avd_productcertificateid';
            ExternalAccess = Insert;
            ExternalType = 'Uniqueidentifier';
        }
        field(2; CertificateNo; Text[100])
        {
            Caption = 'Certificate No.';
            ExternalName = 'avd_certificateno';
            ExternalType = 'String';
        }
        field(3; "Product Id"; Text[250])
        {
            Caption = 'Product ID';
            ExternalName = 'avd_productid';
            ExternalType = 'Lookup';
            TableRelation = "CRM Product".ProductId;
        }
    }

    keys
    {
        key(PK; ProductCertificateId)
        {
            Clustered = true;
        }
    }
}

