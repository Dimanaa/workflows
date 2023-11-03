$firebaseProject = "workflows-7be96"
$storageBucket = "workflows-7be96.appspot.com"
$localFilePath = ".github/workflows/ConsoleApp1/ConsoleApp1/bin/Debug/ConsoleApp1.exe" 
$firebaseToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJodHRwczovL2lkZW50aXR5dG9vbGtpdC5nb29nbGVhcGlzLmNvbS9nb29nbGUuaWRlbnRpdHkuaWRlbnRpdHl0b29sa2l0LnYxLklkZW50aXR5VG9vbGtpdCIsImlhdCI6MTY5OTAxNzM2MiwiZXhwIjoxNjk5MDIwOTYyLCJpc3MiOiJmaXJlYmFzZS1hZG1pbnNkay1nNmxib0B3b3JrZmxvd3MtN2JlOTYuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJzdWIiOiJmaXJlYmFzZS1hZG1pbnNkay1nNmxib0B3b3JrZmxvd3MtN2JlOTYuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJ1aWQiOiJmaXJlYmFzZS1hZG1pbnNkay1nNmxib0B3b3JrZmxvd3MtN2JlOTYuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20ifQ.j7plO3w8r03DoWbIOe13E6_zKExTd4QZBzHVcDsqEgps7suOv0oSzsepPTqU0iKCpmHoVkqWqOITc6XBe0JjUsvdRfrXajWdh7UDbEIvBrV6Sx4fIqPHIDTKAIsai9j7WYN67DrI_ZT4vuRAxR609Wvq_N2OPzyOnKZ-p4Luk3WDQuzc-nIk1XM9mLnfvofqQgA9X9Og8_T_Ph19MMCRP5MJkAtWwJeQgapHtRnoZEF2thID3qzBnCuDSUGOTNRdGyTwhqR0URF02XllzN3_kNjbSga5CerTSryEdGNJZ-598ERGqsLtl6fGxgj1pZFbBBF1PWiK2EcoP9fuSO49TQ"

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
