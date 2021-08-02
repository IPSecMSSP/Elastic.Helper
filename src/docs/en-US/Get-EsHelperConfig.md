---
external help file: Elastic.Helper-help.xml
Module Name: Elastic.Helper
schema: 2.0.0
---

# Get-EsHelperConfig

## SYNOPSIS

Import an Elastic Helper configuration.

## SYNTAX

```pwsh
Get-EsHelperConfig -ConfigName <ConfigurationName> [-Path <Path to Config directory>] [<CommonParameters>]
```

## DESCRIPTION

This function loads a saved configuration, in JSON format, from a file into memory.  The configuration file is expected to have a specific structure, see the examples folder in the project
for details. Index, pipeline

The default path used is .eshelper folder in the user's home directory (platform dependent)

## EXAMPLES

### Example 1

Load Configuration file 'elasticproject.json' from default folder into the $EsConf variable

```pwsh
PS C:\> $EsConf = Get-EsHelperConfig -ConfigName elasticproject
```

### Example 2

Load Configuration file 'elasticproject.json' from '/opt/scripts/project/etc'

```pwsh
PS C:\> $EsConf = Get-EsHelperConfig -ConfigName elasticproject -Path '/opt/scripts/project/etc'
```

## PARAMETERS

### ConfigName

Basename of the configuration file to read in.  The file is expected to be in JSON format, and will have **.json** appended to the filename.

### Path

Path where the configuration file will be found.  If not specified, the .eshelper folder in the user's home path will be used.

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (<http://go.microsoft.com/fwlink/?LinkID=113216>).

## INPUTS

### System.String -> Configuration Name

## OUTPUTS

### PSCustomObject (Hash) representing the configuration file contents

## NOTES

The function expects to build a path to a valid JSON file containing a specific structure.  An example configuration file can be found in the examples folder of the project.

## RELATED LINKS

[Elastic.Helper on GitHub](https://github.com/jberkers42/Elastic.Helper)
