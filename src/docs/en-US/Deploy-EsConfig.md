---
external help file: Elastic.Helper-help.xml
Module Name: Elastic.Helper
schema: 2.0.0
---

# Deploy-EsConfig

## SYNOPSIS

Deploy specified ElasticSearch Resources to ElasticSearch cluster, with dependency checks.

## SYNTAX

```powershell
Deploy-EsConfig -EsConfig $EsConfig [-PipelineName 'PipelineToTest']
```

## DESCRIPTION

Using the provided configuration definition, deploy the defined resources to ElasticSearch.

Will check all dependencies are met before deploying to ElasticSeach, and will not attempt deployment of resources for which dependencies are not met.

This may be used iteratively to defined the required resouces in ElasticSearch as data is populated.

## EXAMPLES

### Example 1

Deploy all defined Resources that do not have unmet dependencies.

```powershell
PS C:\> $Result = Deploy-EsConfig -EsConfig $EsConfig
```

### Example 2

Deploy the specified resource if it does not have unmet dependencies.

```powershell
PS C:\> $Result = Deploy-EsConfig -EsConfig $EsConfig -ResourceName 'MyPipeline' -ResourceType 'index'
```

## PARAMETERS

### EsConfig

ElasticHelper configuration loaded using Get-EsHelperConfig.

### ReourceType

***Not Yet Implemented***
(Optional) Type of Resource to deploy to ElasticSearch.  One of:

* index
* pipeline
* enrichmentpolicy

If not specified, attempts to deploy all resources without unmet dependencies.

### ReourceName

***Not Yet Implemented***
(Optional) Name of Resource to deploy to ElasticSearch.  If specified, must also specify resource type.

If not specified, attempts to deploy all resources without unmet dependencies.

### EsCreds

PSCredential object containing username and password to access ElasticSearch

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (<http://go.microsoft.com/fwlink/?LinkID=113216>).

## INPUTS

### PSCustomObject -> ES Helper Configuration

## OUTPUTS

### Success Status

## NOTES

## RELATED LINKS

[Elastic.Helper on GitHub](https://github.com/jberkers42/Elastic-Helper)
