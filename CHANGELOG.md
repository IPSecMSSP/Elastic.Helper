# Changelog

All notable changes have been documented in this file.

## [0.1.0] - 2022-04-22

### Changed

- Break bulk index request into chunks, default chunk size of 10k
- Don't sleep in Invoke-EsBulkIndexRequest, moved to Update-EsEnrichmentIndicesFromIndex and time halved
- Update CI Pipeline to use latest Megalinter

### Fixed

- Code indentation on various files
- Issue with Deploy-EsConfig with dependency checks where dependency check would fail if resource does not exist

## [0.0.11] - 2022-04-13

### Changed

- Spelling of something

## [0.0.10] - 2022-04-13

### Changed

- Force exact match for index definition in Invoke-EsBulkIndexRequest

## [0.0.9] - 2022-04-13

### Changed

- Add switch to match exact for retrieving index definition from config

## [0.0.8] - 2022-04-12

### Changed

- Remove index name from URI for Bulk Index Requests

## [0.0.7] - 2021-09-10

Initial PowerShell Module publication

### Changed

- Various adjustments of build and test scripts for publishing PS Module

## [0.0.3] - 2021-08-02

Authentication Support and Documentation enhancements.

### Changed

- All functions that interface to ElasticSearch now support Authentication
- Added Help/Documentation to every function

### Added

- Private Function Test-Guid for future use

## [0.0.2] - 2021-07-28

Restructured into a more better module.

### Changed

- Separated each function into its own file
- Structured functions into areas

## [0.0.1] - 2021-05-11

The initial module framework.

### Added

- CHANGELOG.md
- README.md
- Module elements
