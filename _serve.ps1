$root = $PSScriptRoot
$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add("http://127.0.0.1:8765/")
$listener.Start()
Write-Host "Serving $root at http://127.0.0.1:8765/"
while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    $path = [Uri]::UnescapeDataString($ctx.Request.Url.LocalPath.TrimStart("/"))
    if ([string]::IsNullOrWhiteSpace($path)) { $path = "index.html" }
    $full = Join-Path $root $path
    if (Test-Path $full -PathType Leaf) {
        $ext = [IO.Path]::GetExtension($full).ToLowerInvariant()
        $types = @{
            ".html" = "text/html"; ".css" = "text/css"; ".js" = "application/javascript"
            ".jpg" = "image/jpeg"; ".jpeg" = "image/jpeg"; ".png" = "image/png"
            ".m4v" = "video/mp4"; ".mp4" = "video/mp4"
        }
        $ctx.Response.ContentType = $(if ($types.ContainsKey($ext)) { $types[$ext] } else { "application/octet-stream" })
        $bytes = [IO.File]::ReadAllBytes($full)
        $ctx.Response.StatusCode = 200
        $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
        $ctx.Response.StatusCode = 404
    }
    $ctx.Response.Close()
}
