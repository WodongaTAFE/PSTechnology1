<#
.SYNOPSIS
    A helper function to call Technology1 web services.

.DESCRIPTION
    This function is usedto call Technology1 web services.

.PARAMETER Name
    The name of the web service to call.

.PARAMETER Type
    The type of service to call. Valid values are 'Raas', 'WS', and 'WFS'. The default value is 'Raas'.

.PARAMETER Version
    The version of the API to call. Valid values are 'v1' and 'v2'. The default value is 'v1'.

.PARAMETER Method
    The HTTP method to use for the request. Valid values are 'GET', 'POST', 'PUT', and 'DELETE'. The default value is 'GET'.

.PARAMETER Query
    An optional query string to filter the results.

.PARAMETER PageSize
    The number of records to return per page. The default value is 10000.

.PARAMETER Page
    The page number to return. The default value is 1.

.PARAMETER CountVariable
    The name of a variable to store the total record count in.

.PARAMETER MessagesVariable
    The name of a variable to store any messages returned by the API in.
#>
function Invoke-T1Request {
    [CmdletBinding()]
    param(
        # The name of the web service to call.
        [Parameter(Mandatory, Position=0)]
        [Alias('Service')]
        [Alias('Report')]
        [string] $Name,

        # The type of service to call.
        [ValidateSet('Raas', 'WS', 'WFS')]
        [string] $Type = 'Raas',

        # The version of the API to call.
        [ValidateSet('v1', 'v2')]
        [string] $Version = 'v1',

        # The HTTP method to use for the request.
        [ValidateSet('GET', 'POST', 'PUT', 'DELETE')]
        [string] $Method = 'GET',

        # An optional query string to filter the results.
        [Alias('Filter')]
        [string] $Query,

        # The number of records to return per page. 
        [int] $PageSize = 10000,

        # The page number to return.
        [int] $Page = 1,

        # The name of a variable to store the total record count in.
        [string] $CountVariable,

        # The name of a variable to store any messages returned by the API in.
        [string] $MessagesVariable
    )

    begin {
        $url = $Script:_t1Uri
        $auth = $Script:_t1Auth
        
        if (!$url -or !$auth) {
            throw "You must call the Connect-T1 cmdlet before calling any other cmdlets."
        }

        $headers = @{
            Authorization = $auth
            Accept = 'application/json'
        }
    }

    process {
        $path = "Api/$Type/$Version/$Name`?pageSize=$PageSize&page=$Page&"
        if ($Query) {
            $path += "q=$Query"
        }
        $uri = [uri]::new($url, $path)

        $result = Invoke-RestMethod -Uri $uri -Headers $headers -Method $Method -Verbose:$VerbosePreference
        
        if ($CountVariable) {
            Set-Variable -Name $CountVariable -Value $result.TotalRecordCount -Scope Global
        }

        if ($MessagesVariable) {
            Set-Variable -Name $MessagesVariable -Value $result.Messages -Scope Global
        }

        if ($result.DataSet) {
            return $result.DataSet
        }

        return $result
    }
}