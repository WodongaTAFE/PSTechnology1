# PSTechnology1
PowerShell Module for [Technology1](https://technology1.com)

This module contains some helpful cmdlets for connecting to Technology1 web services.

## Installing

The module can be installed from the [PowerShell Gallery](https://www.powershellgallery.com/packages/Technology1/) from an elevated prompt using this command:

    Install-Module Technology1

## Connect to a Technology1 Instance

The first thing you'll need to do is connect to a Technology1 instance. We do this with `Connect-T1`, supplying a URL and either basic or OAuth credentials.

To have PowerShell ask for a service account's username and password and then connect with those credentials:

    $cred = Get-Credential
    Connect-T1 -Instance 'EXAMPLE' -Credential $cred

When you specify an instance name, the module will use it to construct a base URI like this:

    https://example.t1cloud.com/T1Default/CiAnywhere/Web/EXAMPLE

You can use the `-Uri` parameter to connect to a non-standard URI if needed.

If you've set up an OAuth IdP client (Confidential Client Type) then you can connect using OAuth like this:

    Connect-T1 -Instance 'EXAMPLE' -ClientID $myClientId -ClientSecret $myClientSecret

## Call a web service

To call a web service you've defined in your Technology1 instance, use the `Invoke-T1Request` function. For example, if you have a "reports as a service" web service called "Employees", you would use this command:

    Invoke-T1Request -Name Employees

If the result of the request has a "DataSet" property, that will be returned. If not, the response from T1 will be returned as-is.

If you need the messages or total row count from a request, you can optionally specify a `-MessagesVariable` or `-CountVariable` parameter and the named variables will be populated. For example:

    Invoke-T1Request -Name Employees -MessagesVariable mesgs -CountVariable count
    Write-Host $count
    Write-Host $mesgs

## Disconnecting

To ensure the Technology1 token is not preserved in your session, you can disconnect from the instance using this command:

    Disconnect-T1

Note that no network connections are maintained that need to be cleaned up with this command. It's only used to clear the locally cached URI and token.

## Cmdlets

Once you're connected, you have a bunch of commands you can use to query and/or update the connected Technology1 instance:

* Invoke-T1Request

All the commands that update data support a -WhatIf parameter, so you can practise without making any changes, and they're pretty well documented so adding a -? switch to any of them will give you some help.
