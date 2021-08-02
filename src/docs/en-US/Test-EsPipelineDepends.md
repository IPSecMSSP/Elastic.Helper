---
external help file: Elastic.Helper-help.xml
Module Name: Elastic.Helper
schema: 2.0.0
---

# Test-EsPipelineDepends

## SYNOPSIS

Test if the Pipeline's Dependencies are met.

## SYNTAX

```powershell
Test-EsPipelineDepends -EsConfig $EsConfig [-PipelineName 'PipelineToTest']
```

## DESCRIPTION

Using the provided configuration definition, determine if it's dependencies are met in ElasticSearch.

Will check all defined Pipelines unless one is specified.

Checks ElasticSearch to confirm that the pipeline, and associated dependencies exist.

## EXAMPLES

### Example 1

Test all defined Pipelines for Dependencies

```powershell
PS C:\> $Result = Test-EsPipelineDepends -EsConfig $EsConfig
```

### Example 2

Test the MyPipeline Pipeline for Dependencies

```powershell
PS C:\> $Result = Test-EsPipelineDepends -EsConfig $EsConfig -PipelineName 'MyPipeline'
```

## PARAMETERS

### EsConfig

ElasticHelper configuration loaded using Get-EsHelperConfig.

### PipelineName

(Optional) Name of Pipeline to check for unmet dependencies.

If not specified, checks all defined Pipelines.

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

[Elastic.Helper on GitHub](https://github.com/jberkers42/Elastic.Helper)
