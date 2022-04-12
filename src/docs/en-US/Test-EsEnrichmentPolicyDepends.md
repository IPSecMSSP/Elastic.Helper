---
external help file: Elastic.Helper-help.xml
Module Name: Elastic.Helper
schema: 2.0.0
---

# Test-EsEnrichmentPolicyDepends

## SYNOPSIS

Test if the Enrichment Policy's Dependencies are met.

## SYNTAX

```powershell
Test-EsEnrichmentPolicyDepends -EsConfig $EsConfig [-PolicyName 'PolicyToTest']
```

## DESCRIPTION

Using the provided configuration definition, determine if it's dependencies are met in ElasticSearch.

Will check all defined enrichment policies unless one is specified.

Checks ElasticSearch to confirm that the index on which the policy is based exists.

## EXAMPLES

### Example 1

Test all defined Enrichment Policies for Dependencies

```powershell
PS C:\> $Result = Test-EsEnrichmentPolicyDepends -EsConfig $EsConfig
```

### Example 2

Test the MyEnrichmentPolicy Enrichment Policy for Dependencies

```powershell
PS C:\> $Result = Test-EsEnrichmentPolicyDepends -EsConfig $EsConfig -PolicyName 'MyEnrichmentPolicy'
```

## PARAMETERS

### EsConfig

ElasticHelper configuration loaded using Get-EsHelperConfig.

### PolicyName

(Optional) Name of Enrichment Policy to check for unmet dependencies.

If not specified, checks all defined Enrichment Policies.

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (<http://go.microsoft.com/fwlink/?LinkID=113216>).

## INPUTS

### PSCustomObject -> ES Helper Configuration

## OUTPUTS

### Success Status

## NOTES

## RELATED LINKS

[Elastic.Helper on GitHub](https://github.com/jberkers42/Elastic.Helper)
