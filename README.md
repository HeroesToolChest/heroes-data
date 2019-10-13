# Heroes Data
This repo contains the Heroes of the Storm data files that are extracted from [Heroes Data Parser](https://github.com/HeroesToolChest/HeroesDataParser). The images are stored in the [Heroes Images](https://github.com/HeroesToolChest/heroes-images) repo.

All files are in json format. The version folders contain data and gamestring folders. The data files have been localized, which means the localized text has been removed and stored in the gamestring json files.

## Heroes Data Parser Extraction
The following command was used:
```
'Path/To/Game' --extract-data all --extract-images all --localization all --localized-text
```
Then the following command was used to convert the gamestring files to json:
```
localized-json 'Path/To/gamestring-directory'
```
