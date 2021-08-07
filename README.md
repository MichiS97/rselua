# rselua
Lua scripts for making some tasks in the 3rd gen Pokemon games a little less tedious.
Currently officially supports the German versions of Ruby/Sapphire and FireRed/LeafGreen.
Support for Emerald is absolutely planned and support for other languages will eventually be added as well.

## Wild
- Edit the script for desired species in dex number (c.f. [Bulbapedia](https://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_index_number_(Generation_III)))
- Fill in your game version ("rs", "frlg" or [eventually] "e")
- Run the script when the player is in the grass, The bot will walk to left first

## Breeding
- Currently only supports FRLG
- Runs back and forth in front of the Daycare until an egg is ready for pickup
- Fill in your game version ("frlg" or [eventually] "e")
- With two compatible parent Pokemon in the Daycare, just stand in front of the daycare and execute the script
- If the player does not move after starting the script, you're likely in the wrong starting position.

## Unown
- Unown bot for FRLG
- Fill in your desired letters in the form of a Lua list, e.g. "local desired_letters = {'U','O'}"
- Execute the script while you're in one of the Tanoby Chambers
- Pauses the emulator when one of the desired Unown forms is encountered

## More Features
Features regarding breeding eggs are definitely coming (at least for Emerald) as soon as I need it for my current Living Dex.
If there are other features you would like to see implemented be sure to leave a request in the GitHub issues of this repo.

Also, an automated way of detecting the version is planned. You will not need to manually specify the version you're playing forever.

# Credit
- wwwwwwzx for original idea behind these bots
