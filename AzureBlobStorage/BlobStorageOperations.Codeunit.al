codeunit 50100 "BLOB Storage Operations"
{
    procedure UploadFile()
    var
        TempBlob: Codeunit "Temp Blob";
        StorageServicesAuthorization: Codeunit "Storage Service Authorization";
        ABSBlobClient: Codeunit "ABS Blob Client";
        ABSOperationResponse: Codeunit "ABS Operation Response";
        Authorization: Interface "Storage Service Authorization";
        BlobInStream: InStream;
        FileName: Text;
        FileDialogPromptTok: Label 'Select a file to upload';
        AllowedFileTypesTok: Label 'Text files|*.txt';
        ContainerNameTok: Label 'blogsample';
    begin
        FileName :=
            FileManagement.BLOBImportWithFilter(TempBlob, FileDialogPromptTok, '', AllowedFileTypesTok, AllowedFileTypesTok);

        if FileName = '' then
            exit;

        Authorization := StorageServicesAuthorization.CreateSharedKey(GetSharedKey());

        TempBlob.CreateInStream(BlobInStream);
        ABSBlobClient.Initialize(GetStorageAccount(), ContainerNameTok, Authorization);
        ABSOperationResponse := ABSBlobClient.PutBlobBlockBlobStream(FileName, BlobInStream);

        if not ABSOperationResponse.IsSuccessful() then
            Error(ABSOperationResponse.GetError());
    end;

    procedure ListBlobsInContainer()
    begin

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
}
