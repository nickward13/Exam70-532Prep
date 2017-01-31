using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Azure; // Namespace for CloudConfigurationManager
using Microsoft.WindowsAzure.Storage; // Namespace for CloudStorageAccount
using Microsoft.WindowsAzure.Storage.Blob; // Namespace for Blob storage types

namespace UploadScriptToStorage
{
    class Program
    {
        static void Main(string[] args)
        {
            // Build the connection string from args
            // DefaultEndpointsProtocol=https;AccountName=****;AccountKey=****

            if(args.Count() != 2)
            {
                Console.WriteLine("Insufficient arguments.  Usage: UploadScriptToStorage <AccountName> <AccountKey>");
                return;
            }

            var accountName = args[0];
            var accountKey = args[1];

            var storageConnectionString = String.Concat("DefaultEndpointsProtocol=https;AccountName=", accountName,
                ";AccountKey=", accountKey);

            // Get the storage connection string from the App.config file
            //var StorageConnectionString = CloudConfigurationManager.GetSetting("StorageConnectionString");

            // Parse the connection string and return a reference to the storage account.
            Console.WriteLine("Connecting to storage account '{0}'", accountName);
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(storageConnectionString);

            // Create the blob client.
            CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();

            // Retrieve a reference to a container.
            CloudBlobContainer container = blobClient.GetContainerReference("customscriptfiles");

            // Create the container if it doesn't already exist.
            Console.WriteLine("Creating the container if it doesn't exist");
            container.CreateIfNotExists();
            container.SetPermissions(
                new BlobContainerPermissions { PublicAccess = BlobContainerPublicAccessType.Blob });

            // Retrieve reference to a blob named "myblob".
            CloudBlockBlob blockBlob = container.GetBlockBlobReference("Script.ps1");

            // Create or overwrite the "myblob" blob with contents from a local file.
            Console.WriteLine("Uploading the script file to the blob");
            using (var fileStream = System.IO.File.OpenRead(@"C:\Users\nickward\source\repos\Exam70-532Prep\03CustomScriptExtension\Script.ps1"))
            {
                blockBlob.UploadFromStream(fileStream);
            }

            Console.WriteLine("Finished");
        }
    }
}
