codeunit 50900 "Sales Synch. Setup Defaults"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CRM Setup Defaults", 'OnGetCDSTableNo', '', false, false)]
    local procedure HandleOnGetCDSTableNo(BCTableNo: Integer; var CDSTableNo: Integer; var handled: Boolean)
    begin
        if BCTableNo = Database::"Item Certificate" then
            CDSTableNo := Database::"CRM Product Certificate";

        handled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CRM Setup Defaults", 'OnAddEntityTableMapping', '', false, false)]
    local procedure HandleOnAddEntityTableMapping(var TempNameValueBuffer: Record "Name/Value Buffer" temporary);
    var
        CRMSetupDefaults: Codeunit "CRM Setup Defaults";
    begin
        CRMSetupDefaults.AddEntityTableMapping(ItemCertificatesMappingTok, Database::"Item Certificate", TempNameValueBuffer);
        CRMSetupDefaults.AddEntityTableMapping(ItemCertificatesMappingTok, Database::"CRM Product Certificate", TempNameValueBuffer);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CDS Setup Defaults", 'OnAfterResetConfiguration', '', false, false)]
    local procedure SetupItemCertificateMappingOnAfterResetConfig(CDSConnectionSetup: Record "CDS Connection Setup")
    begin
        SetupItemCertificateTableMapping();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CRM Integration Management", 'OnBeforeHandleCustomIntegrationTableMapping', '', false, false)]
    local procedure HandleCustomIntegrationTableMappingReset(var IsHandled: Boolean; IntegrationTableMappingName: Code[20])
    begin
        SetupItemCertificateTableMapping();
        IsHandled := true;
    end;

    local procedure SetupItemCertificateTableMapping()
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        ItemCertificate: Record "Item Certificate";
        CRMProductCertificate: Record "CRM Product Certificate";
    begin
        InsertIntegrationTableMapping(
            IntegrationTableMapping, ItemCertificatesMappingTok,
            Database::"Item Certificate", Database::"CRM Product Certificate",
            ItemCertificate.FieldNo("Certificate No."), CRMProductCertificate.FieldNo(CertificateNo),
            '', '', false);

        IntegrationFieldMapping.CreateRecord(
            ItemCertificatesMappingTok,
            ItemCertificate.FieldNo("Item No."),
            CRMProductCertificate.FieldNo("Product Id"),
            IntegrationFieldMapping.Direction::FromIntegrationTable,
            '', true, false);

        RecreateJobQueueEntryFromIntTableMapping(IntegrationTableMapping, 30, true, 1440, CRMProductName.CDSServiceName());
    end;

    local procedure RecreateJobQueueEntryFromIntTableMapping(IntegrationTableMapping: Record "Integration Table Mapping"; IntervalInMinutes: Integer; ShouldRecreateJobQueueEntry: Boolean; InactivityTimeoutPeriod: Integer; ServiceName: Text)
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run", Codeunit::"Integration Synch. Job Runner");
        JobQueueEntry.SetRange("Record ID to Process", IntegrationTableMapping.RecordId());
        JobQueueEntry.DeleteTasks();

        JobQueueEntry.InitRecurringJob(IntervalInMinutes);
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := Codeunit::"Integration Synch. Job Runner";
        JobQueueEntry."Record ID to Process" := IntegrationTableMapping.RecordId();
        JobQueueEntry."Run in User Session" := false;
        JobQueueEntry.Description :=
            CopyStr(StrSubstNo(JobQueueEntryNameTok, IntegrationTableMapping.Name, ServiceName), 1, MaxStrLen(JobQueueEntry.Description));
        JobQueueEntry."Maximum No. of Attempts to Run" := 10;
        JobQueueEntry.Status := JobQueueEntry.Status::Ready;
        JobQueueEntry."Rerun Delay (sec.)" := 30;
        JobQueueEntry."Inactivity Timeout Period" := InactivityTimeoutPeriod;

        if ShouldRecreateJobQueueEntry then
            Codeunit.Run(Codeunit::"Job Queue - Enqueue", JobQueueEntry)
        else
            JobQueueEntry.Insert(true);
    end;

    local procedure InsertIntegrationTableMapping(var IntegrationTableMapping: Record "Integration Table Mapping"; MappingName: Code[20]; TableNo: Integer; IntegrationTableNo: Integer; IntegrationTableUIDFieldNo: Integer; IntegrationTableModifiedFieldNo: Integer; TableConfigTemplateCode: Code[10]; IntegrationTableConfigTemplateCode: Code[10]; SynchOnlyCoupledRecords: Boolean)
    var
        CDSIntegrationMgt: Codeunit "CDS Integration Mgt.";
    begin
        IntegrationTableMapping.CreateRecord(MappingName, TableNo, IntegrationTableNo, IntegrationTableUIDFieldNo,
            IntegrationTableModifiedFieldNo, TableConfigTemplateCode, IntegrationTableConfigTemplateCode,
            SynchOnlyCoupledRecords, IntegrationTableMapping.Direction::FromIntegrationTable, IntegrationTablePrefixTok,
            Codeunit::"CRM Integration Table Synch.", Codeunit::"CDS Int. Table Uncouple");
    end;

    var
        CRMProductName: Codeunit "CRM Product Name";
        IntegrationTablePrefixTok: Label 'Dynamics CRM', Locked = true;
        ItemCertificatesMappingTok: Label 'ITEMCERTIFICATE';
        JobQueueEntryNameTok: Label ' %1 - %2 synchronization job.', Comment = '%1 = The Integration Table Name to be synchronized, %2 = CRM product name';
}
