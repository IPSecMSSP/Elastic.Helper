---
external help file: Elastic.Helper-help.xml
Module Name: Elastic.Helper
schema: 2.0.0
---

# Get-EsHelperConfig

## SYNOPSIS

Load the Elastic.Helper configuration from a saved file

## SYNTAX

```pwsh
Get-EsHelperConfig -ConfigName <ConfigurationName> [-Path <Path to Config directory>] [<CommonParameters>]
```

The default path used is .eshelper folder in the user's home directory (platform dependent)

## DESCRIPTION

This function loads a saved configuration, in JSON format, from a file into memory.  The configuration file is expected to have a specific structure, see the examples folder in the project
for details. Index, pipeline

## EXAMPLES

### Example 1

```pwsh
PS C:> Get-EsHelperConfig -ConfigName fresh-elastic
```

Load a configuration file named fresh-elastic.json from .eshelper folder in user's home directory.

## PARAMETERS

### ConfigName

Basename of the configuration file to read in.  The file is expected to be in JSON format, and will have **.json** appended to the filename.

### Path

Path where the configuration file will be found.  If not specified, the .eshelper folder in the user's home path will be used.

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (<http://go.microsoft.com/fwlink/?LinkID=113216>).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
