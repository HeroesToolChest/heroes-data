## Submitting Pull Requests
All generated data and gamestrings must come from [Heroes Data Parser](https://github.com/HeroesToolChest/HeroesDataParser) using the
following command. Please note that `--extract-image` is only needed if planning to submit images to [Heroes Images](https://github.com/HeroesToolChest/heroes-images).
```
'Path/To/Game' --extract-data all --extract-images all --localization all --localized-text
```

Then the following command must be used to convert the gamestring text files to json:
```
localized-json 'Path/To/gamestring-directory'
```

The `.hdp.json` is **required** with the pull request with the following format
```
{
  "hdp": "x.x.x",
}
```
`x.x.x` is the hdp version that was used.
