using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using Azure.Storage.Blobs;
using Azure.Identity;
using System.Text.Json;
using Azure.Storage.Blobs.Models;
using Azure;

namespace ADR.BlobContainer
{
    public class ContainerAcccessor
    {
        private readonly ILogger<ContainerAcccessor> _logger;

        public ContainerAcccessor(ILogger<ContainerAcccessor> logger)
        {
            _logger = logger;
        }

        [Function("ListBlobs")]
        public IActionResult Run([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequest req)
        {
            List<string> blobsList = new List<string>();

            try {
               var blobs = GetBlobContainerClient(GetRequestParam(req, "account"), GetRequestParam(req, "container")).GetBlobs();

                foreach (BlobItem item in blobs) {
                    blobsList.Add(item.Name);
                }
            }
            catch (ArgumentNullException ex) {
                return new BadRequestObjectResult(ex.Message);
            }
            catch (RequestFailedException ex) {
                return new ObjectResult(ex.Message) {
                    StatusCode = ex.Status
                };
            }
            catch (Exception ex) {
                return new ObjectResult(ex.Message) {
                    StatusCode = StatusCodes.Status500InternalServerError
                };
            }

            return new OkObjectResult(JsonSerializer.Serialize(blobsList));
        }

        [Function("HealthCheck")]
        public IActionResult CheckAppHealth([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequest req)
        {
            try {
                GetBlobServiceClient(GetRequestParam(req, "account")).GetBlobContainers();
            }
            catch (Exception ex) {
                return new ObjectResult(ex.Message) {
                    StatusCode = StatusCodes.Status500InternalServerError
                };
            }

            return new OkObjectResult("");
        }

        private BlobServiceClient GetBlobServiceClient(string accountName)
        {
            const string storageAccountUri = "https://{0}.blob.core.windows.net/";
            return new BlobServiceClient(new Uri(string.Format(storageAccountUri, accountName)), new DefaultAzureCredential());
        }

        private BlobContainerClient GetBlobContainerClient(string accountName, string containerName)
        {
            return GetBlobServiceClient(accountName).GetBlobContainerClient(containerName);
        }

        private string GetRequestParam(HttpRequest req, string paramName)
        {
            string? paramValue = null;
            if (req.Query.ContainsKey(paramName)) {
                paramValue = req.Query[paramName];
            }

            if (paramValue == null || paramValue == string.Empty) {
                throw new ArgumentNullException(paramName);
            }

            return paramValue;
        }
    }
}
