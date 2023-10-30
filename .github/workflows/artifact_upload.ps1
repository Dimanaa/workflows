$firebaseProject = "workflows-7be96"
$storageBucket = "workflows-7be96.appspot.com"
$localFilePath = ".github/workflows/ConsoleApp1/ConsoleApp1/bin/Debug/ConsoleApp1.exe" 
$firebaseToken = "1//09to3euoMz1AXCgYIARAAGAkSNwF-L9IrArQ7OBc1ysGme50KRI_fcaO_yLPp1ZkLVpzOnAqhbF58Y6MKYmw54CqnxQ4F2CmNvpM"

# Set Firebase project and access token
firebase login:ci

# Function to upload file to Firebase Cloud Storage
function UploadToFirebaseStorage {
    param (
        [string]$localFilePath,
        [string]$firebaseToken
    )

    # Get the filename from the path
    $fileName = [System.IO.Path]::GetFileName($localFilePath)

    # Firebase Cloud Storage API URL
    $uploadUrl = "https://firebasestorage.googleapis.com/v0/b/$storageBucket/o/$fileName"

    # Create Authorization header with the Firebase token
    $headers = @{
        "Authorization" = "Bearer $firebaseToken"
    }

    # Read file content
    $fileBytes = [System.IO.File]::ReadAllBytes($localFilePath)
    $fileBase64 = [Convert]::ToBase64String($fileBytes)

    # JSON body for the upload request
    $body = @{
        "name" = $fileName
        "contentType" = "application/octet-stream"
        "data" = $fileBase64
    } | ConvertTo-Json

    try {
        # Send request to Firebase Storage API for file upload
        $response = Invoke-RestMethod -Uri $uploadUrl -Method Post -Headers $headers -Body $body -ContentType "application/json"

        Write-Host "File uploaded successfully. Download URL: $($response.downloadTokens)"
    }
    catch {
        Write-Host "Error uploading file: $_"
    }
}

# Upload the file to Firebase Cloud Storage
UploadToFirebaseStorage -localFilePath $localFilePath -firebaseToken $firebaseToken
