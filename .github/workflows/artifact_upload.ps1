$firebaseProject = "workflows-7be96"
$storageBucket = "workflows-7be96.appspot.com"
$localFilePath = ".github/workflows/ConsoleApp1/ConsoleApp1/bin/Debug/ConsoleApp1.exe" 
$firebaseToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJodHRwczovL2lkZW50aXR5dG9vbGtpdC5nb29nbGVhcGlzLmNvbS9nb29nbGUuaWRlbnRpdHkuaWRlbnRpdHl0b29sa2l0LnYxLklkZW50aXR5VG9vbGtpdCIsImlhdCI6MTY5ODkzNzU0OCwiZXhwIjoxNjk4OTQxMTQ4LCJpc3MiOiJmaXJlYmFzZS1hZG1pbnNkay1nNmxib0B3b3JrZmxvd3MtN2JlOTYuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJzdWIiOiJmaXJlYmFzZS1hZG1pbnNkay1nNmxib0B3b3JrZmxvd3MtN2JlOTYuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJ1aWQiOiJIekpsWWlYbWFlWU14Z3UwQnlpZlV0b3JwVWkxIn0.A8Gv-6In6VsnYThZNdarJyd4AqVmc9ojaarKq9sgoTx5A2z5Qyw7whQ2CQiE7ERE8-HgbCCvO2w-9kfU7NQ2EnxQNqhepS38BDhGW18Y0sIvERonn9KEuC5MhS9enGtQ8NyF9uz_-SeArlWXte13rFbDU7j5bZ2kmfN9-eqP9rPJasov_VWWL1fwToBt2qdApQ4IsWVZGccnBJQT2c7fic4OB1bVpbAhrgCQhPsQUlzLxSY9r1r7f8I4AaHki5AUba71w-0a72yTVyWORj_gLYHGw1JL9icpGaYUinD1wCCEyv1q7OYdrwqgqdot_DjRnDoD_ASEkOYg55YGvRi0lQ"

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
