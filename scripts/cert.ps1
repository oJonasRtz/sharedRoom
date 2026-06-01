$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$certDir = Join-Path $scriptDir '..\server\certs'
$certFile = Join-Path $certDir 'server.cert'
$keyFile = Join-Path $certDir 'server.key'
$hostNames = @('localhost', '127.0.0.1', '::1')

Write-Host 'Generating SSL certificates with mkcert...'

if ((Test-Path $certFile) -and (Test-Path $keyFile)) {
	Write-Host 'SSL certificates already exist:'
	Write-Host "  $certFile"
	Write-Host "  $keyFile"
	exit 0
}

New-Item -ItemType Directory -Force -Path $certDir | Out-Null

$mkcert = Get-Command mkcert -ErrorAction SilentlyContinue
if ($mkcert) {
	& $mkcert.Path -cert-file $certFile -key-file $keyFile @hostNames | Out-Null
} else {
	$makecert = Get-Command makecert.exe -ErrorAction SilentlyContinue
	if (-not $makecert) {
		$makecert = Get-Command makecert -ErrorAction SilentlyContinue
	}

	if (-not $makecert) {
		throw 'mkcert was not found in PATH. Install mkcert or the Windows SDK tooling that provides makecert.exe.'
	}

	$tempCerFile = Join-Path $certDir 'server-temp.cer'
	$subject = 'CN=localhost'
	$storePath = 'Cert:\CurrentUser\My'

	& $makecert.Path -r -pe -n $subject -a sha256 -len 2048 -eku 1.3.6.1.5.5.7.3.1 -sky exchange -ss My -sr CurrentUser $tempCerFile | Out-Null

	$certificate = Get-ChildItem $storePath |
		Where-Object { $_.Subject -eq $subject -and $_.HasPrivateKey } |
		Sort-Object NotBefore -Descending |
		Select-Object -First 1

	if (-not $certificate) {
		throw "Unable to find a generated certificate for subject $subject in $storePath."
	}

	$certBytes = $certificate.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert)
	$certBase64 = [Convert]::ToBase64String($certBytes, [System.Base64FormattingOptions]::InsertLineBreaks)
	$certPem = @(
		'-----BEGIN CERTIFICATE-----'
		$certBase64
		'-----END CERTIFICATE-----'
	) -join "`n"

	$privateKey = $certificate.GetRSAPrivateKey()
	if (-not $privateKey) {
		throw 'The generated certificate does not expose an RSA private key.'
	}

	$keyBytes = $privateKey.ExportPkcs8PrivateKey()
	$keyBase64 = [Convert]::ToBase64String($keyBytes, [System.Base64FormattingOptions]::InsertLineBreaks)
	$keyPem = @(
		'-----BEGIN PRIVATE KEY-----'
		$keyBase64
		'-----END PRIVATE KEY-----'
	) -join "`n"

	[System.IO.File]::WriteAllText($certFile, $certPem + "`n", [System.Text.Encoding]::ASCII)
	[System.IO.File]::WriteAllText($keyFile, $keyPem + "`n", [System.Text.Encoding]::ASCII)

	if (Test-Path $tempCerFile) {
		Remove-Item $tempCerFile -Force
	}
}

Write-Host 'SSL certificates generated:'
Write-Host "  $certFile"
Write-Host "  $keyFile"