function Connect-T1 {
    param(
        [Parameter(Mandatory,Position=0,ParameterSetName='uri-basic')]
        [Parameter(Mandatory,Position=0,ParameterSetName='uri-oauth')]
        [Uri] $Uri,

        [Parameter(Mandatory,Position=0,ParameterSetName='saas-basic')]
        [Parameter(Mandatory,Position=0,ParameterSetName='saas-oauth')]
        [string] $Instance,

        [Parameter(Mandatory,Position=1,ParameterSetName='uri-basic')]
        [Parameter(Mandatory,Position=1,ParameterSetName='saas-basic')]
        [PSCredential] $Credential,

        [Parameter(Mandatory,Position=1,ParameterSetName='uri-oauth')]
        [Parameter(Mandatory,Position=1,ParameterSetName='saas-oauth')]
        [string] $ClientId,

        [Parameter(Mandatory,Position=2,ParameterSetName='uri-oauth')]
        [Parameter(Mandatory,Position=2,ParameterSetName='saas-oauth')]
        [string] $ClientSecret
    )

    if ($Instance) {
        $Uri = "https://$Instance.t1cloud.com/T1Default/CiAnywhere/Web/$Instance/"
    }

    if ($Uri.OriginalString -notlike '*`/') {
        $Uri = [uri]::new($Uri.OriginalString + '/')
    }
    $Script:_t1Uri = $Uri

    if ($PSCmdlet.ParameterSetName -like '*-oauth') {
        $params = @{
            Uri = [uri]::new($Uri, 'oauth2/access_token')
            Method = 'Post'
            ContentType = 'application/x-www-form-urlencoded'
            Body = @{
                'client_id' = $ClientId
                'client_secret' = $ClientSecret
                'grant_type' = 'client_credentials'
            }
        }

        $Script:_t1Auth = 'Bearer ' + (Invoke-RestMethod @params).access_token
        return
    }

    # Use basic auth.
    $Script:_t1Auth = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($credential.UserName.ToUpper() + ':' + $credential.GetNetworkCredential().Password))
}
