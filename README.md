# Heroes Data
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

**NOTE: This optional property will not appear just because the data is a duplicate of another version, but because that duplicate version data was not obtainable or I just did not extract it.**

## Heroes Data Parser Extraction
The following command was used:
```
'Path/To/Game' --extract-data all --extract-images all --localization all --localized-text
```
Then the following command was used to convert the gamestring files to json:
```
localized-json 'Path/To/gamestring-directory'
```
