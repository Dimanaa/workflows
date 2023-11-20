$storageBucket = "workflows-7be96.appspot.com"
$localFilePath = ".github/workflows/ConsoleApp1/ConsoleApp1/bin/Debug/test.txt" 
$apiKey = $env:FIREBASE_API_KEY
$userEmail = $env:FIREBASE_USER_EMAIL
$userPassword = $env:FIREBASE_USER_PASSWORD
$endpoint = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey"

# JSON body for the request
$requestBody = @{
    email = $userEmail
    password = $userPassword
    returnSecureToken = $true
} | ConvertTo-Json

# Invoke REST method
$response = Invoke-RestMethod -Uri $endpoint -Method Post -ContentType "application/json" -Body $requestBody

# Extract the idToken
$idToken = $response.idToken

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
    "Authorization" = "Bearer $idToken"
    "Content-Type" = "text/plain"
    } 

# Read file content
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
UploadToFirebaseStorage -localFilePath $localFilePath -firebaseToken $idToken
