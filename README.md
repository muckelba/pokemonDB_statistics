# check_rocketmap
a script collection to check the spawned Pokémon, raids and quests of a local Monocle DB. Can be used with Nagios or Icinga. Supports performance-data.

## Usage:

``./check_[quests|raids|spawns] [-o <threshold value for OK>] [-w <threshold value for WARNING>] [-u <DB user>] [-p <DB password>] [-d <Database>]``
