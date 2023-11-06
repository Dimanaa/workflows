$storageBucket = "workflows-7be96.appspot.com"
$localFilePath = ".github/workflows/ConsoleApp1/ConsoleApp1/bin/Debug/test.txt" 
$firebaseToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJodHRwczovL2lkZW50aXR5dG9vbGtpdC5nb29nbGVhcGlzLmNvbS9nb29nbGUuaWRlbnRpdHkuaWRlbnRpdHl0b29sa2l0LnYxLklkZW50aXR5VG9vbGtpdCIsImlhdCI6MTY5OTI3NzU1MywiZXhwIjoxNjk5MjgxMTUzLCJpc3MiOiJmaXJlYmFzZS1hZG1pbnNkay1nNmxib0B3b3JrZmxvd3MtN2JlOTYuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJzdWIiOiJmaXJlYmFzZS1hZG1pbnNkay1nNmxib0B3b3JrZmxvd3MtN2JlOTYuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJ1aWQiOiJmaXJlYmFzZS1hZG1pbnNkay1nNmxib0B3b3JrZmxvd3MtN2JlOTYuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20ifQ.U8krvZ1XxB2SmVd3F390UZbnEjm7lGjV6WrVX_xbILKKynDjWmVIzqrqVUFbAWg0KbDcdesnayJmwuDF0-R7E3RxHxhaJG3VzdeAV95v4YT5RidaiDfcy_iwWOOYX-FUNb4YvneN0ti0du7NHOvspS6pI1Ia00NsVvAf6c4w78g_GBrE5wds7VgO69qj30bUk3qE7Gsb7_QMm_fu_IkuDqHE3Zzt6BtQEJ3yGq6yETlJ1RF3n3JePKIZOFpv41UAFbp8pnrZD29thonSkbO_VaC6tjwmTOq2Osa77y1g2TnQQJcTepLz085K54J_Rzah1p7V3NovCZUm-w1-dlsokQ"

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
        "Content-Type" = "text/plain"
    }

    # Read file content
    #$fileBytes = [System.IO.File]::ReadAllBytes($localFilePath)
    #$fileBase64 = [Convert]::ToBase64String($fileBytes)
    $fileContent = Get-Content -Path $localFilePath
    Write-Host $fileContent

    # JSON body for the upload request
    $body = @{
        "name" = $fileName
        "data" = $fileContent -join [Environment]::NewLine
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
