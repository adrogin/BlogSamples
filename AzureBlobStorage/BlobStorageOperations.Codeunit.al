codeunit 50100 "BLOB Storage Operations"
{
    procedure ListContainers(var ABSContainer: Record "ABS Container")
    var
        ABSContainerClient: Codeunit "ABS Container Client";
        ABSOperationResponse: Codeunit "ABS Operation Response";
        Authorization: Interface "Storage Service Authorization";
    begin
        Authorization := StorageServicesAuthorization.CreateSharedKey(GetSharedKey());
        ABSContainerClient.Initialize(GetStorageAccount(), Authorization);
        ABSOperationResponse := ABSContainerClient.ListContainers(ABSContainer);

        if not ABSOperationResponse.IsSuccessful() then
            Error(ABSOperationResponse.GetError());
    end;

    procedure UploadFile(ContainerName: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        ABSBlobClient: Codeunit "ABS Blob Client";
        ABSOperationResponse: Codeunit "ABS Operation Response";
        Authorization: Interface "Storage Service Authorization";
        BlobInStream: InStream;
        FileName: Text;
        FileDialogPromptTok: Label 'Select a file to upload';
        AllowedFileTypesTok: Label 'Text files|*.txt|All files|*.*';
    begin
        FileName :=
            FileManagement.BLOBImportWithFilter(TempBlob, FileDialogPromptTok, '', AllowedFileTypesTok, AllowedFileTypesTok);

        if FileName = '' then
            exit;

        Authorization := StorageServicesAuthorization.CreateSharedKey(GetSharedKey());

        TempBlob.CreateInStream(BlobInStream);
        ABSBlobClient.Initialize(GetStorageAccount(), ContainerName, Authorization);
        ABSOperationResponse := ABSBlobClient.PutBlobBlockBlobStream(FileName, BlobInStream);

        if not ABSOperationResponse.IsSuccessful() then
            Error(ABSOperationResponse.GetError());
    end;

    procedure ListBlobsInContainer(ContainerName: Text; var ABSContainerContent: Record "ABS Container Content")
    var
        ABSBlobClient: Codeunit "ABS Blob Client";
        ABSOperationResponse: Codeunit "ABS Operation Response";
        Authorization: Interface "Storage Service Authorization";
    begin
        Authorization := StorageServicesAuthorization.CreateSharedKey(GetSharedKey());
        ABSBlobClient.Initialize(GetStorageAccount(), ContainerName, Authorization);
        ABSOperationResponse := ABSBlobClient.ListBlobs(ABSContainerContent);

        if not ABSOperationResponse.IsSuccessful() then
            Error(ABSOperationResponse.GetError());
    end;

    procedure DeleteBlob(ContainerName: Text; BlobName: Text)
    var
        ABSBlobClient: Codeunit "ABS Blob Client";
        ABSOperationResponse: Codeunit "ABS Operation Response";
        Authorization: Interface "Storage Service Authorization";
    begin
        Authorization := StorageServicesAuthorization.CreateSharedKey(GetSharedKey());
        ABSBlobClient.Initialize(GetStorageAccount(), ContainerName, Authorization);
        ABSOperationResponse := ABSBlobClient.DeleteBlob(BlobName);

        if not ABSOperationResponse.IsSuccessful() then
            Error(ABSOperationResponse.GetError());
    end;

    local procedure GetSharedKey(): Text
    var
        AzureStorageSetup: Record "Azure Storage Setup";
    begin
        AzureStorageSetup.Get();
        exit(AzureStorageSetup."Access Key");
    end;

    local procedure GetStorageAccount(): Text
    var
        AzureStorageSetup: Record "Azure Storage Setup";
    begin
        AzureStorageSetup.Get();
        exit(AzureStorageSetup."Storage Account Name");
    end;

    var
        FileManagement: Codeunit "File Management";
        StorageServicesAuthorization: Codeunit "Storage Service Authorization";
}
