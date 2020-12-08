# Heroes Data
[![Build Status](https://dev.azure.com/kevinkoliva/Heroes%20of%20the%20Storm%20Projects/_apis/build/status/HeroesToolChest.heroes-data?branchName=master)](https://dev.azure.com/kevinkoliva/Heroes%20of%20the%20Storm%20Projects/_build/latest?definitionId=7&branchName=master) [![Release](https://img.shields.io/github/release/HeroesToolChest/heroes-data.svg)](https://github.com/HeroesToolChest/heroes-data/releases/latest)

This repo contains the Heroes of the Storm data files that are extracted from [Heroes Data Parser](https://github.com/HeroesToolChest/HeroesDataParser). The images are stored in the [Heroes Images](https://github.com/HeroesToolChest/heroes-images) repo.

All files are in json format. The version folders contain data and gamestring folders. The data files have been localized, which means the localized text has been removed and stored in the gamestring json files.

The version folders also contain a `.hdp.json` file which contains up to two properties. Example:
```
{
  "hdp": "4.3.1",
  "duplicate": {
    "data": "2.48.1.76437",
    "gamestring": "2.48.1.76437"
  }
}
```
The `hdp` property specifies the version of Heroes Data Parser used to extract the data and gamestrings.

The optional `duplicate` property indicates that this version of data is a duplicate of another version, which is specified in the `data` and `gamestrings` property. As such, there are no data and gamestrings folders. 

**NOTE: This optional property will not appear just because the data is a duplicate of another version, but rather that duplicate version data was not obtainable or was just not extracted.**

## Json Data Parsing Library
[Heroes Icons](https://github.com/HeroesToolChest/Heroes.Icons) is a .NET libray that parses the json files and provides objects to easily access the data.

## Releases
Releases will have have up to three zip files. A `_all`, `_last`, and a `_new`.

The `_all` will contain all the versions.  
The `_last` will only contain the last version.  
The `_new` will contain only the new or modified file(s) from the last release.

Releases will be published when a new patch is released or when there are updates or fixes applied to existing data or gamestrings. When the latter happens, the published tag will end with an underscore number (_x).

## Heroes Data Parser Extraction
The following command was used (same for [Heroes Images](https://github.com/HeroesToolChest/heroes-images)):
```
'Path/To/Game' --extract-data all --extract-images all --localization all --localized-text
```
Then the following command was used to convert the gamestring files to json:
```
localized-json 'Path/To/gamestring-directory'
```
