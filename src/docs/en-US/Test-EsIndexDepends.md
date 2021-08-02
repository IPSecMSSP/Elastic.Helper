---
external help file: Elastic.Helper-help.xml
Module Name: Elastic.Helper
schema: 2.0.0
---

# Test-EsIndexDepends

## SYNOPSIS

Test if the Index's Dependencies are met.

## SYNTAX

```powershell
Test-EsIndexDepends -EsConfig $EsConfig [-IndexName 'IndexToTest']
```

## DESCRIPTION

Using the provided configuration definition, determine if it's dependencies are met in ElasticSearch.

Will check all defined indices unless one is specified.

Checks ElasticSearch to confirm that the pipeline, and associated dependencies, configured for the index exists.

## EXAMPLES

### Example 1

Test all defined Indices for Dependencies

```powershell
PS C:\> $Result = Test-EsIndexDepends -EsConfig $EsConfig
```

### Example 2

Test the MyIndex Index for Dependencies

```powershell
PS C:\> $Result = Test-EsEIndexDepends -EsConfig $EsConfig -IndexName 'MyIndex'
```

## PARAMETERS

### EsConfig

ElasticHelper configuration loaded using Get-EsHelperConfig.

### IndexName

(Optional) Name of Index to check for unmet dependencies.

If not specified, checks all defined Indices.

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
