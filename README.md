# ElasticSearch PowerShell Helper Module

This module provides a number of helper functions to make managing ElasticSearch installations easier.

This module requires that the Elastic.Console module is installed.  This can be done with:

```powershell
InstallModule -AllowPreRelease Elastic.Console
```

## Configuration

A Configuration file definition, plus a Config File loader function to read it.  Configurationfiles are assumed to be in `$HOME/.eshelper` unless otherwise specified.

### Configuration File

The configuration file is in JSON format, and borrows most of its structure from ElasticSearch itself.  The following is a high level of a sample configuration:

```json
{
    "eshome": "http://localhost:9200",
    "indices": [
        {
            "name": "index-name",
            "pipeline": "pipeline-name",
            "settings": {
                "index": {
                    "number_of_replicas": 0
                }
            }
        }
    ],
    "_ingest": {
        "pipelines": [
            {
                "name": "pipeline-name",
                "definition": {
                    "description": "Get your pipeline definition from Kibana.  Seriously, writing it by hand sucks."
                }
            }
        ]
    },
    "_enrich": {
        "policies": [
            {
                "name": "policy-name",
                "definition": {
                    "placeholder": "For this one you will have to read the ES Documentation"
                }
            }
        ]
    }
}
```

Within the configuration you can have multiple Indices, Pipelines and Enrichment Policies.  These may have dependencies on one another.

The Configuration can be read into a PSCustomObject, and passed to various helper functions to make life easier.

## Helper Functions

### Get-EsHelperConfig

Read the ElasticSearch Helper Configuration.  The configuration filename must end in `.json`.  By default it is assumed to be stored in `$HOME/.eshelper`.  If the file is elsewhere, specify this with `-Path`.

```powershell
Get-EsHelperConfig -ConfigName sample-config
```

The above would load a config file from `$HOME/.eshelper/sample-config.json`

### Get-EsPipeline

Get an ElasticSearch Pipeline status/definition.

### Update-EsPipeline

Update an ElasticSearch Pipeliune Definition

### Get-EsEnrichmentPolicy

Get an ElasticSearch Enrichment Policy Definition

### Update-EsEnrichmentPolicy

Update an ElasticSearch Enrichment Policy Definition

### Update-EsEnrichmentIndices

Update/rebuild the indices required for an enrichment policy

### Get-EsIndex

Get current ElasticSearch Index settings.

### Test-EsEnrichPolicyDepends

Check the dependencies for an Enrichment Policy.

### Test-EsPipelineDepends

Check the dependencies for an Ingest Pipeline.

### Test-EsIndexDepends

Check the Dependencies for an ElasticSearch Index

### Deploy-EsConfig

Push the saved configuration into ElasticSearch.  This will check the dependencies to ensure that only the bits that can be done are actually done.

### Update-EsEnrichIndicesFromIndex

Rebuild the Enrichment Indices that are depended on by an Enrichment Policy.  This needs to be done when content is added to an index.

### Get-EsIndexSettings

Same as earlier function.

### Update-EsIndexSettings

Update the settings for an index.  Typically used to set the number of replicas to 0 on a single-node ElasticSearch cluster.

### Update-EsIndexSettingsFromConfig

Same as above, only using the saved configuration file.
