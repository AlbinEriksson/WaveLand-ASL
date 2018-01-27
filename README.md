# WaveLand ASL 3.1.0
A LiveSplit auto splitter for [WaveLand](http://rologfos.com/) 1.2.2.

## Features
There are many options so you can customize the automatic splits to your preference:
 * Start timer
   * Note: starts late on first run after starting LiveSplit. To fix this, start and stop the timer once before doing any actual speedruns.
 * Reset timer
   * Makes it automatically reset when exiting to main menu
 * Game time
   * Uses an in-game nanosecond counter (should be accurate, somehow always syncs up to real time unless you slow down the game, need someone to confirm if game time actually makes a difference)
 * Tutorial
   * In-between tutorial maps
   * End of tutorial
 * Worlds
   * When entering a world (normal path, not warps)
 * Levels
   * Entering first level of a world
   * When entering a level
   * When exiting a level
 * Coin Levels
   * When entering a level
   * When exiting a level (does not take number of coins into account)
 * Nightmares
   * Entering
   * Exiting
 * Boss fight
   * Killing the final boss (the end of most run categories)
 * Sword
   * Collecting sword on the cliff, and not in the boss fight
 * Savior
   * When you hit the wraith with the sword

## How to install
### In LiveSplit
The easiest way to install this autosplitter is within LiveSplit itself.
 1. In "Edit Splits...", search for "WaveLand" in the games list
 2. You should see that the autosplitter is available, so click "Activate"
 3. Click "Settings" and check the options you need
### Manually
If you can't find it in LiveSplit itself, you can manually install it.
 1. Download WaveLand.asl
 2. Edit your LiveSplit layout
 3. Click the plus icon and add Control -> Scriptable Auto Splitter
 4. Browse to the ASL file
 5. Choose your options and start speedrunning!

## Missing Features
We are still trying to add more features, for improvements and other categories:
 * Checking for shards
   * To make sure to split when you actually beat a level, as opposed to if you don't get the shard but exit anyway.
 * Add Dark World splits
