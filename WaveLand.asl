state("WaveLand")
{
	byte level : 0x043584D0;
	double bossHp : 0x04623824, 0x124, 0x14, 0xBC, 0xC8, 0x8, 0x44, 0x10, 0x7C, 0x0;
}

startup
{
	settings.Add("AutoStart", true, "Start timer when opening a new file");
	settings.Add("AutoReset", false, "Reset timer when exiting to the main menu");
	settings.Add("TutorialEnd", true, "Split when tutorial ends");
	settings.Add("Tutorial", false, "Split between tutorial maps", "TutorialEnd");
	settings.Add("WorldNew", false, "Split when entering a new world");
	settings.Add("LevelFirst", true, "Split when entering the first level of a world");
	settings.Add("LevelAll", false, "Split when entering any level", "LevelFirst");
	settings.Add("LevelEnd", true, "Split when exiting a level");
	settings.Add("NightmareStart", false, "Split when entering a nightmare");
	settings.Add("NightmareEnd", true, "Split when exiting a nightmare");

	settings.SetToolTip("AutoStart", "Does not check for \"New Game\" file, but instead for the opening cutscene.");
	settings.SetToolTip("AutoReset", "Should be used with caution. You will be responsible for any accidental exits.");
	settings.SetToolTip("TutorialEnd", "Splits when the cutscene after falling from the tutorial starts.");
	settings.SetToolTip("Tutorial", "Splits in the transition between tutorial maps.");
	settings.SetToolTip("WorldNew", "Only splits when taking the normal path, not by warping.");
	settings.SetToolTip("LevelFirst", "Splits only once, and only on the first level you select in each world.");
	settings.SetToolTip("LevelAll", "Overrides first level split, and instead splits when starting any level.");
	settings.SetToolTip("LevelEnd", "Currently splits even if you didn't get the shard.");
	settings.SetToolTip("NightmareStart", "Splits after the white fade transition.");
	settings.SetToolTip("NightmareEnd", "Splits in the transition from a nightmare to the overworld.");

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
	
	vars.FirstLevelWorld = new bool[6];
	vars.Worlds = new int[] {vars.World1, vars.World2, vars.World3, vars.World4, vars.World5, vars.World6};

	Action<string> Debug = (text) => {
		print("[WaveLand Autosplitter] " + text);
	};
	vars.Debug = Debug;
	vars.Debug("Initialized!");
}

start
{
	return settings["AutoStart"]
	    && old.level == 75 && current.level == 65;
}

reset
{
	return settings["AutoReset"]
	    && old.level != current.level && current.level == 71;
}

update
{
	if(old.level != current.level && current.level == 71)
	{
		vars.FirstLevelWorld = new bool[6];
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
	&& current.level != 75)
	{
		vars.Debug("Nightmare ended.");
		return true;
	}

	if(current.level == 43 && current.bossHp <= 0 && old.bossHp > 0)
	{
		return true;
	}

	return false;
}