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
        field(4; "Product Number"; Code[20])
        {
            Caption = 'Product Number';
            ExternalName = 'avd_productnumber';
            ExternalType = 'String';
        }
        field(20; CreatedOn; DateTime)
        {
            Caption = 'Created On';
            Description = 'Date and time when the product was created.';
            ExternalAccess = Read;
            ExternalName = 'createdon';
            ExternalType = 'DateTime';
        }
        field(21; ModifiedOn; DateTime)
        {
            Caption = 'Modified On';
            Description = 'Date and time when the product was last modified.';
            ExternalAccess = Read;
            ExternalName = 'modifiedon';
            ExternalType = 'DateTime';
        }
        field(22; CreatedBy; Guid)
        {
            Caption = 'Created By';
            Description = 'Unique identifier of the user who created the product.';
            ExternalAccess = Read;
            ExternalName = 'createdby';
            ExternalType = 'Lookup';
            TableRelation = "CRM Systemuser".SystemUserId;
        }
        field(23; ModifiedBy; Guid)
        {
            Caption = 'Modified By';
            Description = 'Unique identifier of the user who last modified the product.';
            ExternalAccess = Read;
            ExternalName = 'modifiedby';
            ExternalType = 'Lookup';
            TableRelation = "CRM Systemuser".SystemUserId;
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

