state("WaveLand")
{
	byte level : 0x009F2EC0;
	double bossHp : 0x007E1A14, 0x0, 0x6B8, 0xC, 0x38, 0x8, 0x2C, 0x10, 0xC, 0x0;
	double sword : 0x007E1A14, 0x0, 0x0, 0xC, 0x38, 0x8, 0x2C, 0x10, 0x540, 0x0;
	double wraithDead : 0x007E1A14, 0x0, 0x368, 0xC, 0x38, 0x8, 0x2C, 0x10, 0x24, 0x0;
}

startup
{
	settings.Add("AutoStart", true, "Start timer when opening a new file (NOTE: Starts late on first run)");
	settings.Add("AutoReset", false, "Reset timer when exiting to the main menu");
	settings.Add("TutorialEnd", true, "Split when tutorial ends");
	settings.Add("Tutorial", false, "Split between tutorial maps", "TutorialEnd");
	settings.Add("WorldNew", false, "Split when entering a new world");
	settings.Add("LevelFirst", true, "Split when entering the first level of a world");
	settings.Add("LevelAll", false, "Split when entering any level", "LevelFirst");
	settings.Add("LevelEnd", true, "Split when exiting a level");
	settings.Add("CoinLevelStart", false, "Split when entering a coin level");
	settings.Add("CoinLevelEnd", true, "Split when exiting a coin level");
	settings.Add("NightmareStart", false, "Split when entering a nightmare");
	settings.Add("NightmareEnd", true, "Split when exiting a nightmare");
	settings.Add("Sword", false, "Split when collecting the sword");
	settings.Add("Savior", false, "Split when the wraith dies");
	settings.Add("AutoStartCustomLevel", false, "Start timer when opening a custom level");
	settings.Add("CustomLevel", false, "Split when exiting a custom level");
	settings.Add("AllRooms", false, "Split upon loading any room");
	settings.Add("AutoStartAnyFile", false, "Start timer when opening any file");
	settings.Add("CustomLevelMode", false, "Only track time in custom levels (custom level mode)");

	settings.SetToolTip("AutoStart", "For unknown reasons, the auto-start is a split-second slow on the first run after LiveSplit starts.\nTo solve this, start a run and reset it afterward.");
	settings.SetToolTip("AutoReset", "Should be used with caution. You will be responsible for any accidental exits.");
	settings.SetToolTip("TutorialEnd", "Splits when the cutscene after falling from the tutorial starts.");
	settings.SetToolTip("Tutorial", "Splits in the transition between tutorial maps.");
	settings.SetToolTip("WorldNew", "Only splits when taking the normal path, not by warping.");
	settings.SetToolTip("LevelFirst", "Splits only once, and only on the first level you select in each world.");
	settings.SetToolTip("LevelAll", "Overrides first level split, and instead splits when starting any level.");
	settings.SetToolTip("LevelEnd", "Currently splits even if you didn't get the shard.");
	settings.SetToolTip("CoinLevelStart", "Splits in the transition between hub maps and coin levels.");
	settings.SetToolTip("CoinLevelEnd", "Splits regardless of the amount of coins collected.");
	settings.SetToolTip("NightmareStart", "Splits after the white fade transition.");
	settings.SetToolTip("NightmareEnd", "Splits in the transition from a nightmare to the overworld.");
	settings.SetToolTip("Sword", "Does not split for the sword in the boss fight.");
	settings.SetToolTip("Savior", "Splits when the wraith dies by the sword or the light barrier at the end of Nightmare 3.");
	settings.SetToolTip("AllRooms", "Used for Max Rooms runs, this option will split every time the room number changes.");
	settings.SetToolTip("AutoStartAnyFile", "Used for runs where prepared save files are allowed, such as Max Rooms.");
	settings.SetToolTip("CustomLevelMode", "Used for custom level runs. The game time will only count up while in a custom level.\nNOTE: Make sure to read the speedrun leaderboard rules carefully!");

	vars.Tutorial1 = 59;
	vars.Tutorial2 = 60;
	vars.Tutorial3 = 61;
	vars.Tutorial4 = 62;
	vars.TutorialEnd = 64;

	vars.FallCS = 67;
	vars.World1 = 44;
	vars.PathWorld2 = 45;
	vars.World2 = 46;
	vars.PathWorld3 = 47;
	vars.World3 = 48;
	vars.PathWorld4 = 49;
	vars.World4 = 51;
	vars.PathWorld5 = 53;
	vars.World5 = 52;
	vars.PathWorld6 = 55;
	vars.World6 = 54;
	vars.Worlds = new int[] {vars.World1, vars.World2, vars.World3, vars.World4, vars.World5, vars.World6};

	vars.SwordCliff = 50;

	vars.Nightmare3 = 21;
	
	vars.FirstLevelWorld = new bool[6];
	vars.StartTime = 0L;

	Action<string> Debug = (text) => {
		print("[WaveLand Autosplitter] " + text);
	};
	vars.Debug = Debug;
	vars.Debug("Initialized!");
}

start
{
	if(settings["AutoStart"]
	&& old.level == 75
	&& current.level == 65)
	{
		return true;
	}
		
	if(settings["AutoStartCustomLevel"]
	&& old.level == 77
	&& current.level == 80)
	{
		return true;
	}
	
	if(settings["AutoStartAnyFile"]
	&& old.level == 75
	&& current.level != 74
	&& current.level != 75)
	{
		return true;
	}
	
	return false;
}

reset
{
	return settings["AutoReset"]
	    && old.level != current.level && current.level == 71;
}

isLoading
{
	if(settings["CustomLevelMode"] && current.level != 80)
	{
		return true;
	}

	return false;
}

update
{
	if(timer.CurrentPhase == TimerPhase.NotRunning && vars.StartTime >= 0)
	{
		vars.FirstLevelWorld = new bool[6];
		vars.StartTime = -1;
	}
	
	return true;
}

split
{
	if(settings["TutorialEnd"])
	{
		if(old.level == vars.Tutorial4 && current.level == vars.TutorialEnd)
		{
			vars.Debug("Finished tutorial.");
			return true;
		}
		
		if(settings["Tutorial"]
		&& (current.level - old.level) == 1
		&& current.level >= vars.Tutorial2 && current.level <= vars.Tutorial4)
		{
			vars.Debug("New tutorial map.");
			return true;
		}
	}

	if(settings["WorldNew"] &&
	  ((old.level == vars.FallCS     && current.level == vars.World1)
	|| (old.level == vars.PathWorld2 && current.level == vars.World2)
	|| (old.level == vars.PathWorld3 && current.level == vars.World3)
	|| (old.level == vars.PathWorld4 && current.level == vars.World4)
	|| (old.level == vars.PathWorld5 && current.level == vars.World5)
	|| (old.level == vars.PathWorld6 && current.level == vars.World6)))
	{
		vars.Debug("New world.");
		return true;
	}

	if((settings["LevelFirst"] || settings["LevelAll"])
	&& current.level >= 1 && current.level <= 41 && ((current.level - 1) % 7) <= 5)
	{
		int world = (current.level - 1) / 7;
		if(old.level == vars.Worlds[world]
		&& (!vars.FirstLevelWorld[world] || settings["LevelAll"]))
		{
			vars.Debug("Start of level.");
			vars.FirstLevelWorld[world] = true;
			return true;
		}
	}

	if(settings["LevelEnd"]
	&& old.level >= 1 && old.level <= 41 && ((old.level - 1) % 7) <= 5
	&& current.level != old.level)
	{
		vars.Debug("Level ended.");
		return true;
	}

	if(settings["CoinLevelStart"]
	&& 56 <= current.level && current.level <= 58
	&& (((old.level - 45) / 2) == (current.level - 56)))
	{
		vars.Debug("Coin level started");
		return true;
	}

	if(settings["CoinLevelEnd"]
	&& 56 <= old.level && old.level <= 58
	&& (((current.level - 45) / 2) == (old.level - 56)))
	{
		vars.Debug("Coin level ended.");
		return true;
	}

	if(settings["NightmareStart"]
	&& current.level <= 42 && current.level % 7 == 0
	&& current.level != old.level)
	{
		vars.Debug("Nightmare started.");
		return true;
	}

	if(settings["NightmareEnd"]
	&& old.level <= 42 && old.level % 7 == 0
	&& current.level != old.level
	&& current.level != 71)
	{
		vars.Debug("Nightmare ended.");
		return true;
	}

	if(settings["Sword"]
	&& current.level == vars.SwordCliff
	&& current.sword == 1
	&& old.sword == 0)
	{
		vars.Debug("Sword collected.");
		return true;
	}

	if(settings["Savior"]
	&& current.level == vars.Nightmare3
	&& current.wraithDead == 2 && old.wraithDead == 0)
	{
		vars.Debug("Wraith saved.");
		return true;
	}
	
	if(settings["CustomLevel"]
	&& old.level == 80
	&& current.level == 77)
	{
		vars.Debug("Custom level ended.");
		return true;
	}
	
	if(settings["AllRooms"]
	&& current.level != old.level
	&& current.level >= 0)
	{
		vars.Debug("New room loaded.");
		return true;
	}
	
	if(current.level == 43 && current.bossHp <= 0 && old.bossHp > 0)
	{
		return true;
	}

	return false;
}
