-- The Forgotten Server Config

	-- Account manager
	accountManager = true
	namelockManager = true
	newPlayerChooseVoc = true
	newPlayerSpawnPosX = 438
	newPlayerSpawnPosY = 503
	newPlayerSpawnPosZ = 8
	newPlayerTownId = 2
	newPlayerLevel = 8
	newPlayerMagicLevel = 0
	generateAccountNumber = false

	-- Unjustified kills
	-- NOTE: *Banishment variables are >summed up<
	-- (dailyFragsToRedSkull + dailyFragsToBanishment) with their
	-- *RedSkull equivalents.
	-- advancedFragList is not advised if you use huge frags
	-- requirements.
	redSkullLength = 30 * 24 * 60 * 60
	dailyFragsToRedSkull = 3
	weeklyFragsToRedSkull = 5
	monthlyFragsToRedSkull = 10
	dailyFragsToBanishment = dailyFragsToRedSkull
	weeklyFragsToBanishment = weeklyFragsToRedSkull
	monthlyFragsToBanishment = monthlyFragsToRedSkull
	useFragHandler = true
	advancedFragList = false

	-- Banishments
	-- violationNameReportActionType 1 = just a report, 2 = name lock, 3 = player banishment
	notationsToBan = 3
	warningsToFinalBan = 4
	warningsToDeletion = 5
	banLength = 7 * 24 * 60 * 60
	killsBanLength = 7 * 24 * 60 * 60
	finalBanLength = 30 * 24 * 60 * 60
	ipBanishmentLength = 1 * 24 * 60 * 60
	broadcastBanishments = true
	maxViolationCommentSize = 200
	violationNameReportActionType = 2
	autoBanishUnknownBytes = false

	-- Battle
	-- NOTE: showHealingDamageForMonsters inheritates from showHealingDamage.
	-- loginProtectionPeriod is the famous Tibia anti-magebomb system.
	-- deathLostPercent set to nil enables manual mode.
	worldType = "pvp"
	protectionLevel = 1
	pvpTileIgnoreLevelAndVocationProtection = true
	pzLocked = 60 * 1000
	huntingDuration = 60 * 1000
	criticalHitChance = 7
	criticalHitMultiplier = 1
	displayCriticalHitNotify = false
	removeWeaponAmmunition = true
	removeWeaponCharges = true
	removeRuneCharges = true
	whiteSkullTime = 15 * 60 * 1000
	noDamageToSameLookfeet = false
	showHealingDamage = false
	showHealingDamageForMonsters = false
	fieldOwnershipDuration = 5 * 1000
	stopAttackingAtExit = false
	oldConditionAccuracy = false
	loginProtectionPeriod = 10 * 1000
	deathLostPercent = 10
	stairhopDelay = 2 * 1000
	pushCreatureDelay = 2 * 1000
	deathContainerId = 1987
	gainExperienceColor = 215
	addManaSpentInPvPZone = true
	squareColor = 0
	allowFightback = true

	-- Connection config
	worldId = 0
	ip = "127.0.0.1"
	loginPort = 7171
	loginTries = 10
	retryTimeout = 5 * 1000
	loginTimeout = 60 * 1000
	maxPlayers = 1000
	motd = "Welcome to the Forgotten Server!"
	displayOnOrOffAtCharlist = false
	onePlayerOnlinePerAccount = true
	allowClones = false
	serverName = "Forgotten"
	loginMessage = "Welcome to the Forgotten Server!"
	statusTimeout = 5 * 60 * 1000
	replaceKickOnLogin = true
	forceSlowConnectionsToDisconnect = false
	loginOnlyWithLoginServer = false
	premiumPlayerSkipWaitList = false

	-- Database
	-- NOTE: sqlFile is used only by sqlite database, and sqlKeepAlive by mysql database.
	-- To disable sqlKeepAlive such as mysqlReadTimeout use 0 value.
	sqlType = "sqlite"
	sqlHost = "localhost"
	sqlPort = 3306
	sqlUser = "root"
	sqlPass = ""
	sqlDatabase = "theforgottenserver"
	sqlFile = "forgottenserver.s3db"
	sqlKeepAlive = 0
	mysqlReadTimeout = 10
	mysqlWriteTimeout = 10
	encryptionType = "plain"

	-- Deathlist
	deathListEnabled = true
	deathListRequiredTime = 1 * 60 * 1000
	deathAssistCount = 19
	maxDeathRecords = 5

	-- Guilds
	ingameGuildManagement = true
	levelToFormGuild = 8
	premiumDaysToFormGuild = 0
	guildNameMinLength = 4
	guildNameMaxLength = 20

	-- Highscores
	highscoreDisplayPlayers = 15
	updateHighscoresAfterMinutes = 60

	-- Houses
	buyableAndSellableHouses = true
	houseNeedPremium = true
	bedsRequirePremium = true
	levelToBuyHouse = 1
	housesPerAccount = 0
	houseRentAsPrice = false
	housePriceAsRent = false
	housePriceEachSquare = 1000
	houseRentPeriod = "never"
	houseCleanOld = 0
	guildHalls = false

	-- Item usage
	timeBetweenActions = 200
	timeBetweenExActions = 1000
	hotkeyAimbotEnabled = true

	-- Map
	-- NOTE: storeTrash costs more memory, but will perform alot faster cleaning.
	-- NOTE: do not enable randomizeTiles for now, it need to be fixed.
	mapName = "world"
	mapAuthor = "Unknow"
	randomizeTiles = false
	storeTrash = true
	cleanProtectedZones = true

	-- Mailbox
	mailboxDisabledTowns = ""
	mailMaxAttempts = 20
	mailBlockPeriod = 60 * 60 * 1000
	mailAttemptsFadeTime = 10 * 60 * 1000

	-- Process
	-- NOTE: defaultPriority works only on Windows and niceLevel on *nix
	-- coresUsed are seperated by comma cores ids used by server process,
	-- default is -1, so it stays untouched (automaticaly assigned by OS).
	defaultPriority = "high"
	niceLevel = 5
	coresUsed = "-1"

	-- Startup
	optimizeDatabaseAtStartup = true
	removePremiumOnInit = true
	confirmOutdatedVersion = false

	-- Spells
	formulaLevel = 5.0
	formulaMagic = 1.0
	bufferMutedOnSpellFailure = false
	spellNameInsteadOfWords = false
	emoteSpells = false

	-- Outfits
	allowChangeOutfit = true
	allowChangeColors = true
	allowChangeAddons = true
	disableOutfitsForPrivilegedPlayers = false
	addonsOnlyPremium = true

	-- Miscellaneous
	-- NOTE: promptExceptionTracerErrorBox works only with precompiled support feature,
	-- called "exception tracer" (__EXCEPTION_TRACER__ flag).
	dataDirectory = "data/"
	bankSystem = true
	displaySkillLevelOnAdvance = false
	promptExceptionTracerErrorBox = true
	maximumDoorLevel = 500
	maxMessageBuffer = 4
	useCapacity = true

	-- Depot
	defaultDepotSizePremium = 2000
	defaultDepotSize = 1000

	-- VIP list
	separateViplistPerCharacter = false
	vipListDefaultLimit = 20
	vipListDefaultPremiumLimit = 100

	-- Saving-related
	-- useHouseDataStorage usage may be found at README.
	saveGlobalStorage = true
	useHouseDataStorage = false
	storePlayerDirection = false

	-- Loot
	-- monsterLootMessage 0 to disable, 1 - only party, 2 - only player, 3 - party or player (like Tibia's)
	checkCorpseOwner = true
	monsterLootMessage = 3
	monsterLootMessageType = 22

	-- Ghost mode
	ghostModeInvisibleEffect = false
	ghostModeSpellEffects = true

	-- Limits
	idleWarningTime = 14 * 60 * 1000
	idleKickTime = 15 * 60 * 1000
	expireReportsAfterReads = 1
	playerQueryDeepness = 2
	maxItemsPerPZTile = 0
	maxItemsPerHouseTile = 0

	-- Premium-related
	freePremium = false
	premiumForPromotion = true

	-- Blessings
	-- NOTE: blessingReduction* regards items/containers loss.
	-- eachBlessReduction is how much each bless reduces the experience/magic/skills loss.
	blessingOnlyPremium = true
	blessingReductionBase = 30
	blessingReductionDecreament = 5
	eachBlessReduction = 8

	-- Rates
	-- NOTE: experienceStages configuration is located in data/XML/stages.xml.
	-- rateExperienceFromPlayers 0 to disable.
	experienceStages = false
	rateExperience = 5.0
	rateExperienceFromPlayers = 0
	rateSkill = 3.0
	rateMagic = 3.0
	rateLoot = 2.0
	rateSpawn = 1

	-- Monster rates
	rateMonsterHealth = 1.0
	rateMonsterMana = 1.0
	rateMonsterAttack = 1.0
	rateMonsterDefense = 1.0

	-- Experience from players
	-- NOTE: min~Threshold* set to 0 will disable the minimum threshold:
	-- player will gain experience from every lower leveled player.
	-- max~Threshold* set to 0 will disable the maximum threshold:
	-- player will gain experience from every higher leveled player.
	minLevelThresholdForKilledPlayer = 0.9
	maxLevelThresholdForKilledPlayer = 1.1

	-- Stamina
	-- NOTE: Stamina is stored in miliseconds, so seconds are multiplied by 1000.
	-- rateStaminaHits multiplies every hit done a creature, which are later
	-- multiplied by player attack speed.
	-- rateStaminaGain is divider of every logged out second, eg:
	-- 60000 / 3 = 20000 milliseconds, what gives 20 stamina seconds for 1 minute being logged off.
	-- rateStaminaThresholdGain is divider for the premium stamina.
	-- staminaRatingLimit* is in minutes.
	rateStaminaLoss = 1
	rateStaminaGain = 3
	rateStaminaThresholdGain = 12
	staminaRatingLimitTop = 42 * 60
	staminaRatingLimitBottom = 14 * 60
	rateStaminaAboveNormal = 1.5
	rateStaminaUnderNormal = 0.5
	staminaThresholdOnlyPremium = true

	-- Party
	-- NOTE: experienceShareLevelDifference is float number.
	-- experienceShareLevelDifference is highestLevel * value
	experienceShareRadiusX = 30
	experienceShareRadiusY = 30
	experienceShareRadiusZ = 1
	experienceShareLevelDifference = 2 / 3
	extraPartyExperienceLimit = 20
	extraPartyExperiencePercent = 5
	experienceShareActivity = 2 * 60 * 1000

	-- Global save
	-- NOTE: globalSaveHour means like 03:00, not that it will save every 3 hours,
	-- if you want such a system please check out data/globalevents/globalevents.xml.
	globalSaveEnabled = false
	globalSaveHour = 8
	shutdownAtGlobalSave = true
	cleanMapAtGlobalSave = false

	-- Spawns
	deSpawnRange = 2
	deSpawnRadius = 50
	monsterSpawnWalkback = true

	-- Summons
	maxPlayerSummons = 2
	teleportAllSummons = false
	teleportPlayerSummons = false

	-- Status
	ownerName = ""
	ownerEmail = "@otland.net"
	url = "http://otland.net/"
	location = "Europe"
	displayGamemastersWithOnlineCommand = false

	-- Logs
	-- NOTE: This kind of logging does not work in GUI version.
	-- For such, please compile the software with __GUI_LOGS__ flag.
	adminLogsEnabled = false
	displayPlayersLogging = true
	prefixChannelLogs = ""
	runFile = ""
	outputLog = ""
	truncateLogOnStartup = false
