local roblox_enums = {
	["AccessModifierType"] = {
		{ Name = "Allow", Value = 0 },
		{ Name = "Deny", Value = 1 },
	},
	["AccessoryType"] = {
		{ Name = "Unknown", Value = 0 },
		{ Name = "Hat", Value = 1 },
		{ Name = "Hair", Value = 2 },
		{ Name = "Face", Value = 3 },
		{ Name = "Neck", Value = 4 },
		{ Name = "Shoulder", Value = 5 },
		{ Name = "Front", Value = 6 },
		{ Name = "Back", Value = 7 },
		{ Name = "Waist", Value = 8 },
		{ Name = "TShirt", Value = 9 },
		{ Name = "Shirt", Value = 10 },
		{ Name = "Pants", Value = 11 },
		{ Name = "Jacket", Value = 12 },
		{ Name = "Sweater", Value = 13 },
		{ Name = "Shorts", Value = 14 },
		{ Name = "LeftShoe", Value = 15 },
		{ Name = "RightShoe", Value = 16 },
		{ Name = "DressSkirt", Value = 17 },
		{ Name = "Eyebrow", Value = 18 },
		{ Name = "Eyelash", Value = 19 },
	},
	["ActionOnAutoResumeSync"] = {
		{ Name = "DontResume", Value = 0 },
		{ Name = "KeepStudio", Value = 1 },
		{ Name = "KeepLocal", Value = 2 },
	},
	["ActionOnStopSync"] = {
		{ Name = "AlwaysAsk", Value = 0 },
		{ Name = "KeepLocalFiles", Value = 1 },
		{ Name = "DeleteLocalFiles", Value = 2 },
	},
	["ActionType"] = {
		{ Name = "Nothing", Value = 0 },
		{ Name = "Pause", Value = 1 },
		{ Name = "Lose", Value = 2 },
		{ Name = "Draw", Value = 3 },
		{ Name = "Win", Value = 4 },
	},
	["ActuatorRelativeTo"] = {
		{ Name = "Attachment0", Value = 0 },
		{ Name = "Attachment1", Value = 1 },
		{ Name = "World", Value = 2 },
	},
	["ActuatorType"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Motor", Value = 1 },
		{ Name = "Servo", Value = 2 },
	},
	["AdAvailabilityResult"] = {
		{ Name = "IsAvailable", Value = 1 },
		{ Name = "DeviceIneligible", Value = 2 },
		{ Name = "ExperienceIneligible", Value = 3 },
		{ Name = "InternalError", Value = 4 },
		{ Name = "NoFill", Value = 5 },
		{ Name = "PlayerIneligible", Value = 6 },
		{ Name = "PublisherIneligible", Value = 7 },
	},
	["AdEventType"] = {
		{ Name = "VideoLoaded", Value = 0 },
		{ Name = "VideoRemoved", Value = 1 },
		{ Name = "UserCompletedVideo", Value = 2 },
		{ Name = "RewardedAdLoaded", Value = 3 },
		{ Name = "RewardedAdGrant", Value = 4 },
		{ Name = "RewardedAdUnloaded", Value = 5 },
	},
	["AdFormat"] = {
		{ Name = "RewardedVideo", Value = 0 },
	},
	["AdShape"] = {
		{ Name = "HorizontalRectangle", Value = 1 },
	},
	["AdTeleportMethod"] = {
		{ Name = "Undefined", Value = 0 },
		{ Name = "PortalForward", Value = 1 },
		{ Name = "InGameMenuBackButton", Value = 2 },
		{ Name = "UIBackButton", Value = 3 },
	},
	["AdUIEventType"] = {
		{ Name = "AdLabelClicked", Value = 0 },
		{ Name = "VolumeButtonClicked", Value = 1 },
		{ Name = "FullscreenButtonClicked", Value = 2 },
		{ Name = "PlayButtonClicked", Value = 3 },
		{ Name = "PauseButtonClicked", Value = 4 },
		{ Name = "CloseButtonClicked", Value = 5 },
		{ Name = "WhyThisAdClicked", Value = 6 },
		{ Name = "PlayEventTriggered", Value = 7 },
		{ Name = "PauseEventTriggered", Value = 8 },
	},
	["AdUIType"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Image", Value = 1 },
		{ Name = "Video", Value = 2 },
	},
	["AdUnitStatus"] = {
		{ Name = "Inactive", Value = 0 },
		{ Name = "Active", Value = 1 },
	},
	["AdornCullingMode"] = {
		{ Name = "Automatic", Value = 0 },
		{ Name = "Never", Value = 1 },
	},
	["AdornShading"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Shaded", Value = 1 },
		{ Name = "XRay", Value = 2 },
		{ Name = "XRayShaded", Value = 3 },
		{ Name = "AlwaysOnTop", Value = 4 },
	},
	["AlignType"] = {
		{ Name = "Parallel", Value = 0 },
		{ Name = "Perpendicular", Value = 1 },
		{ Name = "PrimaryAxisParallel", Value = 2 },
		{ Name = "PrimaryAxisPerpendicular", Value = 3 },
		{ Name = "PrimaryAxisLookAt", Value = 4 },
		{ Name = "AllAxes", Value = 5 },
	},
	["AlphaMode"] = {
		{ Name = "Overlay", Value = 0 },
		{ Name = "Transparency", Value = 1 },
		{ Name = "TintMask", Value = 2 },
		{ Name = "Opaque", Value = 3 },
	},
	["AnalyticsCustomFieldKeys"] = {
		{ Name = "CustomField01", Value = 0 },
		{ Name = "CustomField02", Value = 1 },
		{ Name = "CustomField03", Value = 2 },
	},
	["AnalyticsEconomyAction"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Acquire", Value = 1 },
		{ Name = "Spend", Value = 2 },
	},
	["AnalyticsEconomyFlowType"] = {
		{ Name = "Sink", Value = 0 },
		{ Name = "Source", Value = 1 },
	},
	["AnalyticsEconomyTransactionType"] = {
		{ Name = "IAP", Value = 0 },
		{ Name = "Shop", Value = 1 },
		{ Name = "Gameplay", Value = 2 },
		{ Name = "ContextualPurchase", Value = 3 },
		{ Name = "TimedReward", Value = 4 },
		{ Name = "Onboarding", Value = 5 },
	},
	["AnalyticsLogLevel"] = {
		{ Name = "Trace", Value = 0 },
		{ Name = "Debug", Value = 1 },
		{ Name = "Information", Value = 2 },
		{ Name = "Warning", Value = 3 },
		{ Name = "Error", Value = 4 },
		{ Name = "Fatal", Value = 5 },
	},
	["AnalyticsProgressionStatus"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Begin", Value = 1 },
		{ Name = "Complete", Value = 2 },
		{ Name = "Abandon", Value = 3 },
		{ Name = "Fail", Value = 4 },
	},
	["AnalyticsProgressionType"] = {
		{ Name = "Custom", Value = 0 },
		{ Name = "Start", Value = 1 },
		{ Name = "Fail", Value = 2 },
		{ Name = "Complete", Value = 3 },
	},
	["AnimationClipFromVideoStatus"] = {
		{ Name = "Initializing", Value = 0 },
		{ Name = "Pending", Value = 1 },
		{ Name = "Processing", Value = 2 },
		{ Name = "ErrorGeneric", Value = 4 },
		{ Name = "Success", Value = 6 },
		{ Name = "ErrorVideoTooLong", Value = 7 },
		{ Name = "ErrorNoPersonDetected", Value = 8 },
		{ Name = "ErrorVideoUnstable", Value = 9 },
		{ Name = "Timeout", Value = 10 },
		{ Name = "Cancelled", Value = 11 },
		{ Name = "ErrorMultiplePeople", Value = 12 },
		{ Name = "ErrorUploadingVideo", Value = 2001 },
	},
	["AnimationNodeBlend2DInputMode"] = {
		{ Name = "Cartesian", Value = 0 },
		{ Name = "Polar", Value = 1 },
	},
	["AnimationNodeInterruptible"] = {
		{ Name = "Always", Value = 0 },
		{ Name = "Finished", Value = 1 },
		{ Name = "Trigger", Value = 2 },
	},
	["AnimationNodePlayMode"] = {
		{ Name = "Loop", Value = 0 },
		{ Name = "PingPong", Value = 1 },
		{ Name = "OnceAndHold", Value = 2 },
		{ Name = "OnceAndReset", Value = 3 },
	},
	["AnimationNodeTransitionType"] = {
		{ Name = "CrossFade", Value = 0 },
		{ Name = "InertialBlend", Value = 1 },
		{ Name = "DeadBlend", Value = 2 },
	},
	["AnimationNodeType"] = {
		{ Name = "InvalidNode", Value = 0 },
		{ Name = "AddNode", Value = 1 },
		{ Name = "BlendNode", Value = 2 },
		{ Name = "Blend1DNode", Value = 3 },
		{ Name = "Blend2DNode", Value = 4 },
		{ Name = "ClipNode", Value = 5 },
		{ Name = "GraphOutput", Value = 6 },
		{ Name = "MaskNode", Value = 7 },
		{ Name = "PrioritySelectNode", Value = 8 },
		{ Name = "RandomSequenceNode", Value = 9 },
		{ Name = "SelectNode", Value = 10 },
		{ Name = "SequenceNode", Value = 11 },
		{ Name = "SpeedNode", Value = 12 },
		{ Name = "SubtractNode", Value = 13 },
	},
	["AnimationNodeWaitFor"] = {
		{ Name = "Finished", Value = 0 },
		{ Name = "Trigger", Value = 1 },
	},
	["AnimationPriority"] = {
		{ Name = "Idle", Value = 0 },
		{ Name = "Movement", Value = 1 },
		{ Name = "Action", Value = 2 },
		{ Name = "Action2", Value = 3 },
		{ Name = "Action3", Value = 4 },
		{ Name = "Action4", Value = 5 },
		{ Name = "Core", Value = 1000 },
	},
	["AnimatorRetargetingMode"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Disabled", Value = 1 },
		{ Name = "Enabled", Value = 2 },
	},
	["AnnotationChannelContentPreference"] = {
		{ Name = "None", Value = 0 },
		{ Name = "All", Value = 1 },
		{ Name = "Unknown", Value = 2 },
	},
	["AnnotationEditingMode"] = {
		{ Name = "None", Value = 0 },
		{ Name = "PlacingNew", Value = 1 },
		{ Name = "WritingNew", Value = 2 },
	},
	["AnnotationPlaceContentPreference"] = {
		{ Name = "None", Value = 0 },
		{ Name = "All", Value = 1 },
		{ Name = "MentionsAndReplies", Value = 2 },
		{ Name = "Unknown", Value = 3 },
	},
	["AnnotationRequestStatus"] = {
		{ Name = "Success", Value = 0 },
		{ Name = "Loading", Value = 1 },
		{ Name = "ErrorInternalFailure", Value = 2 },
		{ Name = "ErrorNotFound", Value = 3 },
		{ Name = "ErrorModerated", Value = 4 },
	},
	["AnnotationRequestType"] = {
		{ Name = "Unknown", Value = 0 },
		{ Name = "Create", Value = 1 },
		{ Name = "Resolve", Value = 2 },
		{ Name = "Delete", Value = 3 },
		{ Name = "Edit", Value = 4 },
	},
	["AppLifecycleManagerState"] = {
		{ Name = "Detached", Value = 0 },
		{ Name = "Active", Value = 1 },
		{ Name = "Inactive", Value = 2 },
		{ Name = "Hidden", Value = 3 },
	},
	["AppShellActionType"] = {
		{ Name = "None", Value = 0 },
		{ Name = "OpenApp", Value = 1 },
		{ Name = "TapChatTab", Value = 2 },
		{ Name = "TapConversationEntry", Value = 3 },
		{ Name = "TapAvatarTab", Value = 4 },
		{ Name = "ReadConversation", Value = 5 },
		{ Name = "TapGamePageTab", Value = 6 },
		{ Name = "TapHomePageTab", Value = 7 },
		{ Name = "GamePageLoaded", Value = 8 },
		{ Name = "HomePageLoaded", Value = 9 },
		{ Name = "AvatarEditorPageLoaded", Value = 10 },
	},
	["AppShellFeature"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Chat", Value = 1 },
		{ Name = "AvatarEditor", Value = 2 },
		{ Name = "GamePage", Value = 3 },
		{ Name = "HomePage", Value = 4 },
		{ Name = "More", Value = 5 },
		{ Name = "Landing", Value = 6 },
	},
	["AppUpdateStatus"] = {
		{ Name = "Unknown", Value = 0 },
		{ Name = "NotSupported", Value = 1 },
		{ Name = "Failed", Value = 2 },
		{ Name = "NotAvailable", Value = 3 },
		{ Name = "Available", Value = 4 },
		{ Name = "AvailableBoundChannel", Value = 5 },
		{ Name = "AvailableBetaProgram", Value = 6 },
	},
	["ApplyStrokeMode"] = {
		{ Name = "Contextual", Value = 0 },
		{ Name = "Border", Value = 1 },
	},
	["AspectType"] = {
		{ Name = "FitWithinMaxSize", Value = 0 },
		{ Name = "ScaleWithParentSize", Value = 1 },
	},
	["AssetCreatorType"] = {
		{ Name = "User", Value = 0 },
		{ Name = "Group", Value = 1 },
	},
	["AssetFetchStatus"] = {
		{ Name = "Success", Value = 0 },
		{ Name = "Failure", Value = 1 },
		{ Name = "None", Value = 2 },
		{ Name = "Loading", Value = 3 },
		{ Name = "TimedOut", Value = 4 },
	},
	["AssetType"] = {
		{ Name = "Image", Value = 1 },
		{ Name = "TShirt", Value = 2 },
		{ Name = "Audio", Value = 3 },
		{ Name = "Mesh", Value = 4 },
		{ Name = "Lua", Value = 5 },
		{ Name = "Hat", Value = 8 },
		{ Name = "Place", Value = 9 },
		{ Name = "Model", Value = 10 },
		{ Name = "Shirt", Value = 11 },
		{ Name = "Pants", Value = 12 },
		{ Name = "Decal", Value = 13 },
		{ Name = "Head", Value = 17 },
		{ Name = "Face", Value = 18 },
		{ Name = "Gear", Value = 19 },
		{ Name = "Badge", Value = 21 },
		{ Name = "Animation", Value = 24 },
		{ Name = "Torso", Value = 27 },
		{ Name = "RightArm", Value = 28 },
		{ Name = "LeftArm", Value = 29 },
		{ Name = "LeftLeg", Value = 30 },
		{ Name = "RightLeg", Value = 31 },
		{ Name = "Package", Value = 32 },
		{ Name = "GamePass", Value = 34 },
		{ Name = "Plugin", Value = 38 },
		{ Name = "MeshPart", Value = 40 },
		{ Name = "HairAccessory", Value = 41 },
		{ Name = "FaceAccessory", Value = 42 },
		{ Name = "NeckAccessory", Value = 43 },
		{ Name = "ShoulderAccessory", Value = 44 },
		{ Name = "FrontAccessory", Value = 45 },
		{ Name = "BackAccessory", Value = 46 },
		{ Name = "WaistAccessory", Value = 47 },
		{ Name = "ClimbAnimation", Value = 48 },
		{ Name = "DeathAnimation", Value = 49 },
		{ Name = "FallAnimation", Value = 50 },
		{ Name = "IdleAnimation", Value = 51 },
		{ Name = "JumpAnimation", Value = 52 },
		{ Name = "RunAnimation", Value = 53 },
		{ Name = "SwimAnimation", Value = 54 },
		{ Name = "WalkAnimation", Value = 55 },
		{ Name = "PoseAnimation", Value = 56 },
		{ Name = "EarAccessory", Value = 57 },
		{ Name = "EyeAccessory", Value = 58 },
		{ Name = "EmoteAnimation", Value = 61 },
		{ Name = "Video", Value = 62 },
		{ Name = "TShirtAccessory", Value = 64 },
		{ Name = "ShirtAccessory", Value = 65 },
		{ Name = "PantsAccessory", Value = 66 },
		{ Name = "JacketAccessory", Value = 67 },
		{ Name = "SweaterAccessory", Value = 68 },
		{ Name = "ShortsAccessory", Value = 69 },
		{ Name = "LeftShoeAccessory", Value = 70 },
		{ Name = "RightShoeAccessory", Value = 71 },
		{ Name = "DressSkirtAccessory", Value = 72 },
		{ Name = "FontFamily", Value = 73 },
		{ Name = "EyebrowAccessory", Value = 76 },
		{ Name = "EyelashAccessory", Value = 77 },
		{ Name = "MoodAnimation", Value = 78 },
		{ Name = "DynamicHead", Value = 79 },
		{ Name = "FaceMakeup", Value = 88 },
		{ Name = "LipMakeup", Value = 89 },
		{ Name = "EyeMakeup", Value = 90 },
	},
	["AssetTypeVerification"] = {
		{ Name = "Default", Value = 1 },
		{ Name = "ClientOnly", Value = 2 },
		{ Name = "Always", Value = 3 },
	},
	["AudioApiRollout"] = {
		{ Name = "Disabled", Value = 0 },
		{ Name = "Automatic", Value = 1 },
		{ Name = "Enabled", Value = 2 },
	},
	["AudioCaptureMode"] = {
	},
	["AudioChannelLayout"] = {
		{ Name = "Mono", Value = 0 },
		{ Name = "Stereo", Value = 1 },
		{ Name = "Quad", Value = 2 },
		{ Name = "Surround_5", Value = 3 },
		{ Name = "Surround_5_1", Value = 4 },
		{ Name = "Surround_7_1", Value = 5 },
		{ Name = "Surround_7_1_4", Value = 6 },
	},
	["AudioFilterType"] = {
		{ Name = "Peak", Value = 0 },
		{ Name = "LowShelf", Value = 1 },
		{ Name = "HighShelf", Value = 2 },
		{ Name = "Lowpass12dB", Value = 3 },
		{ Name = "Lowpass24dB", Value = 4 },
		{ Name = "Lowpass48dB", Value = 5 },
		{ Name = "Highpass12dB", Value = 6 },
		{ Name = "Highpass24dB", Value = 7 },
		{ Name = "Highpass48dB", Value = 8 },
		{ Name = "Bandpass", Value = 9 },
		{ Name = "Notch", Value = 10 },
		{ Name = "Lowpass6dB", Value = 11 },
	},
	["AudioSimulationFidelity"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Automatic", Value = 1 },
	},
	["AudioSubType"] = {
		{ Name = "Music", Value = 1 },
		{ Name = "SoundEffect", Value = 2 },
	},
	["AudioWindowSize"] = {
		{ Name = "Small", Value = 0 },
		{ Name = "Medium", Value = 1 },
		{ Name = "Large", Value = 2 },
	},
	["AuthorityMode"] = {
		{ Name = "Server", Value = 0 },
		{ Name = "Automatic", Value = 1 },
	},
	["AutoIndentRule"] = {
		{ Name = "Off", Value = 0 },
		{ Name = "Absolute", Value = 1 },
		{ Name = "Relative", Value = 2 },
	},
	["AutomaticSize"] = {
		{ Name = "None", Value = 0 },
		{ Name = "X", Value = 1 },
		{ Name = "Y", Value = 2 },
		{ Name = "XY", Value = 3 },
	},
	["AvatarAssetType"] = {
		{ Name = "TShirt", Value = 2 },
		{ Name = "Hat", Value = 8 },
		{ Name = "Shirt", Value = 11 },
		{ Name = "Pants", Value = 12 },
		{ Name = "Head", Value = 17 },
		{ Name = "Face", Value = 18 },
		{ Name = "Gear", Value = 19 },
		{ Name = "Torso", Value = 27 },
		{ Name = "RightArm", Value = 28 },
		{ Name = "LeftArm", Value = 29 },
		{ Name = "LeftLeg", Value = 30 },
		{ Name = "RightLeg", Value = 31 },
		{ Name = "HairAccessory", Value = 41 },
		{ Name = "FaceAccessory", Value = 42 },
		{ Name = "NeckAccessory", Value = 43 },
		{ Name = "ShoulderAccessory", Value = 44 },
		{ Name = "FrontAccessory", Value = 45 },
		{ Name = "BackAccessory", Value = 46 },
		{ Name = "WaistAccessory", Value = 47 },
		{ Name = "ClimbAnimation", Value = 48 },
		{ Name = "FallAnimation", Value = 50 },
		{ Name = "IdleAnimation", Value = 51 },
		{ Name = "JumpAnimation", Value = 52 },
		{ Name = "RunAnimation", Value = 53 },
		{ Name = "SwimAnimation", Value = 54 },
		{ Name = "WalkAnimation", Value = 55 },
		{ Name = "EmoteAnimation", Value = 61 },
		{ Name = "TShirtAccessory", Value = 64 },
		{ Name = "ShirtAccessory", Value = 65 },
		{ Name = "PantsAccessory", Value = 66 },
		{ Name = "JacketAccessory", Value = 67 },
		{ Name = "SweaterAccessory", Value = 68 },
		{ Name = "ShortsAccessory", Value = 69 },
		{ Name = "LeftShoeAccessory", Value = 70 },
		{ Name = "RightShoeAccessory", Value = 71 },
		{ Name = "DressSkirtAccessory", Value = 72 },
		{ Name = "EyebrowAccessory", Value = 76 },
		{ Name = "EyelashAccessory", Value = 77 },
		{ Name = "MoodAnimation", Value = 78 },
		{ Name = "DynamicHead", Value = 79 },
		{ Name = "FaceMakeup", Value = 88 },
		{ Name = "LipMakeup", Value = 89 },
		{ Name = "EyeMakeup", Value = 90 },
	},
	["AvatarChatServiceFeature"] = {
		{ Name = "None", Value = 0 },
		{ Name = "UniverseAudio", Value = 1 },
		{ Name = "UniverseVideo", Value = 2 },
		{ Name = "PlaceAudio", Value = 4 },
		{ Name = "PlaceVideo", Value = 8 },
		{ Name = "UserAudioEligible", Value = 16 },
		{ Name = "UserAudio", Value = 32 },
		{ Name = "UserVideoEligible", Value = 64 },
		{ Name = "UserVideo", Value = 128 },
		{ Name = "UserBanned", Value = 256 },
		{ Name = "UserVerifiedForVoice", Value = 512 },
	},
	["AvatarContextMenuOption"] = {
		{ Name = "Friend", Value = 0 },
		{ Name = "Chat", Value = 1 },
		{ Name = "Emote", Value = 2 },
		{ Name = "InspectMenu", Value = 3 },
	},
	["AvatarGenerationError"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Unknown", Value = 1 },
		{ Name = "DownloadFailed", Value = 2 },
		{ Name = "Canceled", Value = 3 },
		{ Name = "Offensive", Value = 4 },
		{ Name = "Timeout", Value = 5 },
		{ Name = "JobNotFound", Value = 6 },
	},
	["AvatarItemType"] = {
		{ Name = "Asset", Value = 1 },
		{ Name = "Bundle", Value = 2 },
	},
	["AvatarPromptResult"] = {
		{ Name = "Success", Value = 1 },
		{ Name = "PermissionDenied", Value = 2 },
		{ Name = "Failed", Value = 3 },
	},
	["AvatarSettingsAccessoryLimitMethod"] = {
		{ Name = "Scale", Value = 0 },
		{ Name = "Remove", Value = 1 },
		{ Name = "PreviewScale", Value = 2 },
		{ Name = "PreviewRemove", Value = 3 },
	},
	["AvatarSettingsAccessoryMode"] = {
		{ Name = "PlayerChoice", Value = 0 },
		{ Name = "CustomLimit", Value = 1 },
	},
	["AvatarSettingsAnimationClipsMode"] = {
		{ Name = "PlayerChoice", Value = 0 },
		{ Name = "CustomClips", Value = 1 },
	},
	["AvatarSettingsAnimationPacksMode"] = {
		{ Name = "PlayerChoice", Value = 0 },
		{ Name = "StandardR15", Value = 1 },
		{ Name = "StandardR6", Value = 2 },
	},
	["AvatarSettingsAppearanceMode"] = {
		{ Name = "PlayerChoice", Value = 0 },
		{ Name = "CustomParts", Value = 1 },
		{ Name = "CustomBody", Value = 2 },
	},
	["AvatarSettingsBuildMode"] = {
		{ Name = "PlayerChoice", Value = 0 },
		{ Name = "CustomBuild", Value = 1 },
	},
	["AvatarSettingsClothingMode"] = {
		{ Name = "PlayerChoice", Value = 0 },
		{ Name = "CustomLimit", Value = 1 },
	},
	["AvatarSettingsCollisionMode"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "SingleCollider", Value = 1 },
		{ Name = "Legacy", Value = 2 },
	},
	["AvatarSettingsCustomAccessoryMode"] = {
		{ Name = "PlayerChoice", Value = 0 },
		{ Name = "CustomAccessories", Value = 1 },
	},
	["AvatarSettingsCustomBodyType"] = {
		{ Name = "AvatarReference", Value = 0 },
		{ Name = "BundleId", Value = 1 },
	},
	["AvatarSettingsCustomClothingMode"] = {
		{ Name = "PlayerChoice", Value = 0 },
		{ Name = "CustomClothing", Value = 1 },
	},
	["AvatarSettingsHitAndTouchDetectionMode"] = {
		{ Name = "UseParts", Value = 0 },
		{ Name = "UseCollider", Value = 1 },
	},
	["AvatarSettingsJumpMode"] = {
		{ Name = "JumpHeight", Value = 0 },
		{ Name = "JumpPower", Value = 1 },
	},
	["AvatarSettingsLegacyCollisionMode"] = {
		{ Name = "R6Colliders", Value = 0 },
		{ Name = "InnerBoxColliders", Value = 1 },
	},
	["AvatarSettingsScaleMode"] = {
		{ Name = "PlayerChoice", Value = 0 },
		{ Name = "CustomScale", Value = 1 },
	},
	["AvatarThumbnailCustomizationType"] = {
		{ Name = "Closeup", Value = 1 },
		{ Name = "FullBody", Value = 2 },
	},
	["AvatarUnificationMode"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Disabled", Value = 1 },
		{ Name = "Enabled", Value = 2 },
	},
	["Axis"] = {
		{ Name = "X", Value = 0 },
		{ Name = "Y", Value = 1 },
		{ Name = "Z", Value = 2 },
	},
	["BenefitType"] = {
		{ Name = "DeveloperProduct", Value = 0 },
		{ Name = "AvatarAsset", Value = 1 },
		{ Name = "AvatarBundle", Value = 2 },
	},
	["BinType"] = {
		{ Name = "Script", Value = 0 },
		{ Name = "GameTool", Value = 1 },
		{ Name = "Grab", Value = 2 },
		{ Name = "Clone", Value = 3 },
		{ Name = "Hammer", Value = 4 },
	},
	["BodyPart"] = {
		{ Name = "Head", Value = 0 },
		{ Name = "Torso", Value = 1 },
		{ Name = "LeftArm", Value = 2 },
		{ Name = "RightArm", Value = 3 },
		{ Name = "LeftLeg", Value = 4 },
		{ Name = "RightLeg", Value = 5 },
	},
	["BodyPartR15"] = {
		{ Name = "Head", Value = 0 },
		{ Name = "UpperTorso", Value = 1 },
		{ Name = "LowerTorso", Value = 2 },
		{ Name = "LeftFoot", Value = 3 },
		{ Name = "LeftLowerLeg", Value = 4 },
		{ Name = "LeftUpperLeg", Value = 5 },
		{ Name = "RightFoot", Value = 6 },
		{ Name = "RightLowerLeg", Value = 7 },
		{ Name = "RightUpperLeg", Value = 8 },
		{ Name = "LeftHand", Value = 9 },
		{ Name = "LeftLowerArm", Value = 10 },
		{ Name = "LeftUpperArm", Value = 11 },
		{ Name = "RightHand", Value = 12 },
		{ Name = "RightLowerArm", Value = 13 },
		{ Name = "RightUpperArm", Value = 14 },
		{ Name = "RootPart", Value = 15 },
		{ Name = "Unknown", Value = 17 },
	},
	["BorderMode"] = {
		{ Name = "Outline", Value = 0 },
		{ Name = "Middle", Value = 1 },
		{ Name = "Inset", Value = 2 },
	},
	["BorderStrokePosition"] = {
		{ Name = "Outer", Value = 0 },
		{ Name = "Center", Value = 1 },
		{ Name = "Inner", Value = 2 },
	},
	["BreakReason"] = {
		{ Name = "Other", Value = 0 },
		{ Name = "Error", Value = 1 },
		{ Name = "SpecialBreakpoint", Value = 2 },
		{ Name = "UserBreakpoint", Value = 3 },
	},
	["BreakpointRemoveReason"] = {
		{ Name = "Requested", Value = 0 },
		{ Name = "ScriptChanged", Value = 1 },
		{ Name = "ScriptRemoved", Value = 2 },
	},
	["BulkMoveMode"] = {
		{ Name = "FireAllEvents", Value = 0 },
		{ Name = "FireCFrameChanged", Value = 1 },
	},
	["BundleType"] = {
		{ Name = "BodyParts", Value = 1 },
		{ Name = "Animations", Value = 2 },
		{ Name = "Shoes", Value = 3 },
		{ Name = "DynamicHead", Value = 4 },
		{ Name = "DynamicHeadAvatar", Value = 5 },
	},
	["Button"] = {
		{ Name = "Dismount", Value = 8 },
		{ Name = "Jump", Value = 32 },
	},
	["ButtonStyle"] = {
		{ Name = "Custom", Value = 0 },
		{ Name = "RobloxButtonDefault", Value = 1 },
		{ Name = "RobloxButton", Value = 2 },
		{ Name = "RobloxRoundButton", Value = 3 },
		{ Name = "RobloxRoundDefaultButton", Value = 4 },
		{ Name = "RobloxRoundDropdownButton", Value = 5 },
	},
	["CageType"] = {
		{ Name = "Inner", Value = 0 },
		{ Name = "Outer", Value = 1 },
	},
	["CameraMode"] = {
		{ Name = "Classic", Value = 0 },
		{ Name = "LockFirstPerson", Value = 1 },
	},
	["CameraNavigationModel"] = {
		{ Name = "Roblox", Value = 0 },
		{ Name = "IndustryCompatible", Value = 1 },
	},
	["CameraPanMode"] = {
		{ Name = "Classic", Value = 0 },
		{ Name = "EdgeBump", Value = 1 },
	},
	["CameraSpeedAdjustBinding"] = {
		{ Name = "None", Value = 0 },
		{ Name = "RmbScroll", Value = 1 },
		{ Name = "AltScroll", Value = 2 },
	},
	["CameraType"] = {
		{ Name = "Fixed", Value = 0 },
		{ Name = "Attach", Value = 1 },
		{ Name = "Watch", Value = 2 },
		{ Name = "Track", Value = 3 },
		{ Name = "Follow", Value = 4 },
		{ Name = "Custom", Value = 5 },
		{ Name = "Scriptable", Value = 6 },
		{ Name = "Orbital", Value = 7 },
	},
	["CanCollaborateError"] = {
		{ Name = "Invalid", Value = 0 },
		{ Name = "None", Value = 1 },
		{ Name = "NotAgeVerified", Value = 2 },
		{ Name = "OutsideAgeBucket", Value = 3 },
		{ Name = "TooManyCollaborators", Value = 4 },
		{ Name = "PCBlock", Value = 5 },
		{ Name = "NotFound", Value = 6 },
		{ Name = "OutsideOwnerAgeBucket", Value = 7 },
	},
	["CaptureGalleryPermission"] = {
		{ Name = "ReadAndUpload", Value = 0 },
	},
	["CaptureType"] = {
		{ Name = "Screenshot", Value = 1 },
		{ Name = "Video", Value = 2 },
	},
	["CatalogCategoryFilter"] = {
		{ Name = "None", Value = 1 },
		{ Name = "Featured", Value = 2 },
		{ Name = "Collectibles", Value = 3 },
		{ Name = "CommunityCreations", Value = 4 },
		{ Name = "Premium", Value = 5 },
		{ Name = "Recommended", Value = 6 },
	},
	["CatalogSortAggregation"] = {
		{ Name = "Past12Hours", Value = 1 },
		{ Name = "PastDay", Value = 2 },
		{ Name = "Past3Days", Value = 3 },
		{ Name = "PastWeek", Value = 4 },
		{ Name = "PastMonth", Value = 5 },
		{ Name = "AllTime", Value = 6 },
	},
	["CatalogSortType"] = {
		{ Name = "Relevance", Value = 1 },
		{ Name = "PriceHighToLow", Value = 2 },
		{ Name = "PriceLowToHigh", Value = 3 },
		{ Name = "MostFavorited", Value = 5 },
		{ Name = "RecentlyCreated", Value = 6 },
		{ Name = "Bestselling", Value = 7 },
	},
	["CellBlock"] = {
		{ Name = "Solid", Value = 0 },
		{ Name = "VerticalWedge", Value = 1 },
		{ Name = "CornerWedge", Value = 2 },
		{ Name = "InverseCornerWedge", Value = 3 },
		{ Name = "HorizontalWedge", Value = 4 },
	},
	["CellMaterial"] = {
		{ Name = "Empty", Value = 0 },
		{ Name = "Grass", Value = 1 },
		{ Name = "Sand", Value = 2 },
		{ Name = "Brick", Value = 3 },
		{ Name = "Granite", Value = 4 },
		{ Name = "Asphalt", Value = 5 },
		{ Name = "Iron", Value = 6 },
		{ Name = "Aluminum", Value = 7 },
		{ Name = "Gold", Value = 8 },
		{ Name = "WoodPlank", Value = 9 },
		{ Name = "WoodLog", Value = 10 },
		{ Name = "Gravel", Value = 11 },
		{ Name = "CinderBlock", Value = 12 },
		{ Name = "MossyStone", Value = 13 },
		{ Name = "Cement", Value = 14 },
		{ Name = "RedPlastic", Value = 15 },
		{ Name = "BluePlastic", Value = 16 },
		{ Name = "Water", Value = 17 },
	},
	["CellOrientation"] = {
		{ Name = "NegZ", Value = 0 },
		{ Name = "X", Value = 1 },
		{ Name = "Z", Value = 2 },
		{ Name = "NegX", Value = 3 },
	},
	["CenterDialogType"] = {
		{ Name = "UnsolicitedDialog", Value = 1 },
		{ Name = "PlayerInitiatedDialog", Value = 2 },
		{ Name = "ModalDialog", Value = 3 },
		{ Name = "QuitDialog", Value = 4 },
	},
	["CharacterControlMode"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Legacy", Value = 1 },
		{ Name = "NoCharacterController", Value = 2 },
		{ Name = "LuaCharacterController", Value = 3 },
	},
	["ChatCallbackType"] = {
		{ Name = "OnCreatingChatWindow", Value = 1 },
		{ Name = "OnClientSendingMessage", Value = 2 },
		{ Name = "OnClientFormattingMessage", Value = 3 },
		{ Name = "OnServerReceivingMessage", Value = 17 },
	},
	["ChatColor"] = {
		{ Name = "Blue", Value = 0 },
		{ Name = "Green", Value = 1 },
		{ Name = "Red", Value = 2 },
		{ Name = "White", Value = 3 },
	},
	["ChatMode"] = {
		{ Name = "Menu", Value = 0 },
		{ Name = "TextAndMenu", Value = 1 },
	},
	["ChatPrivacyMode"] = {
		{ Name = "AllUsers", Value = 0 },
		{ Name = "NoOne", Value = 1 },
		{ Name = "Friends", Value = 2 },
	},
	["ChatRestrictionStatus"] = {
		{ Name = "Unknown", Value = 0 },
		{ Name = "NotRestricted", Value = 1 },
		{ Name = "Restricted", Value = 2 },
	},
	["ChatStyle"] = {
		{ Name = "Classic", Value = 0 },
		{ Name = "Bubble", Value = 1 },
		{ Name = "ClassicAndBubble", Value = 2 },
	},
	["ChatVersion"] = {
		{ Name = "LegacyChatService", Value = 0 },
		{ Name = "TextChatService", Value = 1 },
	},
	["ClientAnimatorThrottlingMode"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Disabled", Value = 1 },
		{ Name = "Enabled", Value = 2 },
	},
	["CloseReason"] = {
		{ Name = "Unknown", Value = 0 },
		{ Name = "RobloxMaintenance", Value = 1 },
		{ Name = "DeveloperShutdown", Value = 2 },
		{ Name = "DeveloperUpdate", Value = 3 },
		{ Name = "ServerEmpty", Value = 4 },
		{ Name = "OutOfMemory", Value = 5 },
	},
	["CollaboratorStatus"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Editing3D", Value = 1 },
		{ Name = "Scripting", Value = 2 },
		{ Name = "PrivateScripting", Value = 3 },
	},
	["CollisionFidelity"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Hull", Value = 1 },
		{ Name = "Box", Value = 2 },
		{ Name = "PreciseConvexDecomposition", Value = 3 },
	},
	["CommandPermission"] = {
		{ Name = "Plugin", Value = 0 },
		{ Name = "LocalUser", Value = 1 },
	},
	["CompileTarget"] = {
		{ Name = "Client", Value = 0 },
		{ Name = "CoreScript", Value = 1 },
		{ Name = "Studio", Value = 2 },
		{ Name = "CoreScriptRaw", Value = 3 },
	},
	["CompletionAcceptanceBehavior"] = {
		{ Name = "Insert", Value = 0 },
		{ Name = "Replace", Value = 1 },
		{ Name = "ReplaceOnEnterInsertOnTab", Value = 2 },
		{ Name = "InsertOnEnterReplaceOnTab", Value = 3 },
	},
	["CompletionItemKind"] = {
		{ Name = "Text", Value = 1 },
		{ Name = "Method", Value = 2 },
		{ Name = "Function", Value = 3 },
		{ Name = "Constructor", Value = 4 },
		{ Name = "Field", Value = 5 },
		{ Name = "Variable", Value = 6 },
		{ Name = "Class", Value = 7 },
		{ Name = "Interface", Value = 8 },
		{ Name = "Module", Value = 9 },
		{ Name = "Property", Value = 10 },
		{ Name = "Unit", Value = 11 },
		{ Name = "Value", Value = 12 },
		{ Name = "Enum", Value = 13 },
		{ Name = "Keyword", Value = 14 },
		{ Name = "Snippet", Value = 15 },
		{ Name = "Color", Value = 16 },
		{ Name = "File", Value = 17 },
		{ Name = "Reference", Value = 18 },
		{ Name = "Folder", Value = 19 },
		{ Name = "EnumMember", Value = 20 },
		{ Name = "Constant", Value = 21 },
		{ Name = "Struct", Value = 22 },
		{ Name = "Event", Value = 23 },
		{ Name = "Operator", Value = 24 },
		{ Name = "TypeParameter", Value = 25 },
	},
	["CompletionItemTag"] = {
		{ Name = "Deprecated", Value = 1 },
		{ Name = "IncorrectIndexType", Value = 2 },
		{ Name = "PluginPermissions", Value = 3 },
		{ Name = "CommandLinePermissions", Value = 4 },
		{ Name = "RobloxPermissions", Value = 5 },
		{ Name = "AddParens", Value = 6 },
		{ Name = "PutCursorInParens", Value = 7 },
		{ Name = "TypeCorrect", Value = 8 },
		{ Name = "ClientServerBoundaryViolation", Value = 9 },
		{ Name = "Invalidated", Value = 10 },
		{ Name = "PutCursorBeforeEnd", Value = 11 },
	},
	["CompletionTriggerKind"] = {
		{ Name = "Invoked", Value = 1 },
		{ Name = "TriggerCharacter", Value = 2 },
		{ Name = "TriggerForIncompleteCompletions", Value = 3 },
	},
	["CompositeValueCurveType"] = {
		{ Name = "ColorRGB", Value = 0 },
		{ Name = "ColorHSV", Value = 1 },
		{ Name = "NumberRange", Value = 2 },
		{ Name = "Rect", Value = 3 },
		{ Name = "UDim", Value = 4 },
		{ Name = "UDim2", Value = 5 },
		{ Name = "Vector2", Value = 6 },
		{ Name = "Vector3", Value = 7 },
	},
	["CompressionAlgorithm"] = {
		{ Name = "Zstd", Value = 0 },
	},
	["ComputerCameraMovementMode"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Classic", Value = 1 },
		{ Name = "Follow", Value = 2 },
		{ Name = "Orbital", Value = 3 },
		{ Name = "CameraToggle", Value = 4 },
	},
	["ComputerMovementMode"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "KeyboardMouse", Value = 1 },
		{ Name = "ClickToMove", Value = 2 },
	},
	["ConfigSnapshotErrorState"] = {
		{ Name = "None", Value = 0 },
		{ Name = "LoadFailed", Value = 1 },
	},
	["ConnectionError"] = {
		{ Name = "OK", Value = 0 },
		{ Name = "Unknown", Value = 1 },
		{ Name = "ConnectErrors", Value = 2 },
		{ Name = "AlreadyConnected", Value = 3 },
		{ Name = "NoFreeIncomingConnections", Value = 4 },
		{ Name = "ConnectionBanned", Value = 5 },
		{ Name = "InvalidPassword", Value = 6 },
		{ Name = "IncompatibleProtocolVersion", Value = 7 },
		{ Name = "IPRecentlyConnected", Value = 8 },
		{ Name = "OurSystemRequiresSecurity", Value = 9 },
		{ Name = "SecurityKeyMismatch", Value = 10 },
		{ Name = "DisconnectErrors", Value = 256 },
		{ Name = "DisconnectBadhash", Value = 257 },
		{ Name = "DisconnectSecurityKeyMismatch", Value = 258 },
		{ Name = "DisconnectProtocolMismatch", Value = 259 },
		{ Name = "DisconnectReceivePacketError", Value = 260 },
		{ Name = "DisconnectReceivePacketStreamError", Value = 261 },
		{ Name = "DisconnectSendPacketError", Value = 262 },
		{ Name = "DisconnectIllegalTeleport", Value = 263 },
		{ Name = "DisconnectDuplicatePlayer", Value = 264 },
		{ Name = "DisconnectDuplicateTicket", Value = 265 },
		{ Name = "DisconnectTimeout", Value = 266 },
		{ Name = "DisconnectLuaKick", Value = 267 },
		{ Name = "DisconnectOnRemoteSysStats", Value = 268 },
		{ Name = "DisconnectHashTimeout", Value = 269 },
		{ Name = "DisconnectCloudEditKick", Value = 270 },
		{ Name = "DisconnectPlayerless", Value = 271 },
		{ Name = "DisconnectNewSecurityKeyMismatch", Value = 272 },
		{ Name = "DisconnectEvicted", Value = 273 },
		{ Name = "DisconnectDevMaintenance", Value = 274 },
		{ Name = "DisconnectRobloxMaintenance", Value = 275 },
		{ Name = "DisconnectRejoin", Value = 276 },
		{ Name = "DisconnectConnectionLost", Value = 277 },
		{ Name = "DisconnectIdle", Value = 278 },
		{ Name = "DisconnectRaknetErrors", Value = 279 },
		{ Name = "DisconnectWrongVersion", Value = 280 },
		{ Name = "DisconnectBySecurityPolicy", Value = 281 },
		{ Name = "DisconnectBlockedIP", Value = 282 },
		{ Name = "DisconnectClientFailure", Value = 284 },
		{ Name = "DisconnectClientRequest", Value = 285 },
		{ Name = "DisconnectPrivateServerKickout", Value = 286 },
		{ Name = "DisconnectModeratedGame", Value = 287 },
		{ Name = "ServerShutdown", Value = 288 },
		{ Name = "ReplicatorTimeout", Value = 290 },
		{ Name = "PlayerRemoved", Value = 291 },
		{ Name = "DisconnectOutOfMemoryKeepPlayingLeave", Value = 292 },
		{ Name = "DisconnectRomarkEndOfTest", Value = 293 },
		{ Name = "DisconnectCollaboratorPermissionRevoked", Value = 294 },
		{ Name = "DisconnectCollaboratorUnderage", Value = 295 },
		{ Name = "NetworkInternal", Value = 296 },
		{ Name = "NetworkSend", Value = 297 },
		{ Name = "NetworkTimeout", Value = 298 },
		{ Name = "NetworkMisbehavior", Value = 299 },
		{ Name = "NetworkSecurity", Value = 300 },
		{ Name = "ReplacementReady", Value = 301 },
		{ Name = "ServerEmpty", Value = 302 },
		{ Name = "PhantomFreeze", Value = 303 },
		{ Name = "AndroidAnticheatKick", Value = 304 },
		{ Name = "AndroidEmulatorKick", Value = 305 },
		{ Name = "AndroidRootedKick", Value = 306 },
		{ Name = "ScreentimeLockoutKick", Value = 307 },
		{ Name = "DisconnectionNotification", Value = 308 },
		{ Name = "DisconnectVerboselyModeratedGame", Value = 309 },
		{ Name = "DisconnectCollaboratorNotAgeVerified", Value = 310 },
		{ Name = "DisconnectCollaboratorTrustedConnectionsRequired", Value = 311 },
		{ Name = "DisconnectCollaboratorOwnerActionRequired", Value = 312 },
		{ Name = "DisconnectCollaboratorTooManyCollaborators", Value = 313 },
		{ Name = "DisconnectCollaboratorUnknownError", Value = 314 },
		{ Name = "PlacelaunchErrors", Value = 512 },
		{ Name = "PlacelaunchDisabled", Value = 515 },
		{ Name = "PlacelaunchError", Value = 516 },
		{ Name = "PlacelaunchGameEnded", Value = 517 },
		{ Name = "PlacelaunchGameFull", Value = 518 },
		{ Name = "PlacelaunchUserLeft", Value = 522 },
		{ Name = "PlacelaunchRestricted", Value = 523 },
		{ Name = "PlacelaunchUnauthorized", Value = 524 },
		{ Name = "PlacelaunchFlooded", Value = 525 },
		{ Name = "PlacelaunchHashExpired", Value = 526 },
		{ Name = "PlacelaunchHashException", Value = 527 },
		{ Name = "PlacelaunchPartyCannotFit", Value = 528 },
		{ Name = "PlacelaunchHttpError", Value = 529 },
		{ Name = "PlacelaunchUserPrivacyUnauthorized", Value = 533 },
		{ Name = "PlacelaunchCreatorBan", Value = 600 },
		{ Name = "PlacelaunchCustomMessage", Value = 610 },
		{ Name = "PlacelaunchOtherError", Value = 611 },
		{ Name = "TeleportErrors", Value = 768 },
		{ Name = "TeleportFailure", Value = 769 },
		{ Name = "TeleportGameNotFound", Value = 770 },
		{ Name = "TeleportGameEnded", Value = 771 },
		{ Name = "TeleportGameFull", Value = 772 },
		{ Name = "TeleportUnauthorized", Value = 773 },
		{ Name = "TeleportFlooded", Value = 774 },
		{ Name = "TeleportIsTeleporting", Value = 775 },
	},
	["ConnectionState"] = {
		{ Name = "Connected", Value = 0 },
		{ Name = "Disconnected", Value = 1 },
	},
	["ContentSourceType"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Uri", Value = 1 },
		{ Name = "Object", Value = 2 },
		{ Name = "Opaque", Value = 3 },
	},
	["ContextActionPriority"] = {
		{ Name = "Low", Value = 1000 },
		{ Name = "Medium", Value = 2000 },
		{ Name = "High", Value = 3000 },
	},
	["ContextActionResult"] = {
		{ Name = "Sink", Value = 0 },
		{ Name = "Pass", Value = 1 },
	},
	["ControlMode"] = {
		{ Name = "Classic", Value = 0 },
		{ Name = "MouseLockSwitch", Value = 1 },
	},
	["CoreGuiType"] = {
		{ Name = "PlayerList", Value = 0 },
		{ Name = "Health", Value = 1 },
		{ Name = "Backpack", Value = 2 },
		{ Name = "Chat", Value = 3 },
		{ Name = "All", Value = 4 },
		{ Name = "EmotesMenu", Value = 5 },
		{ Name = "SelfView", Value = 6 },
		{ Name = "Captures", Value = 7 },
		{ Name = "AvatarSwitcher", Value = 8 },
	},
	["CreateAssetResult"] = {
		{ Name = "Success", Value = 1 },
		{ Name = "PermissionDenied", Value = 2 },
		{ Name = "UploadFailed", Value = 3 },
		{ Name = "Unknown", Value = 4 },
	},
	["CreateOutfitFailure"] = {
		{ Name = "InvalidName", Value = 1 },
		{ Name = "OutfitLimitReached", Value = 2 },
		{ Name = "Other", Value = 3 },
	},
	["CreatorType"] = {
		{ Name = "User", Value = 0 },
		{ Name = "Group", Value = 1 },
	},
	["CreatorTypeFilter"] = {
		{ Name = "User", Value = 0 },
		{ Name = "Group", Value = 1 },
		{ Name = "All", Value = 2 },
	},
	["CurrencyType"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Robux", Value = 1 },
		{ Name = "Tix", Value = 2 },
	},
	["CustomCameraMode"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Classic", Value = 1 },
		{ Name = "Follow", Value = 2 },
	},
	["DataModelExtractorFileType"] = {
		{ Name = "PlaceFile", Value = 0 },
		{ Name = "FirstSlice", Value = 1 },
		{ Name = "NonFirstSlice", Value = 2 },
	},
	["DataStoreRequestType"] = {
		{ Name = "GetAsync", Value = 0 },
		{ Name = "SetIncrementAsync", Value = 1 },
		{ Name = "UpdateAsync", Value = 2 },
		{ Name = "GetSortedAsync", Value = 3 },
		{ Name = "SetIncrementSortedAsync", Value = 4 },
		{ Name = "OnUpdate", Value = 5 },
		{ Name = "ListAsync", Value = 6 },
		{ Name = "GetVersionAsync", Value = 7 },
		{ Name = "RemoveVersionAsync", Value = 8 },
		{ Name = "StandardRead", Value = 9 },
		{ Name = "StandardWrite", Value = 10 },
		{ Name = "StandardList", Value = 11 },
		{ Name = "StandardRemove", Value = 12 },
		{ Name = "OrderedRead", Value = 13 },
		{ Name = "OrderedWrite", Value = 14 },
		{ Name = "OrderedList", Value = 15 },
		{ Name = "OrderedRemove", Value = 16 },
	},
	["DebuggerEndReason"] = {
		{ Name = "ClientRequest", Value = 0 },
		{ Name = "Timeout", Value = 1 },
		{ Name = "InvalidHost", Value = 2 },
		{ Name = "Disconnected", Value = 3 },
		{ Name = "ServerShutdown", Value = 4 },
		{ Name = "ServerProtocolMismatch", Value = 5 },
		{ Name = "ConfigurationFailed", Value = 6 },
		{ Name = "RpcError", Value = 7 },
	},
	["DebuggerExceptionBreakMode"] = {
		{ Name = "Never", Value = 0 },
		{ Name = "Always", Value = 1 },
		{ Name = "Unhandled", Value = 2 },
	},
	["DebuggerFrameType"] = {
		{ Name = "C", Value = 0 },
		{ Name = "Lua", Value = 1 },
	},
	["DebuggerPauseReason"] = {
		{ Name = "Unknown", Value = 0 },
		{ Name = "Requested", Value = 1 },
		{ Name = "Breakpoint", Value = 2 },
		{ Name = "Exception", Value = 3 },
		{ Name = "SingleStep", Value = 4 },
		{ Name = "Entrypoint", Value = 5 },
	},
	["DebuggerStatus"] = {
		{ Name = "Success", Value = 0 },
		{ Name = "Timeout", Value = 1 },
		{ Name = "ConnectionLost", Value = 2 },
		{ Name = "InvalidResponse", Value = 3 },
		{ Name = "InternalError", Value = 4 },
		{ Name = "InvalidState", Value = 5 },
		{ Name = "RpcError", Value = 6 },
		{ Name = "InvalidArgument", Value = 7 },
		{ Name = "ConnectionClosed", Value = 8 },
	},
	["DefaultScriptSyncFileType"] = {
		{ Name = "Lua", Value = 0 },
		{ Name = "Luau", Value = 1 },
	},
	["DevCameraOcclusionMode"] = {
		{ Name = "Zoom", Value = 0 },
		{ Name = "Invisicam", Value = 1 },
	},
	["DevComputerCameraMovementMode"] = {
		{ Name = "UserChoice", Value = 0 },
		{ Name = "Classic", Value = 1 },
		{ Name = "Follow", Value = 2 },
		{ Name = "Orbital", Value = 3 },
		{ Name = "CameraToggle", Value = 4 },
	},
	["DevComputerMovementMode"] = {
		{ Name = "UserChoice", Value = 0 },
		{ Name = "KeyboardMouse", Value = 1 },
		{ Name = "ClickToMove", Value = 2 },
		{ Name = "Scriptable", Value = 3 },
	},
	["DevTouchCameraMovementMode"] = {
		{ Name = "UserChoice", Value = 0 },
		{ Name = "Classic", Value = 1 },
		{ Name = "Follow", Value = 2 },
		{ Name = "Orbital", Value = 3 },
	},
	["DevTouchMovementMode"] = {
		{ Name = "UserChoice", Value = 0 },
		{ Name = "Thumbstick", Value = 1 },
		{ Name = "DPad", Value = 2 },
		{ Name = "Thumbpad", Value = 3 },
		{ Name = "ClickToMove", Value = 4 },
		{ Name = "Scriptable", Value = 5 },
		{ Name = "DynamicThumbstick", Value = 6 },
	},
	["DeveloperMemoryTag"] = {
		{ Name = "Internal", Value = 0 },
		{ Name = "HttpCache", Value = 1 },
		{ Name = "Instances", Value = 2 },
		{ Name = "Signals", Value = 3 },
		{ Name = "LuaHeap", Value = 4 },
		{ Name = "Script", Value = 5 },
		{ Name = "PhysicsCollision", Value = 6 },
		{ Name = "BaseParts", Value = 7 },
		{ Name = "GraphicsSolidModels", Value = 8 },
		{ Name = "GraphicsMeshParts", Value = 10 },
		{ Name = "GraphicsParticles", Value = 11 },
		{ Name = "GraphicsParts", Value = 12 },
		{ Name = "GraphicsSpatialHash", Value = 13 },
		{ Name = "GraphicsTerrain", Value = 14 },
		{ Name = "GraphicsTexture", Value = 15 },
		{ Name = "GraphicsTextureCharacter", Value = 16 },
		{ Name = "Sounds", Value = 17 },
		{ Name = "StreamingSounds", Value = 18 },
		{ Name = "TerrainVoxels", Value = 19 },
		{ Name = "Gui", Value = 21 },
		{ Name = "Animation", Value = 22 },
		{ Name = "Navigation", Value = 23 },
		{ Name = "GeometryCSG", Value = 24 },
		{ Name = "GraphicsSlimModels", Value = 25 },
	},
	["DeviceFeatureType"] = {
		{ Name = "DeviceCapture", Value = 0 },
		{ Name = "InExperienceFAE", Value = 1 },
	},
	["DeviceForm"] = {
		{ Name = "Console", Value = 0 },
		{ Name = "Phone", Value = 1 },
		{ Name = "Tablet", Value = 2 },
		{ Name = "Desktop", Value = 3 },
		{ Name = "VR", Value = 4 },
	},
	["DeviceLevel"] = {
		{ Name = "Low", Value = 0 },
		{ Name = "Medium", Value = 1 },
		{ Name = "High", Value = 2 },
	},
	["DeviceType"] = {
		{ Name = "Unknown", Value = 0 },
		{ Name = "Desktop", Value = 1 },
		{ Name = "Tablet", Value = 2 },
		{ Name = "Phone", Value = 3 },
	},
	["DialogBehaviorType"] = {
		{ Name = "SinglePlayer", Value = 0 },
		{ Name = "MultiplePlayers", Value = 1 },
	},
	["DialogPurpose"] = {
		{ Name = "Quest", Value = 0 },
		{ Name = "Help", Value = 1 },
		{ Name = "Shop", Value = 2 },
	},
	["DialogTone"] = {
		{ Name = "Neutral", Value = 0 },
		{ Name = "Friendly", Value = 1 },
		{ Name = "Enemy", Value = 2 },
	},
	["DigitsRigDescriptionSide"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Left", Value = 1 },
		{ Name = "Right", Value = 2 },
	},
	["DiscountType"] = {
		{ Name = "Uncategorized", Value = 0 },
	},
	["DisplayScalingMode"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Legacy", Value = 1 },
		{ Name = "Responsive", Value = 2 },
	},
	["DisplaySize"] = {
		{ Name = "Small", Value = 0 },
		{ Name = "Medium", Value = 1 },
		{ Name = "Large", Value = 2 },
	},
	["DominantAxis"] = {
		{ Name = "Width", Value = 0 },
		{ Name = "Height", Value = 1 },
	},
	["DraftStatusCode"] = {
		{ Name = "OK", Value = 0 },
		{ Name = "DraftOutdated", Value = 1 },
		{ Name = "ScriptRemoved", Value = 2 },
		{ Name = "DraftCommitted", Value = 3 },
	},
	["DragDetectorDragStyle"] = {
		{ Name = "TranslateLine", Value = 0 },
		{ Name = "TranslatePlane", Value = 1 },
		{ Name = "TranslatePlaneOrLine", Value = 2 },
		{ Name = "TranslateLineOrPlane", Value = 3 },
		{ Name = "TranslateViewPlane", Value = 4 },
		{ Name = "RotateAxis", Value = 5 },
		{ Name = "RotateTrackball", Value = 6 },
		{ Name = "Scriptable", Value = 7 },
		{ Name = "BestForDevice", Value = 8 },
	},
	["DragDetectorPermissionPolicy"] = {
		{ Name = "Nobody", Value = 0 },
		{ Name = "Everybody", Value = 1 },
		{ Name = "Scriptable", Value = 2 },
	},
	["DragDetectorResponseStyle"] = {
		{ Name = "Geometric", Value = 0 },
		{ Name = "Physical", Value = 1 },
		{ Name = "Custom", Value = 2 },
	},
	["DraggerCoordinateSpace"] = {
		{ Name = "Object", Value = 0 },
		{ Name = "World", Value = 1 },
	},
	["DraggerMovementMode"] = {
		{ Name = "Geometric", Value = 0 },
		{ Name = "Physical", Value = 1 },
	},
	["DraggingScrollBar"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Horizontal", Value = 1 },
		{ Name = "Vertical", Value = 2 },
	},
	["EasingDirection"] = {
		{ Name = "In", Value = 0 },
		{ Name = "Out", Value = 1 },
		{ Name = "InOut", Value = 2 },
	},
	["EasingStyle"] = {
		{ Name = "Linear", Value = 0 },
		{ Name = "Sine", Value = 1 },
		{ Name = "Back", Value = 2 },
		{ Name = "Quad", Value = 3 },
		{ Name = "Quart", Value = 4 },
		{ Name = "Quint", Value = 5 },
		{ Name = "Bounce", Value = 6 },
		{ Name = "Elastic", Value = 7 },
		{ Name = "Exponential", Value = 8 },
		{ Name = "Circular", Value = 9 },
		{ Name = "Cubic", Value = 10 },
	},
	["EditableStatus"] = {
		{ Name = "Unknown", Value = 0 },
		{ Name = "Allowed", Value = 1 },
		{ Name = "Disallowed", Value = 2 },
	},
	["ElasticBehavior"] = {
		{ Name = "WhenScrollable", Value = 0 },
		{ Name = "Always", Value = 1 },
		{ Name = "Never", Value = 2 },
	},
	["EngineFolder"] = {
		{ Name = "Screenshots", Value = 0 },
		{ Name = "Videos", Value = 1 },
		{ Name = "Logs", Value = 2 },
	},
	["EnviromentalPhysicsThrottle"] = {
		{ Name = "DefaultAuto", Value = 0 },
		{ Name = "Disabled", Value = 1 },
		{ Name = "Always", Value = 2 },
		{ Name = "Skip2", Value = 3 },
		{ Name = "Skip4", Value = 4 },
		{ Name = "Skip8", Value = 5 },
		{ Name = "Skip16", Value = 6 },
	},
	["ExperienceAuthScope"] = {
		{ Name = "DefaultScope", Value = 0 },
		{ Name = "CreatorAssetsCreate", Value = 1 },
	},
	["ExperienceEventStatus"] = {
		{ Name = "Active", Value = 0 },
		{ Name = "Cancelled", Value = 1 },
		{ Name = "Moderated", Value = 2 },
		{ Name = "Unpublished", Value = 3 },
		{ Name = "Unknown", Value = 4 },
	},
	["ExperienceStateCaptureSelectionMode"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "SafetyHighlightMode", Value = 1 },
	},
	["ExperienceStateRecordingLoadMode"] = {
		{ Name = "NewReplay", Value = 0 },
		{ Name = "ContiguousSlice", Value = 1 },
		{ Name = "NoncontiguousSlice", Value = 2 },
	},
	["ExperienceStateRecordingLoadSourceType"] = {
		{ Name = "S3Url", Value = 0 },
		{ Name = "File", Value = 1 },
	},
	["ExperienceStateRecordingPlaybackMode"] = {
		{ Name = "Undefined", Value = 0 },
		{ Name = "Stopped", Value = 1 },
		{ Name = "Playing", Value = 2 },
		{ Name = "Rewinding", Value = 3 },
	},
	["ExplosionType"] = {
		{ Name = "NoCraters", Value = 0 },
		{ Name = "Craters", Value = 1 },
	},
	["FACSDataLod"] = {
		{ Name = "LOD0", Value = 0 },
		{ Name = "LOD1", Value = 1 },
		{ Name = "LODCount", Value = 2 },
	},
	["FacialAgeEstimationResultType"] = {
		{ Name = "Complete", Value = 0 },
		{ Name = "Cancel", Value = 1 },
		{ Name = "Error", Value = 2 },
	},
	["FacialAnimationStreamingState"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Audio", Value = 1 },
		{ Name = "Video", Value = 2 },
		{ Name = "Place", Value = 4 },
		{ Name = "Server", Value = 8 },
	},
	["FacsActionUnit"] = {
		{ Name = "ChinRaiserUpperLip", Value = 0 },
		{ Name = "ChinRaiser", Value = 1 },
		{ Name = "FlatPucker", Value = 2 },
		{ Name = "Funneler", Value = 3 },
		{ Name = "LowerLipSuck", Value = 4 },
		{ Name = "LipPresser", Value = 5 },
		{ Name = "LipsTogether", Value = 6 },
		{ Name = "MouthLeft", Value = 7 },
		{ Name = "MouthRight", Value = 8 },
		{ Name = "Pucker", Value = 9 },
		{ Name = "UpperLipSuck", Value = 10 },
		{ Name = "LeftCheekPuff", Value = 11 },
		{ Name = "LeftDimpler", Value = 12 },
		{ Name = "LeftLipCornerDown", Value = 13 },
		{ Name = "LeftLowerLipDepressor", Value = 14 },
		{ Name = "LeftLipCornerPuller", Value = 15 },
		{ Name = "LeftLipStretcher", Value = 16 },
		{ Name = "LeftUpperLipRaiser", Value = 17 },
		{ Name = "RightCheekPuff", Value = 18 },
		{ Name = "RightDimpler", Value = 19 },
		{ Name = "RightLipCornerDown", Value = 20 },
		{ Name = "RightLowerLipDepressor", Value = 21 },
		{ Name = "RightLipCornerPuller", Value = 22 },
		{ Name = "RightLipStretcher", Value = 23 },
		{ Name = "RightUpperLipRaiser", Value = 24 },
		{ Name = "JawDrop", Value = 25 },
		{ Name = "JawLeft", Value = 26 },
		{ Name = "JawRight", Value = 27 },
		{ Name = "Corrugator", Value = 28 },
		{ Name = "LeftBrowLowerer", Value = 29 },
		{ Name = "LeftOuterBrowRaiser", Value = 30 },
		{ Name = "LeftNoseWrinkler", Value = 31 },
		{ Name = "LeftInnerBrowRaiser", Value = 32 },
		{ Name = "RightBrowLowerer", Value = 33 },
		{ Name = "RightOuterBrowRaiser", Value = 34 },
		{ Name = "RightInnerBrowRaiser", Value = 35 },
		{ Name = "RightNoseWrinkler", Value = 36 },
		{ Name = "EyesLookDown", Value = 37 },
		{ Name = "EyesLookLeft", Value = 38 },
		{ Name = "EyesLookUp", Value = 39 },
		{ Name = "EyesLookRight", Value = 40 },
		{ Name = "LeftCheekRaiser", Value = 41 },
		{ Name = "LeftEyeUpperLidRaiser", Value = 42 },
		{ Name = "LeftEyeClosed", Value = 43 },
		{ Name = "RightCheekRaiser", Value = 44 },
		{ Name = "RightEyeUpperLidRaiser", Value = 45 },
		{ Name = "RightEyeClosed", Value = 46 },
		{ Name = "TongueDown", Value = 47 },
		{ Name = "TongueOut", Value = 48 },
		{ Name = "TongueUp", Value = 49 },
	},
	["FeatureRestrictionAbuseVector"] = {
		{ Name = "ExperienceChat", Value = 0 },
		{ Name = "Communication", Value = 1 },
	},
	["FieldOfViewMode"] = {
		{ Name = "Vertical", Value = 0 },
		{ Name = "Diagonal", Value = 1 },
		{ Name = "MaxAxis", Value = 2 },
	},
	["FillDirection"] = {
		{ Name = "Horizontal", Value = 0 },
		{ Name = "Vertical", Value = 1 },
	},
	["FilterErrorType"] = {
		{ Name = "BackslashNotEscapingAnything", Value = 0 },
		{ Name = "BadBespokeFilter", Value = 1 },
		{ Name = "BadName", Value = 2 },
		{ Name = "IncompleteOr", Value = 3 },
		{ Name = "IncompleteParenthesis", Value = 4 },
		{ Name = "InvalidDoubleStar", Value = 5 },
		{ Name = "InvalidTilde", Value = 6 },
		{ Name = "PropertyBadOperator", Value = 7 },
		{ Name = "PropertyDoesNotExist", Value = 8 },
		{ Name = "PropertyInvalidField", Value = 9 },
		{ Name = "PropertyInvalidValue", Value = 10 },
		{ Name = "PropertyUnsupportedFields", Value = 11 },
		{ Name = "PropertyUnsupportedProperty", Value = 12 },
		{ Name = "UnexpectedNameIndex", Value = 13 },
		{ Name = "UnexpectedToken", Value = 14 },
		{ Name = "UnfinishedBinaryOperator", Value = 15 },
		{ Name = "UnfinishedQuote", Value = 16 },
		{ Name = "UnknownBespokeFilter", Value = 17 },
		{ Name = "WildcardInProperty", Value = 18 },
	},
	["FilterResult"] = {
		{ Name = "Accepted", Value = 0 },
		{ Name = "Rejected", Value = 1 },
	},
	["FilterType"] = {
		{ Name = "Exclude", Value = 0 },
		{ Name = "Include", Value = 1 },
	},
	["FinishRecordingOperation"] = {
		{ Name = "Cancel", Value = 0 },
		{ Name = "Commit", Value = 1 },
		{ Name = "Append", Value = 2 },
	},
	["FluidFidelity"] = {
		{ Name = "Automatic", Value = 0 },
		{ Name = "UseCollisionGeometry", Value = 1 },
		{ Name = "UsePreciseGeometry", Value = 2 },
	},
	["FluidForces"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Experimental", Value = 1 },
	},
	["Font"] = {
		{ Name = "Legacy", Value = 0 },
		{ Name = "Arial", Value = 1 },
		{ Name = "ArialBold", Value = 2 },
		{ Name = "SourceSans", Value = 3 },
		{ Name = "SourceSansBold", Value = 4 },
		{ Name = "SourceSansLight", Value = 5 },
		{ Name = "SourceSansItalic", Value = 6 },
		{ Name = "Bodoni", Value = 7 },
		{ Name = "Garamond", Value = 8 },
		{ Name = "Cartoon", Value = 9 },
		{ Name = "Code", Value = 10 },
		{ Name = "Highway", Value = 11 },
		{ Name = "SciFi", Value = 12 },
		{ Name = "Arcade", Value = 13 },
		{ Name = "Fantasy", Value = 14 },
		{ Name = "Antique", Value = 15 },
		{ Name = "SourceSansSemibold", Value = 16 },
		{ Name = "Gotham", Value = 17 },
		{ Name = "GothamMedium", Value = 18 },
		{ Name = "GothamBold", Value = 19 },
		{ Name = "GothamBlack", Value = 20 },
		{ Name = "AmaticSC", Value = 21 },
		{ Name = "Bangers", Value = 22 },
		{ Name = "Creepster", Value = 23 },
		{ Name = "DenkOne", Value = 24 },
		{ Name = "Fondamento", Value = 25 },
		{ Name = "FredokaOne", Value = 26 },
		{ Name = "GrenzeGotisch", Value = 27 },
		{ Name = "IndieFlower", Value = 28 },
		{ Name = "JosefinSans", Value = 29 },
		{ Name = "Jura", Value = 30 },
		{ Name = "Kalam", Value = 31 },
		{ Name = "LuckiestGuy", Value = 32 },
		{ Name = "Merriweather", Value = 33 },
		{ Name = "Michroma", Value = 34 },
		{ Name = "Nunito", Value = 35 },
		{ Name = "Oswald", Value = 36 },
		{ Name = "PatrickHand", Value = 37 },
		{ Name = "PermanentMarker", Value = 38 },
		{ Name = "Roboto", Value = 39 },
		{ Name = "RobotoCondensed", Value = 40 },
		{ Name = "RobotoMono", Value = 41 },
		{ Name = "Sarpanch", Value = 42 },
		{ Name = "SpecialElite", Value = 43 },
		{ Name = "TitilliumWeb", Value = 44 },
		{ Name = "Ubuntu", Value = 45 },
		{ Name = "BuilderSans", Value = 46 },
		{ Name = "BuilderSansMedium", Value = 47 },
		{ Name = "BuilderSansBold", Value = 48 },
		{ Name = "BuilderSansExtraBold", Value = 49 },
		{ Name = "Arimo", Value = 50 },
		{ Name = "ArimoBold", Value = 51 },
		{ Name = "Unknown", Value = 100 },
	},
	["FontSize"] = {
		{ Name = "Size8", Value = 0 },
		{ Name = "Size9", Value = 1 },
		{ Name = "Size10", Value = 2 },
		{ Name = "Size11", Value = 3 },
		{ Name = "Size12", Value = 4 },
		{ Name = "Size14", Value = 5 },
		{ Name = "Size18", Value = 6 },
		{ Name = "Size24", Value = 7 },
		{ Name = "Size36", Value = 8 },
		{ Name = "Size48", Value = 9 },
		{ Name = "Size28", Value = 10 },
		{ Name = "Size32", Value = 11 },
		{ Name = "Size42", Value = 12 },
		{ Name = "Size60", Value = 13 },
		{ Name = "Size96", Value = 14 },
	},
	["FontStyle"] = {
		{ Name = "Normal", Value = 0 },
		{ Name = "Italic", Value = 1 },
	},
	["FontWeight"] = {
		{ Name = "Thin", Value = 100 },
		{ Name = "ExtraLight", Value = 200 },
		{ Name = "Light", Value = 300 },
		{ Name = "Regular", Value = 400 },
		{ Name = "Medium", Value = 500 },
		{ Name = "SemiBold", Value = 600 },
		{ Name = "Bold", Value = 700 },
		{ Name = "ExtraBold", Value = 800 },
		{ Name = "Heavy", Value = 900 },
	},
	["ForceLimitMode"] = {
		{ Name = "Magnitude", Value = 0 },
		{ Name = "PerAxis", Value = 1 },
	},
	["FormFactor"] = {
		{ Name = "Symmetric", Value = 0 },
		{ Name = "Brick", Value = 1 },
		{ Name = "Plate", Value = 2 },
		{ Name = "Custom", Value = 3 },
	},
	["FrameStyle"] = {
		{ Name = "Custom", Value = 0 },
		{ Name = "ChatBlue", Value = 1 },
		{ Name = "RobloxSquare", Value = 2 },
		{ Name = "RobloxRound", Value = 3 },
		{ Name = "ChatGreen", Value = 4 },
		{ Name = "ChatRed", Value = 5 },
		{ Name = "DropShadow", Value = 6 },
	},
	["FramerateManagerMode"] = {
		{ Name = "Automatic", Value = 0 },
		{ Name = "On", Value = 1 },
		{ Name = "Off", Value = 2 },
	},
	["FriendRequestEvent"] = {
		{ Name = "Issue", Value = 0 },
		{ Name = "Revoke", Value = 1 },
		{ Name = "Accept", Value = 2 },
		{ Name = "Deny", Value = 3 },
	},
	["FriendStatus"] = {
		{ Name = "Unknown", Value = 0 },
		{ Name = "NotFriend", Value = 1 },
		{ Name = "Friend", Value = 2 },
		{ Name = "FriendRequestSent", Value = 3 },
		{ Name = "FriendRequestReceived", Value = 4 },
	},
	["FunctionalTestResult"] = {
		{ Name = "Passed", Value = 0 },
		{ Name = "Warning", Value = 1 },
		{ Name = "Error", Value = 2 },
	},
	["GameAvatarType"] = {
		{ Name = "R6", Value = 0 },
		{ Name = "R15", Value = 1 },
		{ Name = "PlayerChoice", Value = 2 },
	},
	["GamepadType"] = {
		{ Name = "Unknown", Value = 0 },
		{ Name = "PS4", Value = 1 },
		{ Name = "PS5", Value = 2 },
		{ Name = "XboxOne", Value = 3 },
	},
	["GearGenreSetting"] = {
		{ Name = "AllGenres", Value = 0 },
		{ Name = "MatchingGenreOnly", Value = 1 },
	},
	["GearType"] = {
		{ Name = "MeleeWeapons", Value = 0 },
		{ Name = "RangedWeapons", Value = 1 },
		{ Name = "Explosives", Value = 2 },
		{ Name = "PowerUps", Value = 3 },
		{ Name = "NavigationEnhancers", Value = 4 },
		{ Name = "MusicalInstruments", Value = 5 },
		{ Name = "SocialItems", Value = 6 },
		{ Name = "BuildingTools", Value = 7 },
		{ Name = "Transport", Value = 8 },
	},
	["Genre"] = {
		{ Name = "All", Value = 0 },
		{ Name = "TownAndCity", Value = 1 },
		{ Name = "Fantasy", Value = 2 },
		{ Name = "SciFi", Value = 3 },
		{ Name = "Ninja", Value = 4 },
		{ Name = "Scary", Value = 5 },
		{ Name = "Pirate", Value = 6 },
		{ Name = "Adventure", Value = 7 },
		{ Name = "Sports", Value = 8 },
		{ Name = "Funny", Value = 9 },
		{ Name = "WildWest", Value = 10 },
		{ Name = "War", Value = 11 },
		{ Name = "SkatePark", Value = 12 },
		{ Name = "Tutorial", Value = 13 },
	},
	["GraphicsMode"] = {
		{ Name = "Automatic", Value = 1 },
		{ Name = "Direct3D11", Value = 2 },
		{ Name = "OpenGL", Value = 4 },
		{ Name = "Metal", Value = 5 },
		{ Name = "Vulkan", Value = 6 },
		{ Name = "NoGraphics", Value = 9 },
	},
	["GraphicsOptimizationMode"] = {
		{ Name = "Performance", Value = 0 },
		{ Name = "Balanced", Value = 1 },
		{ Name = "Quality", Value = 2 },
	},
	["GroupMembershipStatus"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Joined", Value = 1 },
		{ Name = "JoinRequestPending", Value = 2 },
		{ Name = "AlreadyMember", Value = 3 },
	},
	["GuiState"] = {
		{ Name = "Idle", Value = 0 },
		{ Name = "Hover", Value = 1 },
		{ Name = "Press", Value = 2 },
		{ Name = "NonInteractable", Value = 3 },
	},
	["GuiType"] = {
		{ Name = "Core", Value = 0 },
		{ Name = "Custom", Value = 1 },
		{ Name = "PlayerNameplates", Value = 2 },
		{ Name = "CustomBillboards", Value = 3 },
		{ Name = "CoreBillboards", Value = 4 },
	},
	["HandlesStyle"] = {
		{ Name = "Resize", Value = 0 },
		{ Name = "Movement", Value = 1 },
	},
	["HapticEffectType"] = {
		{ Name = "Custom", Value = 0 },
		{ Name = "UIHover", Value = 1 },
		{ Name = "UIClick", Value = 2 },
		{ Name = "UINotification", Value = 3 },
		{ Name = "GameplayExplosion", Value = 4 },
		{ Name = "GameplayCollision", Value = 5 },
	},
	["HashAlgorithm"] = {
		{ Name = "Blake2b", Value = 0 },
		{ Name = "Blake3", Value = 1 },
		{ Name = "Md5", Value = 2 },
		{ Name = "Sha1", Value = 3 },
		{ Name = "Sha256", Value = 4 },
	},
	["HighlightDepthMode"] = {
		{ Name = "AlwaysOnTop", Value = 0 },
		{ Name = "Occluded", Value = 1 },
	},
	["HorizontalAlignment"] = {
		{ Name = "Center", Value = 0 },
		{ Name = "Left", Value = 1 },
		{ Name = "Right", Value = 2 },
	},
	["HoverAnimateSpeed"] = {
		{ Name = "VerySlow", Value = 0 },
		{ Name = "Slow", Value = 1 },
		{ Name = "Medium", Value = 2 },
		{ Name = "Fast", Value = 3 },
		{ Name = "VeryFast", Value = 4 },
	},
	["HttpCachePolicy"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Full", Value = 1 },
		{ Name = "DataOnly", Value = 2 },
		{ Name = "Default", Value = 3 },
		{ Name = "InternalRedirectRefresh", Value = 4 },
	},
	["HttpCompression"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Gzip", Value = 1 },
	},
	["HttpContentType"] = {
		{ Name = "ApplicationJson", Value = 0 },
		{ Name = "ApplicationXml", Value = 1 },
		{ Name = "ApplicationUrlEncoded", Value = 2 },
		{ Name = "TextPlain", Value = 3 },
		{ Name = "TextXml", Value = 4 },
	},
	["HttpError"] = {
		{ Name = "OK", Value = 0 },
		{ Name = "InvalidUrl", Value = 1 },
		{ Name = "DnsResolve", Value = 2 },
		{ Name = "ConnectFail", Value = 3 },
		{ Name = "OutOfMemory", Value = 4 },
		{ Name = "TimedOut", Value = 5 },
		{ Name = "TooManyRedirects", Value = 6 },
		{ Name = "InvalidRedirect", Value = 7 },
		{ Name = "NetFail", Value = 8 },
		{ Name = "Aborted", Value = 9 },
		{ Name = "SslConnectFail", Value = 10 },
		{ Name = "SslVerificationFail", Value = 11 },
		{ Name = "Unknown", Value = 12 },
		{ Name = "ConnectionClosed", Value = 13 },
		{ Name = "ServerProtocolError", Value = 14 },
		{ Name = "CreatorEnvironmentsNotSupportedByService", Value = 15 },
		{ Name = "InactivityTimeout", Value = 16 },
		{ Name = "TooManyOutstandingRequests", Value = 17 },
	},
	["HttpRequestType"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "MarketplaceService", Value = 2 },
		{ Name = "Players", Value = 7 },
		{ Name = "Chat", Value = 15 },
		{ Name = "Avatar", Value = 16 },
		{ Name = "Analytics", Value = 23 },
		{ Name = "Localization", Value = 25 },
	},
	["HumanoidCollisionType"] = {
		{ Name = "OuterBox", Value = 0 },
		{ Name = "InnerBox", Value = 1 },
	},
	["HumanoidDisplayDistanceType"] = {
		{ Name = "Viewer", Value = 0 },
		{ Name = "Subject", Value = 1 },
		{ Name = "None", Value = 2 },
	},
	["HumanoidHealthDisplayType"] = {
		{ Name = "DisplayWhenDamaged", Value = 0 },
		{ Name = "AlwaysOn", Value = 1 },
		{ Name = "AlwaysOff", Value = 2 },
	},
	["HumanoidRigType"] = {
		{ Name = "R6", Value = 0 },
		{ Name = "R15", Value = 1 },
	},
	["HumanoidStateType"] = {
		{ Name = "FallingDown", Value = 0 },
		{ Name = "Ragdoll", Value = 1 },
		{ Name = "GettingUp", Value = 2 },
		{ Name = "Jumping", Value = 3 },
		{ Name = "Swimming", Value = 4 },
		{ Name = "Freefall", Value = 5 },
		{ Name = "Flying", Value = 6 },
		{ Name = "Landed", Value = 7 },
		{ Name = "Running", Value = 8 },
		{ Name = "RunningNoPhysics", Value = 10 },
		{ Name = "StrafingNoPhysics", Value = 11 },
		{ Name = "Climbing", Value = 12 },
		{ Name = "Seated", Value = 13 },
		{ Name = "PlatformStanding", Value = 14 },
		{ Name = "Dead", Value = 15 },
		{ Name = "Physics", Value = 16 },
		{ Name = "None", Value = 18 },
	},
	["IKCollisionsMode"] = {
		{ Name = "NoCollisions", Value = 0 },
		{ Name = "OtherMechanismsAnchored", Value = 1 },
		{ Name = "IncludeContactedMechanisms", Value = 2 },
	},
	["IKControlConstraintSupport"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Disabled", Value = 1 },
		{ Name = "Enabled", Value = 2 },
	},
	["IKControlType"] = {
		{ Name = "Transform", Value = 0 },
		{ Name = "Position", Value = 1 },
		{ Name = "Rotation", Value = 2 },
		{ Name = "LookAt", Value = 3 },
	},
	["IXPLoadingStatus"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Pending", Value = 1 },
		{ Name = "Initialized", Value = 2 },
		{ Name = "ErrorInvalidUser", Value = 3 },
		{ Name = "ErrorConnection", Value = 4 },
		{ Name = "ErrorJsonParse", Value = 5 },
		{ Name = "ErrorTimedOut", Value = 6 },
	},
	["ImageAlphaType"] = {
		{ Name = "Default", Value = 1 },
		{ Name = "LockCanvasAlpha", Value = 2 },
		{ Name = "LockCanvasColor", Value = 3 },
	},
	["ImageCombineType"] = {
		{ Name = "BlendSourceOver", Value = 1 },
		{ Name = "Overwrite", Value = 2 },
		{ Name = "Add", Value = 3 },
		{ Name = "Multiply", Value = 4 },
		{ Name = "AlphaBlend", Value = 5 },
	},
	["InOut"] = {
		{ Name = "Edge", Value = 0 },
		{ Name = "Inset", Value = 1 },
		{ Name = "Center", Value = 2 },
	},
	["InfoType"] = {
		{ Name = "Asset", Value = 0 },
		{ Name = "Product", Value = 1 },
		{ Name = "GamePass", Value = 2 },
		{ Name = "Subscription", Value = 3 },
		{ Name = "Bundle", Value = 4 },
	},
	["InitialDockState"] = {
		{ Name = "Top", Value = 0 },
		{ Name = "Bottom", Value = 1 },
		{ Name = "Left", Value = 2 },
		{ Name = "Right", Value = 3 },
		{ Name = "Float", Value = 4 },
	},
	["InputActionType"] = {
		{ Name = "Bool", Value = 0 },
		{ Name = "Direction1D", Value = 1 },
		{ Name = "Direction2D", Value = 2 },
		{ Name = "Direction3D", Value = 3 },
		{ Name = "ViewportPosition", Value = 4 },
	},
	["InputSink"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Activate", Value = 1 },
		{ Name = "All", Value = 100 },
	},
	["InputType"] = {
		{ Name = "NoInput", Value = 0 },
		{ Name = "Constant", Value = 12 },
		{ Name = "Sin", Value = 13 },
	},
	["InstanceFileSyncStatus"] = {
		{ Name = "NotSynced", Value = 0 },
		{ Name = "Errored", Value = 1 },
		{ Name = "SyncedAsRoot", Value = 2 },
		{ Name = "SyncedAsDescendant", Value = 3 },
		{ Name = "AncestorErrored", Value = 4 },
	},
	["IntermediateMeshGenerationResult"] = {
		{ Name = "HighQualityMesh", Value = 0 },
	},
	["InterpolationThrottlingMode"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Disabled", Value = 1 },
		{ Name = "Enabled", Value = 2 },
	},
	["InviteState"] = {
		{ Name = "Placed", Value = 0 },
		{ Name = "Accepted", Value = 1 },
		{ Name = "Declined", Value = 2 },
		{ Name = "Missed", Value = 3 },
	},
	["ItemLineAlignment"] = {
		{ Name = "Automatic", Value = 0 },
		{ Name = "Start", Value = 1 },
		{ Name = "Center", Value = 2 },
		{ Name = "End", Value = 3 },
		{ Name = "Stretch", Value = 4 },
	},
	["JoinSource"] = {
		{ Name = "CreatedItemAttribution", Value = 1 },
	},
	["JointCreationMode"] = {
		{ Name = "All", Value = 0 },
		{ Name = "Surface", Value = 1 },
		{ Name = "None", Value = 2 },
	},
	["KeyCode"] = {
		{ Name = "Unknown", Value = 0 },
		{ Name = "Backspace", Value = 8 },
		{ Name = "Tab", Value = 9 },
		{ Name = "Clear", Value = 12 },
		{ Name = "Return", Value = 13 },
		{ Name = "Pause", Value = 19 },
		{ Name = "Escape", Value = 27 },
		{ Name = "Space", Value = 32 },
		{ Name = "QuotedDouble", Value = 34 },
		{ Name = "Hash", Value = 35 },
		{ Name = "Dollar", Value = 36 },
		{ Name = "Percent", Value = 37 },
		{ Name = "Ampersand", Value = 38 },
		{ Name = "Quote", Value = 39 },
		{ Name = "LeftParenthesis", Value = 40 },
		{ Name = "RightParenthesis", Value = 41 },
		{ Name = "Asterisk", Value = 42 },
		{ Name = "Plus", Value = 43 },
		{ Name = "Comma", Value = 44 },
		{ Name = "Minus", Value = 45 },
		{ Name = "Period", Value = 46 },
		{ Name = "Slash", Value = 47 },
		{ Name = "Zero", Value = 48 },
		{ Name = "One", Value = 49 },
		{ Name = "Two", Value = 50 },
		{ Name = "Three", Value = 51 },
		{ Name = "Four", Value = 52 },
		{ Name = "Five", Value = 53 },
		{ Name = "Six", Value = 54 },
		{ Name = "Seven", Value = 55 },
		{ Name = "Eight", Value = 56 },
		{ Name = "Nine", Value = 57 },
		{ Name = "Colon", Value = 58 },
		{ Name = "Semicolon", Value = 59 },
		{ Name = "LessThan", Value = 60 },
		{ Name = "Equals", Value = 61 },
		{ Name = "GreaterThan", Value = 62 },
		{ Name = "Question", Value = 63 },
		{ Name = "At", Value = 64 },
		{ Name = "LeftBracket", Value = 91 },
		{ Name = "BackSlash", Value = 92 },
		{ Name = "RightBracket", Value = 93 },
		{ Name = "Caret", Value = 94 },
		{ Name = "Underscore", Value = 95 },
		{ Name = "Backquote", Value = 96 },
		{ Name = "A", Value = 97 },
		{ Name = "B", Value = 98 },
		{ Name = "C", Value = 99 },
		{ Name = "D", Value = 100 },
		{ Name = "E", Value = 101 },
		{ Name = "F", Value = 102 },
		{ Name = "G", Value = 103 },
		{ Name = "H", Value = 104 },
		{ Name = "I", Value = 105 },
		{ Name = "J", Value = 106 },
		{ Name = "K", Value = 107 },
		{ Name = "L", Value = 108 },
		{ Name = "M", Value = 109 },
		{ Name = "N", Value = 110 },
		{ Name = "O", Value = 111 },
		{ Name = "P", Value = 112 },
		{ Name = "Q", Value = 113 },
		{ Name = "R", Value = 114 },
		{ Name = "S", Value = 115 },
		{ Name = "T", Value = 116 },
		{ Name = "U", Value = 117 },
		{ Name = "V", Value = 118 },
		{ Name = "W", Value = 119 },
		{ Name = "X", Value = 120 },
		{ Name = "Y", Value = 121 },
		{ Name = "Z", Value = 122 },
		{ Name = "LeftCurly", Value = 123 },
		{ Name = "Pipe", Value = 124 },
		{ Name = "RightCurly", Value = 125 },
		{ Name = "Tilde", Value = 126 },
		{ Name = "Delete", Value = 127 },
		{ Name = "World0", Value = 160 },
		{ Name = "World1", Value = 161 },
		{ Name = "World2", Value = 162 },
		{ Name = "World3", Value = 163 },
		{ Name = "World4", Value = 164 },
		{ Name = "World5", Value = 165 },
		{ Name = "World6", Value = 166 },
		{ Name = "World7", Value = 167 },
		{ Name = "World8", Value = 168 },
		{ Name = "World9", Value = 169 },
		{ Name = "World10", Value = 170 },
		{ Name = "World11", Value = 171 },
		{ Name = "World12", Value = 172 },
		{ Name = "World13", Value = 173 },
		{ Name = "World14", Value = 174 },
		{ Name = "World15", Value = 175 },
		{ Name = "World16", Value = 176 },
		{ Name = "World17", Value = 177 },
		{ Name = "World18", Value = 178 },
		{ Name = "World19", Value = 179 },
		{ Name = "World20", Value = 180 },
		{ Name = "World21", Value = 181 },
		{ Name = "World22", Value = 182 },
		{ Name = "World23", Value = 183 },
		{ Name = "World24", Value = 184 },
		{ Name = "World25", Value = 185 },
		{ Name = "World26", Value = 186 },
		{ Name = "World27", Value = 187 },
		{ Name = "World28", Value = 188 },
		{ Name = "World29", Value = 189 },
		{ Name = "World30", Value = 190 },
		{ Name = "World31", Value = 191 },
		{ Name = "World32", Value = 192 },
		{ Name = "World33", Value = 193 },
		{ Name = "World34", Value = 194 },
		{ Name = "World35", Value = 195 },
		{ Name = "World36", Value = 196 },
		{ Name = "World37", Value = 197 },
		{ Name = "World38", Value = 198 },
		{ Name = "World39", Value = 199 },
		{ Name = "World40", Value = 200 },
		{ Name = "World41", Value = 201 },
		{ Name = "World42", Value = 202 },
		{ Name = "World43", Value = 203 },
		{ Name = "World44", Value = 204 },
		{ Name = "World45", Value = 205 },
		{ Name = "World46", Value = 206 },
		{ Name = "World47", Value = 207 },
		{ Name = "World48", Value = 208 },
		{ Name = "World49", Value = 209 },
		{ Name = "World50", Value = 210 },
		{ Name = "World51", Value = 211 },
		{ Name = "World52", Value = 212 },
		{ Name = "World53", Value = 213 },
		{ Name = "World54", Value = 214 },
		{ Name = "World55", Value = 215 },
		{ Name = "World56", Value = 216 },
		{ Name = "World57", Value = 217 },
		{ Name = "World58", Value = 218 },
		{ Name = "World59", Value = 219 },
		{ Name = "World60", Value = 220 },
		{ Name = "World61", Value = 221 },
		{ Name = "World62", Value = 222 },
		{ Name = "World63", Value = 223 },
		{ Name = "World64", Value = 224 },
		{ Name = "World65", Value = 225 },
		{ Name = "World66", Value = 226 },
		{ Name = "World67", Value = 227 },
		{ Name = "World68", Value = 228 },
		{ Name = "World69", Value = 229 },
		{ Name = "World70", Value = 230 },
		{ Name = "World71", Value = 231 },
		{ Name = "World72", Value = 232 },
		{ Name = "World73", Value = 233 },
		{ Name = "World74", Value = 234 },
		{ Name = "World75", Value = 235 },
		{ Name = "World76", Value = 236 },
		{ Name = "World77", Value = 237 },
		{ Name = "World78", Value = 238 },
		{ Name = "World79", Value = 239 },
		{ Name = "World80", Value = 240 },
		{ Name = "World81", Value = 241 },
		{ Name = "World82", Value = 242 },
		{ Name = "World83", Value = 243 },
		{ Name = "World84", Value = 244 },
		{ Name = "World85", Value = 245 },
		{ Name = "World86", Value = 246 },
		{ Name = "World87", Value = 247 },
		{ Name = "World88", Value = 248 },
		{ Name = "World89", Value = 249 },
		{ Name = "World90", Value = 250 },
		{ Name = "World91", Value = 251 },
		{ Name = "World92", Value = 252 },
		{ Name = "World93", Value = 253 },
		{ Name = "World94", Value = 254 },
		{ Name = "World95", Value = 255 },
		{ Name = "KeypadZero", Value = 256 },
		{ Name = "KeypadOne", Value = 257 },
		{ Name = "KeypadTwo", Value = 258 },
		{ Name = "KeypadThree", Value = 259 },
		{ Name = "KeypadFour", Value = 260 },
		{ Name = "KeypadFive", Value = 261 },
		{ Name = "KeypadSix", Value = 262 },
		{ Name = "KeypadSeven", Value = 263 },
		{ Name = "KeypadEight", Value = 264 },
		{ Name = "KeypadNine", Value = 265 },
		{ Name = "KeypadPeriod", Value = 266 },
		{ Name = "KeypadDivide", Value = 267 },
		{ Name = "KeypadMultiply", Value = 268 },
		{ Name = "KeypadMinus", Value = 269 },
		{ Name = "KeypadPlus", Value = 270 },
		{ Name = "KeypadEnter", Value = 271 },
		{ Name = "KeypadEquals", Value = 272 },
		{ Name = "Up", Value = 273 },
		{ Name = "Down", Value = 274 },
		{ Name = "Right", Value = 275 },
		{ Name = "Left", Value = 276 },
		{ Name = "Insert", Value = 277 },
		{ Name = "Home", Value = 278 },
		{ Name = "End", Value = 279 },
		{ Name = "PageUp", Value = 280 },
		{ Name = "PageDown", Value = 281 },
		{ Name = "F1", Value = 282 },
		{ Name = "F2", Value = 283 },
		{ Name = "F3", Value = 284 },
		{ Name = "F4", Value = 285 },
		{ Name = "F5", Value = 286 },
		{ Name = "F6", Value = 287 },
		{ Name = "F7", Value = 288 },
		{ Name = "F8", Value = 289 },
		{ Name = "F9", Value = 290 },
		{ Name = "F10", Value = 291 },
		{ Name = "F11", Value = 292 },
		{ Name = "F12", Value = 293 },
		{ Name = "F13", Value = 294 },
		{ Name = "F14", Value = 295 },
		{ Name = "F15", Value = 296 },
		{ Name = "NumLock", Value = 300 },
		{ Name = "CapsLock", Value = 301 },
		{ Name = "ScrollLock", Value = 302 },
		{ Name = "RightShift", Value = 303 },
		{ Name = "LeftShift", Value = 304 },
		{ Name = "RightControl", Value = 305 },
		{ Name = "LeftControl", Value = 306 },
		{ Name = "RightAlt", Value = 307 },
		{ Name = "LeftAlt", Value = 308 },
		{ Name = "RightMeta", Value = 309 },
		{ Name = "LeftMeta", Value = 310 },
		{ Name = "LeftSuper", Value = 311 },
		{ Name = "RightSuper", Value = 312 },
		{ Name = "Mode", Value = 313 },
		{ Name = "Compose", Value = 314 },
		{ Name = "Help", Value = 315 },
		{ Name = "Print", Value = 316 },
		{ Name = "SysReq", Value = 317 },
		{ Name = "Break", Value = 318 },
		{ Name = "Menu", Value = 319 },
		{ Name = "Power", Value = 320 },
		{ Name = "Euro", Value = 321 },
		{ Name = "Undo", Value = 322 },
		{ Name = "ButtonX", Value = 1000 },
		{ Name = "ButtonY", Value = 1001 },
		{ Name = "ButtonA", Value = 1002 },
		{ Name = "ButtonB", Value = 1003 },
		{ Name = "ButtonR1", Value = 1004 },
		{ Name = "ButtonL1", Value = 1005 },
		{ Name = "ButtonR2", Value = 1006 },
		{ Name = "ButtonL2", Value = 1007 },
		{ Name = "ButtonR3", Value = 1008 },
		{ Name = "ButtonL3", Value = 1009 },
		{ Name = "ButtonStart", Value = 1010 },
		{ Name = "ButtonSelect", Value = 1011 },
		{ Name = "DPadLeft", Value = 1012 },
		{ Name = "DPadRight", Value = 1013 },
		{ Name = "DPadUp", Value = 1014 },
		{ Name = "DPadDown", Value = 1015 },
		{ Name = "Thumbstick1", Value = 1016 },
		{ Name = "Thumbstick2", Value = 1017 },
		{ Name = "Thumbstick1Up", Value = 1018 },
		{ Name = "Thumbstick1Down", Value = 1019 },
		{ Name = "Thumbstick1Left", Value = 1020 },
		{ Name = "Thumbstick1Right", Value = 1021 },
		{ Name = "Thumbstick2Up", Value = 1022 },
		{ Name = "Thumbstick2Down", Value = 1023 },
		{ Name = "Thumbstick2Left", Value = 1024 },
		{ Name = "Thumbstick2Right", Value = 1025 },
		{ Name = "MouseLeftButton", Value = 1026 },
		{ Name = "MouseRightButton", Value = 1027 },
		{ Name = "MouseMiddleButton", Value = 1028 },
		{ Name = "MouseBackButton", Value = 1029 },
		{ Name = "MouseNoButton", Value = 1030 },
		{ Name = "MouseX", Value = 1031 },
		{ Name = "MouseY", Value = 1032 },
		{ Name = "MousePosition", Value = 1033 },
		{ Name = "Touch", Value = 1034 },
		{ Name = "MouseWheel", Value = 1035 },
		{ Name = "TrackpadPan", Value = 1040 },
		{ Name = "TrackpadPinch", Value = 1045 },
		{ Name = "MouseDelta", Value = 1048 },
	},
	["KeyInterpolationMode"] = {
		{ Name = "Constant", Value = 0 },
		{ Name = "Linear", Value = 1 },
		{ Name = "Cubic", Value = 2 },
	},
	["KeywordFilterType"] = {
		{ Name = "Include", Value = 0 },
		{ Name = "Exclude", Value = 1 },
	},
	["Language"] = {
		{ Name = "Default", Value = 0 },
	},
	["LeftRight"] = {
		{ Name = "Left", Value = 0 },
		{ Name = "Center", Value = 1 },
		{ Name = "Right", Value = 2 },
	},
	["LexemeType"] = {
		{ Name = "Eof", Value = 0 },
		{ Name = "Name", Value = 1 },
		{ Name = "QuotedString", Value = 2 },
		{ Name = "Number", Value = 3 },
		{ Name = "And", Value = 4 },
		{ Name = "Or", Value = 5 },
		{ Name = "Equal", Value = 6 },
		{ Name = "TildeEqual", Value = 7 },
		{ Name = "GreaterThan", Value = 8 },
		{ Name = "GreaterThanEqual", Value = 9 },
		{ Name = "LessThan", Value = 10 },
		{ Name = "LessThanEqual", Value = 11 },
		{ Name = "Colon", Value = 12 },
		{ Name = "Dot", Value = 13 },
		{ Name = "LeftParenthesis", Value = 14 },
		{ Name = "RightParenthesis", Value = 15 },
		{ Name = "Star", Value = 16 },
		{ Name = "DoubleStar", Value = 17 },
		{ Name = "ReservedSpecial", Value = 18 },
	},
	["LightingStyle"] = {
		{ Name = "Realistic", Value = 0 },
		{ Name = "Soft", Value = 1 },
	},
	["Limb"] = {
		{ Name = "Head", Value = 0 },
		{ Name = "Torso", Value = 1 },
		{ Name = "LeftArm", Value = 2 },
		{ Name = "RightArm", Value = 3 },
		{ Name = "LeftLeg", Value = 4 },
		{ Name = "RightLeg", Value = 5 },
		{ Name = "Unknown", Value = 6 },
	},
	["LineJoinMode"] = {
		{ Name = "Round", Value = 0 },
		{ Name = "Bevel", Value = 1 },
		{ Name = "Miter", Value = 2 },
	},
	["ListDisplayMode"] = {
		{ Name = "Horizontal", Value = 0 },
		{ Name = "Vertical", Value = 1 },
	},
	["ListenerLocation"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "None", Value = 1 },
		{ Name = "Character", Value = 2 },
		{ Name = "Camera", Value = 3 },
	},
	["ListenerType"] = {
		{ Name = "Camera", Value = 0 },
		{ Name = "CFrame", Value = 1 },
		{ Name = "ObjectPosition", Value = 2 },
		{ Name = "ObjectCFrame", Value = 3 },
	},
	["LiveEditingAtomicUpdateResponse"] = {
		{ Name = "Success", Value = 0 },
		{ Name = "FailureGuidNotFound", Value = 1 },
		{ Name = "FailureHashMismatch", Value = 2 },
		{ Name = "FailureOperationIllegal", Value = 3 },
	},
	["LiveEditingBroadcastMessageType"] = {
		{ Name = "Normal", Value = 0 },
		{ Name = "Warning", Value = 1 },
		{ Name = "Error", Value = 2 },
	},
	["LoadCharacterLayeredClothing"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Disabled", Value = 1 },
		{ Name = "Enabled", Value = 2 },
	},
	["LoadDynamicHeads"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Disabled", Value = 1 },
		{ Name = "Enabled", Value = 2 },
	},
	["LocationType"] = {
		{ Name = "Character", Value = 0 },
		{ Name = "Camera", Value = 1 },
		{ Name = "ObjectPosition", Value = 2 },
	},
	["LuauTypeCheckMode"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "NoCheck", Value = 1 },
		{ Name = "Nonstrict", Value = 2 },
		{ Name = "Strict", Value = 3 },
	},
	["MakeupType"] = {
		{ Name = "Face", Value = 0 },
		{ Name = "Lip", Value = 1 },
		{ Name = "Eye", Value = 2 },
	},
	["MarketplaceBulkPurchasePromptStatus"] = {
		{ Name = "Completed", Value = 1 },
		{ Name = "Aborted", Value = 2 },
		{ Name = "Error", Value = 3 },
	},
	["MarketplaceItemPurchaseStatus"] = {
		{ Name = "Success", Value = 1 },
		{ Name = "SystemError", Value = 2 },
		{ Name = "AlreadyOwned", Value = 3 },
		{ Name = "InsufficientRobux", Value = 4 },
		{ Name = "QuantityLimitExceeded", Value = 5 },
		{ Name = "QuotaExceeded", Value = 6 },
		{ Name = "NotForSale", Value = 7 },
		{ Name = "NotAvailableForPurchaser", Value = 8 },
		{ Name = "PriceMismatch", Value = 9 },
		{ Name = "SoldOut", Value = 10 },
		{ Name = "PurchaserIsSeller", Value = 11 },
		{ Name = "InsufficientMembership", Value = 12 },
		{ Name = "PlaceInvalid", Value = 13 },
	},
	["MarketplaceProductType"] = {
		{ Name = "AvatarAsset", Value = 1 },
		{ Name = "AvatarBundle", Value = 2 },
	},
	["MarkupKind"] = {
		{ Name = "PlainText", Value = 0 },
		{ Name = "Markdown", Value = 1 },
	},
	["MatchmakingType"] = {
		{ Name = "Default", Value = 1 },
		{ Name = "XboxOnly", Value = 2 },
		{ Name = "PlayStationOnly", Value = 3 },
	},
	["Material"] = {
		{ Name = "Plastic", Value = 256 },
		{ Name = "SmoothPlastic", Value = 272 },
		{ Name = "Neon", Value = 288 },
		{ Name = "Wood", Value = 512 },
		{ Name = "WoodPlanks", Value = 528 },
		{ Name = "Marble", Value = 784 },
		{ Name = "Basalt", Value = 788 },
		{ Name = "Slate", Value = 800 },
		{ Name = "CrackedLava", Value = 804 },
		{ Name = "Concrete", Value = 816 },
		{ Name = "Limestone", Value = 820 },
		{ Name = "Granite", Value = 832 },
		{ Name = "Pavement", Value = 836 },
		{ Name = "Brick", Value = 848 },
		{ Name = "Pebble", Value = 864 },
		{ Name = "Cobblestone", Value = 880 },
		{ Name = "Rock", Value = 896 },
		{ Name = "Sandstone", Value = 912 },
		{ Name = "CorrodedMetal", Value = 1040 },
		{ Name = "DiamondPlate", Value = 1056 },
		{ Name = "Foil", Value = 1072 },
		{ Name = "Metal", Value = 1088 },
		{ Name = "Grass", Value = 1280 },
		{ Name = "LeafyGrass", Value = 1284 },
		{ Name = "Sand", Value = 1296 },
		{ Name = "Fabric", Value = 1312 },
		{ Name = "Snow", Value = 1328 },
		{ Name = "Mud", Value = 1344 },
		{ Name = "Ground", Value = 1360 },
		{ Name = "Asphalt", Value = 1376 },
		{ Name = "Salt", Value = 1392 },
		{ Name = "Ice", Value = 1536 },
		{ Name = "Glacier", Value = 1552 },
		{ Name = "Glass", Value = 1568 },
		{ Name = "ForceField", Value = 1584 },
		{ Name = "Air", Value = 1792 },
		{ Name = "Water", Value = 2048 },
		{ Name = "Cardboard", Value = 2304 },
		{ Name = "Carpet", Value = 2305 },
		{ Name = "CeramicTiles", Value = 2306 },
		{ Name = "ClayRoofTiles", Value = 2307 },
		{ Name = "RoofShingles", Value = 2308 },
		{ Name = "Leather", Value = 2309 },
		{ Name = "Plaster", Value = 2310 },
		{ Name = "Rubber", Value = 2311 },
	},
	["MaterialPattern"] = {
		{ Name = "Regular", Value = 0 },
		{ Name = "Organic", Value = 1 },
	},
	["MembershipType"] = {
		{ Name = "None", Value = 0 },
		{ Name = "BuildersClub", Value = 1 },
		{ Name = "TurboBuildersClub", Value = 2 },
		{ Name = "OutrageousBuildersClub", Value = 3 },
		{ Name = "Premium", Value = 4 },
	},
	["MeshPartDetailLevel"] = {
		{ Name = "DistanceBased", Value = 0 },
		{ Name = "Level00", Value = 1 },
		{ Name = "Level01", Value = 2 },
		{ Name = "Level02", Value = 3 },
		{ Name = "Level03", Value = 4 },
		{ Name = "Level04", Value = 5 },
	},
	["MeshPartHeadsAndAccessories"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Disabled", Value = 1 },
		{ Name = "Enabled", Value = 2 },
	},
	["MeshScaleUnit"] = {
		{ Name = "Stud", Value = 0 },
		{ Name = "Meter", Value = 1 },
		{ Name = "CM", Value = 2 },
		{ Name = "MM", Value = 3 },
		{ Name = "Foot", Value = 4 },
		{ Name = "Inch", Value = 5 },
	},
	["MeshType"] = {
		{ Name = "Head", Value = 0 },
		{ Name = "Torso", Value = 1 },
		{ Name = "Wedge", Value = 2 },
		{ Name = "Sphere", Value = 3 },
		{ Name = "Cylinder", Value = 4 },
		{ Name = "FileMesh", Value = 5 },
		{ Name = "Brick", Value = 6 },
		{ Name = "Prism", Value = 7 },
		{ Name = "Pyramid", Value = 8 },
		{ Name = "ParallelRamp", Value = 9 },
		{ Name = "RightAngleRamp", Value = 10 },
		{ Name = "CornerWedge", Value = 11 },
	},
	["MessageType"] = {
		{ Name = "MessageOutput", Value = 0 },
		{ Name = "MessageInfo", Value = 1 },
		{ Name = "MessageWarning", Value = 2 },
		{ Name = "MessageError", Value = 3 },
	},
	["ModelLevelOfDetail"] = {
		{ Name = "Automatic", Value = 0 },
		{ Name = "StreamingMesh", Value = 1 },
		{ Name = "Disabled", Value = 2 },
		{ Name = "SLIM", Value = 4 },
	},
	["ModelStreamingBehavior"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Legacy", Value = 1 },
		{ Name = "Improved", Value = 2 },
	},
	["ModelStreamingMode"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Atomic", Value = 1 },
		{ Name = "Persistent", Value = 2 },
		{ Name = "PersistentPerPlayer", Value = 3 },
		{ Name = "Nonatomic", Value = 4 },
	},
	["ModerationResultCategory"] = {
		{ Name = "ViolationDetected", Value = 0 },
		{ Name = "Borderline", Value = 1 },
		{ Name = "NoViolationDetected", Value = 2 },
	},
	["ModerationResultLabel"] = {
		{ Name = "ChildExploitation", Value = 0 },
		{ Name = "SuicideSelfInjuryAndHarmfulBehavior", Value = 1 },
		{ Name = "ThreatsBullyingAndHarassment", Value = 2 },
		{ Name = "TerrorismAndViolentExtremism", Value = 3 },
		{ Name = "DiscriminationSlursAndHateSpeech", Value = 4 },
		{ Name = "RealWorldSensitiveEvents", Value = 5 },
		{ Name = "ViolentContentAndGore", Value = 6 },
		{ Name = "RomanticAndSexualContent", Value = 7 },
		{ Name = "IllegalAndRegulatedGoodsAndActivities", Value = 8 },
		{ Name = "Profanity", Value = 9 },
		{ Name = "Other", Value = 100 },
	},
	["ModerationStatus"] = {
		{ Name = "ReviewedApproved", Value = 1 },
		{ Name = "ReviewedRejected", Value = 2 },
		{ Name = "NotReviewed", Value = 3 },
		{ Name = "NotApplicable", Value = 4 },
		{ Name = "Invalid", Value = 5 },
	},
	["ModifierKey"] = {
		{ Name = "Shift", Value = 0 },
		{ Name = "Ctrl", Value = 1 },
		{ Name = "Alt", Value = 2 },
		{ Name = "Meta", Value = 3 },
	},
	["MouseBehavior"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "LockCenter", Value = 1 },
		{ Name = "LockCurrentPosition", Value = 2 },
	},
	["MoveState"] = {
		{ Name = "Stopped", Value = 0 },
		{ Name = "Coasting", Value = 1 },
		{ Name = "Pushing", Value = 2 },
		{ Name = "Stopping", Value = 3 },
		{ Name = "AirFree", Value = 4 },
	},
	["MoverConstraintRootBehaviorMode"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Disabled", Value = 1 },
		{ Name = "Enabled", Value = 2 },
	},
	["MuteState"] = {
		{ Name = "Unmuted", Value = 0 },
		{ Name = "Muted", Value = 1 },
	},
	["NameOcclusion"] = {
		{ Name = "NoOcclusion", Value = 0 },
		{ Name = "EnemyOcclusion", Value = 1 },
		{ Name = "OccludeAll", Value = 2 },
	},
	["NegateOperationHiddenHistory"] = {
		{ Name = "None", Value = 0 },
		{ Name = "NegatedUnion", Value = 1 },
		{ Name = "NegatedIntersection", Value = 2 },
	},
	["NetworkOwnership"] = {
		{ Name = "Automatic", Value = 0 },
		{ Name = "Manual", Value = 1 },
		{ Name = "OnContact", Value = 2 },
	},
	["NetworkStatus"] = {
		{ Name = "Unknown", Value = 0 },
		{ Name = "Connected", Value = 1 },
		{ Name = "Disconnected", Value = 2 },
	},
	["NoiseType"] = {
		{ Name = "SimplexGabor", Value = 0 },
	},
	["NormalId"] = {
		{ Name = "Right", Value = 0 },
		{ Name = "Top", Value = 1 },
		{ Name = "Back", Value = 2 },
		{ Name = "Left", Value = 3 },
		{ Name = "Bottom", Value = 4 },
		{ Name = "Front", Value = 5 },
	},
	["NotificationButtonType"] = {
		{ Name = "Primary", Value = 0 },
		{ Name = "Secondary", Value = 1 },
	},
	["OperationType"] = {
		{ Name = "Null", Value = 0 },
		{ Name = "Union", Value = 1 },
		{ Name = "Subtraction", Value = 2 },
		{ Name = "Intersection", Value = 3 },
		{ Name = "Primitive", Value = 4 },
	},
	["OrientationAlignmentMode"] = {
		{ Name = "OneAttachment", Value = 0 },
		{ Name = "TwoAttachment", Value = 1 },
	},
	["OutfitSource"] = {
		{ Name = "All", Value = 1 },
		{ Name = "Created", Value = 2 },
		{ Name = "Purchased", Value = 3 },
	},
	["OutfitType"] = {
		{ Name = "All", Value = 1 },
		{ Name = "Avatar", Value = 2 },
		{ Name = "DynamicHead", Value = 3 },
		{ Name = "Shoes", Value = 4 },
	},
	["OutputLayoutMode"] = {
		{ Name = "Horizontal", Value = 0 },
		{ Name = "Vertical", Value = 1 },
	},
	["OverrideMouseIconBehavior"] = {
		{ Name = "None", Value = 0 },
		{ Name = "ForceShow", Value = 1 },
		{ Name = "ForceHide", Value = 2 },
	},
	["PackagePermission"] = {
		{ Name = "None", Value = 0 },
		{ Name = "NoAccess", Value = 1 },
		{ Name = "Revoked", Value = 2 },
		{ Name = "UseView", Value = 3 },
		{ Name = "Edit", Value = 4 },
		{ Name = "Own", Value = 5 },
	},
	["PartType"] = {
		{ Name = "Ball", Value = 0 },
		{ Name = "Block", Value = 1 },
		{ Name = "Cylinder", Value = 2 },
		{ Name = "Wedge", Value = 3 },
		{ Name = "CornerWedge", Value = 4 },
	},
	["ParticleEmitterShape"] = {
		{ Name = "Box", Value = 0 },
		{ Name = "Sphere", Value = 1 },
		{ Name = "Cylinder", Value = 2 },
		{ Name = "Disc", Value = 3 },
	},
	["ParticleEmitterShapeInOut"] = {
		{ Name = "Outward", Value = 0 },
		{ Name = "Inward", Value = 1 },
		{ Name = "InAndOut", Value = 2 },
	},
	["ParticleEmitterShapeStyle"] = {
		{ Name = "Volume", Value = 0 },
		{ Name = "Surface", Value = 1 },
	},
	["ParticleFlipbookLayout"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Grid2x2", Value = 1 },
		{ Name = "Grid4x4", Value = 2 },
		{ Name = "Grid8x8", Value = 3 },
		{ Name = "Custom", Value = 4 },
	},
	["ParticleFlipbookMode"] = {
		{ Name = "Loop", Value = 0 },
		{ Name = "OneShot", Value = 1 },
		{ Name = "PingPong", Value = 2 },
		{ Name = "Random", Value = 3 },
	},
	["ParticleFlipbookTextureCompatible"] = {
		{ Name = "NotCompatible", Value = 0 },
		{ Name = "Compatible", Value = 1 },
		{ Name = "Unknown", Value = 2 },
	},
	["ParticleOrientation"] = {
		{ Name = "FacingCamera", Value = 0 },
		{ Name = "FacingCameraWorldUp", Value = 1 },
		{ Name = "VelocityParallel", Value = 2 },
		{ Name = "VelocityPerpendicular", Value = 3 },
	},
	["PathStatus"] = {
		{ Name = "Success", Value = 0 },
		{ Name = "ClosestNoPath", Value = 1 },
		{ Name = "ClosestOutOfRange", Value = 2 },
		{ Name = "FailStartNotEmpty", Value = 3 },
		{ Name = "FailFinishNotEmpty", Value = 4 },
		{ Name = "NoPath", Value = 5 },
	},
	["PathWaypointAction"] = {
		{ Name = "Walk", Value = 0 },
		{ Name = "Jump", Value = 1 },
		{ Name = "Custom", Value = 2 },
	},
	["PathfindingUseImprovedSearch"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Disabled", Value = 1 },
		{ Name = "Enabled", Value = 2 },
	},
	["PeoplePageLayout"] = {
		{ Name = "Card", Value = 0 },
		{ Name = "List", Value = 1 },
	},
	["PerformanceOverlayMode"] = {
		{ Name = "Overdraw", Value = 0 },
		{ Name = "Transparent", Value = 1 },
		{ Name = "Decals", Value = 2 },
		{ Name = "Lights", Value = 3 },
	},
	["PermissionLevelShown"] = {
		{ Name = "Game", Value = 0 },
		{ Name = "RobloxGame", Value = 1 },
		{ Name = "RobloxScript", Value = 2 },
		{ Name = "Studio", Value = 3 },
		{ Name = "Roblox", Value = 4 },
	},
	["PhysicsSimulationRate"] = {
		{ Name = "Fixed240Hz", Value = 0 },
		{ Name = "Fixed120Hz", Value = 1 },
		{ Name = "Fixed60Hz", Value = 2 },
	},
	["PhysicsSteppingMethod"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Fixed", Value = 1 },
		{ Name = "Adaptive", Value = 2 },
	},
	["PlaceContentPreference"] = {
		{ Name = "None", Value = 0 },
		{ Name = "All", Value = 1 },
		{ Name = "MentionsAndReplies", Value = 2 },
		{ Name = "Unknown", Value = 3 },
	},
	["PlacePublishType"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Publish", Value = 1 },
		{ Name = "Save", Value = 2 },
	},
	["Platform"] = {
		{ Name = "Windows", Value = 0 },
		{ Name = "OSX", Value = 1 },
		{ Name = "IOS", Value = 2 },
		{ Name = "Android", Value = 3 },
		{ Name = "XBoxOne", Value = 4 },
		{ Name = "PS4", Value = 5 },
		{ Name = "PS3", Value = 6 },
		{ Name = "XBox360", Value = 7 },
		{ Name = "WiiU", Value = 8 },
		{ Name = "NX", Value = 9 },
		{ Name = "Ouya", Value = 10 },
		{ Name = "AndroidTV", Value = 11 },
		{ Name = "Chromecast", Value = 12 },
		{ Name = "Linux", Value = 13 },
		{ Name = "SteamOS", Value = 14 },
		{ Name = "WebOS", Value = 15 },
		{ Name = "DOS", Value = 16 },
		{ Name = "BeOS", Value = 17 },
		{ Name = "UWP", Value = 18 },
		{ Name = "PS5", Value = 19 },
		{ Name = "MetaOS", Value = 20 },
		{ Name = "Web", Value = 21 },
		{ Name = "None", Value = 22 },
	},
	["PlaybackState"] = {
		{ Name = "Begin", Value = 0 },
		{ Name = "Delayed", Value = 1 },
		{ Name = "Playing", Value = 2 },
		{ Name = "Paused", Value = 3 },
		{ Name = "Completed", Value = 4 },
		{ Name = "Cancelled", Value = 5 },
	},
	["PlayerActions"] = {
		{ Name = "CharacterForward", Value = 0 },
		{ Name = "CharacterBackward", Value = 1 },
		{ Name = "CharacterLeft", Value = 2 },
		{ Name = "CharacterRight", Value = 3 },
		{ Name = "CharacterJump", Value = 4 },
	},
	["PlayerCharacterDestroyBehavior"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Disabled", Value = 1 },
		{ Name = "Enabled", Value = 2 },
	},
	["PlayerChatType"] = {
		{ Name = "All", Value = 0 },
		{ Name = "Team", Value = 1 },
		{ Name = "Whisper", Value = 2 },
	},
	["PlayerDataErrorState"] = {
		{ Name = "LoadFailed", Value = 0 },
		{ Name = "FlushFailed", Value = 1 },
		{ Name = "ReleaseFailed", Value = 2 },
		{ Name = "None", Value = 3 },
	},
	["PlayerDataLoadFailureBehavior"] = {
		{ Name = "Failure", Value = 0 },
		{ Name = "FallbackToDefault", Value = 1 },
		{ Name = "Kick", Value = 2 },
	},
	["PlayerExitReason"] = {
		{ Name = "Unknown", Value = 0 },
		{ Name = "PlatformKick", Value = 1 },
		{ Name = "CreatorKick", Value = 2 },
	},
	["PoseEasingDirection"] = {
		{ Name = "In", Value = 0 },
		{ Name = "Out", Value = 1 },
		{ Name = "InOut", Value = 2 },
	},
	["PoseEasingStyle"] = {
		{ Name = "Linear", Value = 0 },
		{ Name = "Constant", Value = 1 },
		{ Name = "Elastic", Value = 2 },
		{ Name = "Cubic", Value = 3 },
		{ Name = "Bounce", Value = 4 },
		{ Name = "CubicV2", Value = 5 },
	},
	["PositionAlignmentMode"] = {
		{ Name = "OneAttachment", Value = 0 },
		{ Name = "TwoAttachment", Value = 1 },
	},
	["PredictionMode"] = {
		{ Name = "Automatic", Value = 0 },
		{ Name = "On", Value = 1 },
		{ Name = "Off", Value = 2 },
	},
	["PredictionStatus"] = {
		{ Name = "Authoritative", Value = 0 },
		{ Name = "Predicted", Value = 1 },
		{ Name = "None", Value = 2 },
	},
	["PreferredInput"] = {
		{ Name = "KeyboardAndMouse", Value = 0 },
		{ Name = "Gamepad", Value = 1 },
		{ Name = "Touch", Value = 2 },
	},
	["PreferredTextSize"] = {
		{ Name = "Medium", Value = 1 },
		{ Name = "Large", Value = 2 },
		{ Name = "Larger", Value = 3 },
		{ Name = "Largest", Value = 4 },
	},
	["PrimalPhysicsSolver"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Experimental", Value = 1 },
		{ Name = "Disabled", Value = 2 },
	},
	["PrimitiveType"] = {
		{ Name = "Null", Value = 0 },
		{ Name = "Ball", Value = 1 },
		{ Name = "Cylinder", Value = 2 },
		{ Name = "Block", Value = 3 },
		{ Name = "Wedge", Value = 4 },
		{ Name = "CornerWedge", Value = 5 },
	},
	["PrivilegeType"] = {
		{ Name = "Banned", Value = 0 },
		{ Name = "Visitor", Value = 10 },
		{ Name = "Member", Value = 128 },
		{ Name = "Admin", Value = 240 },
		{ Name = "Owner", Value = 255 },
	},
	["ProductLocationRestriction"] = {
		{ Name = "AvatarShop", Value = 0 },
		{ Name = "AllowedGames", Value = 1 },
		{ Name = "AllGames", Value = 2 },
	},
	["ProductPurchaseChannel"] = {
		{ Name = "InExperience", Value = 1 },
		{ Name = "ExperienceDetailsPage", Value = 2 },
		{ Name = "AdReward", Value = 3 },
		{ Name = "CommerceProduct", Value = 4 },
	},
	["ProductPurchaseDecision"] = {
		{ Name = "NotProcessedYet", Value = 0 },
		{ Name = "PurchaseGranted", Value = 1 },
	},
	["PromptCreateAssetResult"] = {
		{ Name = "Success", Value = 1 },
		{ Name = "PermissionDenied", Value = 2 },
		{ Name = "Timeout", Value = 3 },
		{ Name = "UploadFailed", Value = 4 },
		{ Name = "NoUserInput", Value = 5 },
		{ Name = "UnknownFailure", Value = 6 },
		{ Name = "UGCValidationFailed", Value = 7 },
		{ Name = "ModeratedName", Value = 8 },
		{ Name = "PurchaseFailure", Value = 9 },
		{ Name = "TokenInvalid", Value = 10 },
	},
	["PromptCreateAvatarResult"] = {
		{ Name = "Success", Value = 1 },
		{ Name = "PermissionDenied", Value = 2 },
		{ Name = "Timeout", Value = 3 },
		{ Name = "UploadFailed", Value = 4 },
		{ Name = "NoUserInput", Value = 5 },
		{ Name = "InvalidHumanoidDescription", Value = 6 },
		{ Name = "UGCValidationFailed", Value = 7 },
		{ Name = "ModeratedName", Value = 8 },
		{ Name = "MaxOutfits", Value = 9 },
		{ Name = "PurchaseFailure", Value = 10 },
		{ Name = "UnknownFailure", Value = 11 },
		{ Name = "TokenInvalid", Value = 12 },
	},
	["PromptExperienceDetailsResult"] = {
		{ Name = "PromptClosed", Value = 0 },
		{ Name = "TeleportAttempted", Value = 1 },
	},
	["PromptLinkSharingResult"] = {
		{ Name = "Success", Value = 1 },
		{ Name = "PlayerLeft", Value = 2 },
		{ Name = "InvalidLaunchData", Value = 3 },
	},
	["PromptPublishAssetResult"] = {
		{ Name = "Success", Value = 1 },
		{ Name = "PermissionDenied", Value = 2 },
		{ Name = "Timeout", Value = 3 },
		{ Name = "UploadFailed", Value = 4 },
		{ Name = "NoUserInput", Value = 5 },
		{ Name = "UnknownFailure", Value = 6 },
	},
	["PropertyStatus"] = {
		{ Name = "Ok", Value = 0 },
		{ Name = "Warning", Value = 1 },
		{ Name = "Error", Value = 2 },
	},
	["ProximityPromptExclusivity"] = {
		{ Name = "OnePerButton", Value = 0 },
		{ Name = "OneGlobally", Value = 1 },
		{ Name = "AlwaysShow", Value = 2 },
	},
	["ProximityPromptInputType"] = {
		{ Name = "Keyboard", Value = 0 },
		{ Name = "Gamepad", Value = 1 },
		{ Name = "Touch", Value = 2 },
	},
	["ProximityPromptStyle"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Custom", Value = 1 },
	},
	["QualityLevel"] = {
		{ Name = "Automatic", Value = 0 },
		{ Name = "Level01", Value = 1 },
		{ Name = "Level02", Value = 2 },
		{ Name = "Level03", Value = 3 },
		{ Name = "Level04", Value = 4 },
		{ Name = "Level05", Value = 5 },
		{ Name = "Level06", Value = 6 },
		{ Name = "Level07", Value = 7 },
		{ Name = "Level08", Value = 8 },
		{ Name = "Level09", Value = 9 },
		{ Name = "Level10", Value = 10 },
		{ Name = "Level11", Value = 11 },
		{ Name = "Level12", Value = 12 },
		{ Name = "Level13", Value = 13 },
		{ Name = "Level14", Value = 14 },
		{ Name = "Level15", Value = 15 },
		{ Name = "Level16", Value = 16 },
		{ Name = "Level17", Value = 17 },
		{ Name = "Level18", Value = 18 },
		{ Name = "Level19", Value = 19 },
		{ Name = "Level20", Value = 20 },
		{ Name = "Level21", Value = 21 },
	},
	["R15CollisionType"] = {
		{ Name = "OuterBox", Value = 0 },
		{ Name = "InnerBox", Value = 1 },
	},
	["RaycastFilterType"] = {
		{ Name = "Exclude", Value = 0 },
		{ Name = "Include", Value = 1 },
	},
	["ReadCapturesFromGalleryResult"] = {
		{ Name = "Success", Value = 0 },
		{ Name = "NeedPermission", Value = 1 },
	},
	["RecommendationActionType"] = {
		{ Name = "AddReaction", Value = 0 },
		{ Name = "RemoveReaction", Value = 1 },
		{ Name = "Share", Value = 2 },
		{ Name = "Report", Value = 3 },
		{ Name = "Comment", Value = 4 },
		{ Name = "Play", Value = 5 },
		{ Name = "Purchase", Value = 6 },
	},
	["RecommendationDepartureIntent"] = {
		{ Name = "Neutral", Value = 0 },
		{ Name = "Positive", Value = 1 },
		{ Name = "Negative", Value = 2 },
	},
	["RecommendationImpressionType"] = {
		{ Name = "View", Value = 0 },
		{ Name = "NotViewable", Value = 1 },
	},
	["RecommendationItemContentType"] = {
		{ Name = "Static", Value = 0 },
		{ Name = "Dynamic", Value = 1 },
		{ Name = "Interactive", Value = 2 },
	},
	["RecommendationItemVisibility"] = {
		{ Name = "Private", Value = 0 },
		{ Name = "Public", Value = 1 },
	},
	["RejectCharacterDeletions"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Disabled", Value = 1 },
		{ Name = "Enabled", Value = 2 },
	},
	["RenderFidelity"] = {
		{ Name = "Automatic", Value = 0 },
		{ Name = "Precise", Value = 1 },
		{ Name = "Performance", Value = 2 },
	},
	["RenderPriority"] = {
		{ Name = "First", Value = 0 },
		{ Name = "Input", Value = 100 },
		{ Name = "Camera", Value = 200 },
		{ Name = "Character", Value = 300 },
		{ Name = "Last", Value = 2000 },
	},
	["RenderingCacheOptimizationMode"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Disabled", Value = 1 },
		{ Name = "Enabled", Value = 2 },
	},
	["RenderingTestComparisonMethod"] = {
		{ Name = "psnr", Value = 0 },
		{ Name = "diff", Value = 1 },
	},
	["ReplicateInstanceDestroySetting"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Disabled", Value = 1 },
		{ Name = "Enabled", Value = 2 },
	},
	["ResamplerMode"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Pixelated", Value = 1 },
	},
	["ReservedHighlightId"] = {
		{ Name = "Standard", Value = 0 },
		{ Name = "Active", Value = 131072 },
		{ Name = "Hover", Value = 262144 },
		{ Name = "Selection", Value = 524288 },
		{ Name = "NegatedPart", Value = 1048576 },
	},
	["RestPose"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "RotationsReset", Value = 1 },
		{ Name = "Custom", Value = 2 },
	},
	["RestPoseModel"] = {
		{ Name = "FromRigInACE", Value = 0 },
		{ Name = "FromRigInFile", Value = 1 },
	},
	["ReturnKeyType"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Done", Value = 1 },
		{ Name = "Go", Value = 2 },
		{ Name = "Next", Value = 3 },
		{ Name = "Search", Value = 4 },
		{ Name = "Send", Value = 5 },
	},
	["ReverbType"] = {
		{ Name = "NoReverb", Value = 0 },
		{ Name = "GenericReverb", Value = 1 },
		{ Name = "PaddedCell", Value = 2 },
		{ Name = "Room", Value = 3 },
		{ Name = "Bathroom", Value = 4 },
		{ Name = "LivingRoom", Value = 5 },
		{ Name = "StoneRoom", Value = 6 },
		{ Name = "Auditorium", Value = 7 },
		{ Name = "ConcertHall", Value = 8 },
		{ Name = "Cave", Value = 9 },
		{ Name = "Arena", Value = 10 },
		{ Name = "Hangar", Value = 11 },
		{ Name = "CarpettedHallway", Value = 12 },
		{ Name = "Hallway", Value = 13 },
		{ Name = "StoneCorridor", Value = 14 },
		{ Name = "Alley", Value = 15 },
		{ Name = "Forest", Value = 16 },
		{ Name = "City", Value = 17 },
		{ Name = "Mountains", Value = 18 },
		{ Name = "Quarry", Value = 19 },
		{ Name = "Plain", Value = 20 },
		{ Name = "ParkingLot", Value = 21 },
		{ Name = "SewerPipe", Value = 22 },
		{ Name = "UnderWater", Value = 23 },
	},
	["ReviewableContentState"] = {
		{ Name = "Pending", Value = 0 },
		{ Name = "Completed", Value = 1 },
		{ Name = "Failed", Value = 2 },
	},
	["RibbonTool"] = {
		{ Name = "Select", Value = 0 },
		{ Name = "Scale", Value = 1 },
		{ Name = "Rotate", Value = 2 },
		{ Name = "Move", Value = 3 },
		{ Name = "Transform", Value = 4 },
		{ Name = "ColorPicker", Value = 5 },
		{ Name = "MaterialPicker", Value = 6 },
		{ Name = "Group", Value = 7 },
		{ Name = "Ungroup", Value = 8 },
		{ Name = "None", Value = 9 },
		{ Name = "PivotEditor", Value = 10 },
	},
	["RigLabel"] = {
		{ Name = "Invalid", Value = 0 },
		{ Name = "Root", Value = 2 },
		{ Name = "LeftHip", Value = 3 },
		{ Name = "LeftKnee", Value = 4 },
		{ Name = "LeftAnkle", Value = 5 },
		{ Name = "RightHip", Value = 7 },
		{ Name = "RightKnee", Value = 8 },
		{ Name = "RightAnkle", Value = 9 },
		{ Name = "Waist", Value = 11 },
		{ Name = "LeftShoulder", Value = 12 },
		{ Name = "LeftElbow", Value = 13 },
		{ Name = "LeftWrist", Value = 14 },
		{ Name = "RightShoulder", Value = 16 },
		{ Name = "RightElbow", Value = 17 },
		{ Name = "RightWrist", Value = 18 },
		{ Name = "Neck", Value = 20 },
		{ Name = "Pelvis", Value = 23 },
		{ Name = "Chest", Value = 24 },
		{ Name = "HeadBase", Value = 25 },
		{ Name = "LeftClavicle", Value = 26 },
		{ Name = "RightClavicle", Value = 27 },
		{ Name = "LeftToes", Value = 28 },
		{ Name = "RightToes", Value = 29 },
		{ Name = "Thumb1", Value = 30 },
		{ Name = "Thumb2", Value = 31 },
		{ Name = "Thumb3", Value = 32 },
		{ Name = "Index1", Value = 33 },
		{ Name = "Index2", Value = 34 },
		{ Name = "Index3", Value = 35 },
		{ Name = "Middle1", Value = 36 },
		{ Name = "Middle2", Value = 37 },
		{ Name = "Middle3", Value = 38 },
		{ Name = "Ring1", Value = 39 },
		{ Name = "Ring2", Value = 40 },
		{ Name = "Ring3", Value = 41 },
		{ Name = "Pinky1", Value = 42 },
		{ Name = "Pinky2", Value = 43 },
		{ Name = "Pinky3", Value = 44 },
	},
	["RigScale"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Rthro", Value = 1 },
		{ Name = "RthroNarrow", Value = 2 },
	},
	["RigType"] = {
		{ Name = "R15", Value = 0 },
		{ Name = "CustomHumanoid", Value = 1 },
		{ Name = "Custom", Value = 2 },
		{ Name = "None", Value = 3 },
	},
	["RollOffMode"] = {
		{ Name = "Inverse", Value = 0 },
		{ Name = "Linear", Value = 1 },
		{ Name = "LinearSquare", Value = 2 },
		{ Name = "InverseTapered", Value = 3 },
	},
	["RolloutState"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Disabled", Value = 1 },
		{ Name = "Enabled", Value = 2 },
	},
	["RotationOrder"] = {
		{ Name = "XYZ", Value = 0 },
		{ Name = "XZY", Value = 1 },
		{ Name = "YZX", Value = 2 },
		{ Name = "YXZ", Value = 3 },
		{ Name = "ZXY", Value = 4 },
		{ Name = "ZYX", Value = 5 },
	},
	["RotationType"] = {
		{ Name = "MovementRelative", Value = 0 },
		{ Name = "CameraRelative", Value = 1 },
	},
	["RsvpStatus"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Going", Value = 1 },
		{ Name = "NotGoing", Value = 2 },
	},
	["RtlTextSupport"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Disabled", Value = 1 },
		{ Name = "Enabled", Value = 2 },
	},
	["RunContext"] = {
		{ Name = "Legacy", Value = 0 },
		{ Name = "Server", Value = 1 },
		{ Name = "Client", Value = 2 },
		{ Name = "Plugin", Value = 3 },
	},
	["RunState"] = {
		{ Name = "Stopped", Value = 0 },
		{ Name = "Running", Value = 1 },
		{ Name = "Paused", Value = 2 },
	},
	["RuntimeUndoBehavior"] = {
		{ Name = "Aggregate", Value = 0 },
		{ Name = "Snapshot", Value = 1 },
		{ Name = "Hybrid", Value = 2 },
	},
	["SafeAreaCompatibility"] = {
		{ Name = "None", Value = 0 },
		{ Name = "FullscreenExtension", Value = 1 },
	},
	["SalesTypeFilter"] = {
		{ Name = "All", Value = 1 },
		{ Name = "Collectibles", Value = 2 },
		{ Name = "Premium", Value = 3 },
		{ Name = "TimedOptions", Value = 4 },
	},
	["SandboxedInstanceMode"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Experimental", Value = 1 },
	},
	["SaveAvatarThumbnailCustomizationFailure"] = {
		{ Name = "BadThumbnailType", Value = 1 },
		{ Name = "BadYRotDeg", Value = 2 },
		{ Name = "BadFieldOfViewDeg", Value = 3 },
		{ Name = "BadDistanceScale", Value = 4 },
		{ Name = "Other", Value = 5 },
		{ Name = "Throttled", Value = 6 },
	},
	["SaveFilter"] = {
		{ Name = "SaveWorld", Value = 0 },
		{ Name = "SaveGame", Value = 1 },
		{ Name = "SaveAll", Value = 2 },
	},
	["SavedQualitySetting"] = {
		{ Name = "Automatic", Value = 0 },
		{ Name = "QualityLevel1", Value = 1 },
		{ Name = "QualityLevel2", Value = 2 },
		{ Name = "QualityLevel3", Value = 3 },
		{ Name = "QualityLevel4", Value = 4 },
		{ Name = "QualityLevel5", Value = 5 },
		{ Name = "QualityLevel6", Value = 6 },
		{ Name = "QualityLevel7", Value = 7 },
		{ Name = "QualityLevel8", Value = 8 },
		{ Name = "QualityLevel9", Value = 9 },
		{ Name = "QualityLevel10", Value = 10 },
	},
	["ScaleType"] = {
		{ Name = "Stretch", Value = 0 },
		{ Name = "Slice", Value = 1 },
		{ Name = "Tile", Value = 2 },
		{ Name = "Fit", Value = 3 },
		{ Name = "Crop", Value = 4 },
	},
	["ScopeCheckResult"] = {
		{ Name = "ConsentAccepted", Value = 0 },
		{ Name = "InvalidScopes", Value = 1 },
		{ Name = "Timeout", Value = 2 },
		{ Name = "NoUserInput", Value = 3 },
		{ Name = "BackendError", Value = 4 },
		{ Name = "UnexpectedError", Value = 5 },
		{ Name = "InvalidArgument", Value = 6 },
		{ Name = "ConsentDenied", Value = 7 },
	},
	["ScreenInsets"] = {
		{ Name = "None", Value = 0 },
		{ Name = "DeviceSafeInsets", Value = 1 },
		{ Name = "CoreUISafeInsets", Value = 2 },
		{ Name = "TopbarSafeInsets", Value = 3 },
	},
	["ScreenOrientation"] = {
		{ Name = "LandscapeLeft", Value = 0 },
		{ Name = "LandscapeRight", Value = 1 },
		{ Name = "LandscapeSensor", Value = 2 },
		{ Name = "Portrait", Value = 3 },
		{ Name = "Sensor", Value = 4 },
	},
	["ScreenshotCaptureResult"] = {
		{ Name = "Success", Value = 0 },
		{ Name = "OtherError", Value = 1 },
		{ Name = "NoDeviceSupport", Value = 2 },
		{ Name = "NoSpaceOnDevice", Value = 3 },
	},
	["ScrollBarInset"] = {
		{ Name = "None", Value = 0 },
		{ Name = "ScrollBar", Value = 1 },
		{ Name = "Always", Value = 2 },
	},
	["ScrollingDirection"] = {
		{ Name = "X", Value = 1 },
		{ Name = "Y", Value = 2 },
		{ Name = "XY", Value = 4 },
	},
	["SecurityCapability"] = {
		{ Name = "RunClientScript", Value = 0 },
		{ Name = "RunServerScript", Value = 1 },
		{ Name = "AccessOutsideWrite", Value = 2 },
		{ Name = "AssetRequire", Value = 3 },
		{ Name = "LoadString", Value = 4 },
		{ Name = "ScriptGlobals", Value = 5 },
		{ Name = "CreateInstances", Value = 6 },
		{ Name = "Basic", Value = 7 },
		{ Name = "Audio", Value = 8 },
		{ Name = "DataStore", Value = 9 },
		{ Name = "Network", Value = 10 },
		{ Name = "Physics", Value = 11 },
		{ Name = "UI", Value = 12 },
		{ Name = "CSG", Value = 13 },
		{ Name = "Chat", Value = 14 },
		{ Name = "Animation", Value = 15 },
		{ Name = "Avatar", Value = 16 },
		{ Name = "Input", Value = 17 },
		{ Name = "Environment", Value = 18 },
		{ Name = "RemoteEvent", Value = 19 },
		{ Name = "LegacySound", Value = 20 },
		{ Name = "Players", Value = 21 },
		{ Name = "CapabilityControl", Value = 22 },
		{ Name = "Plugin", Value = 23 },
		{ Name = "LocalUser", Value = 24 },
		{ Name = "WritePlayer", Value = 25 },
		{ Name = "RobloxScript", Value = 26 },
		{ Name = "RobloxEngine", Value = 27 },
		{ Name = "Unassigned", Value = 28 },
		{ Name = "InternalTest", Value = 29 },
		{ Name = "PluginOrOpenCloud", Value = 30 },
		{ Name = "Assistant", Value = 31 },
		{ Name = "RemoteCommand", Value = 32 },
		{ Name = "AssetRead", Value = 33 },
		{ Name = "AssetManagement", Value = 34 },
		{ Name = "DynamicGeneration", Value = 35 },
		{ Name = "PlatformAvatarEditing", Value = 36 },
		{ Name = "AssetCreateUpdate", Value = 37 },
		{ Name = "Capture", Value = 38 },
		{ Name = "SensitiveInput", Value = 39 },
		{ Name = "Monetization", Value = 40 },
		{ Name = "LoadOwnedAsset", Value = 41 },
		{ Name = "Social", Value = 42 },
		{ Name = "ServerCommunication", Value = 43 },
		{ Name = "Logging", Value = 44 },
		{ Name = "PromptExternalPurchase", Value = 45 },
		{ Name = "Groups", Value = 46 },
		{ Name = "Teleport", Value = 47 },
		{ Name = "Consequences", Value = 48 },
		{ Name = "Material", Value = 49 },
		{ Name = "AvatarBehavior", Value = 50 },
		{ Name = "AvatarAppearance", Value = 51 },
		{ Name = "LoadUnownedAsset", Value = 52 },
	},
	["SelectionBehavior"] = {
		{ Name = "Escape", Value = 0 },
		{ Name = "Stop", Value = 1 },
	},
	["SelectionRenderMode"] = {
		{ Name = "Outlines", Value = 0 },
		{ Name = "BoundingBoxes", Value = 1 },
		{ Name = "Both", Value = 2 },
	},
	["SelfViewPosition"] = {
		{ Name = "LastPosition", Value = 0 },
		{ Name = "TopLeft", Value = 1 },
		{ Name = "TopRight", Value = 2 },
		{ Name = "BottomLeft", Value = 3 },
		{ Name = "BottomRight", Value = 4 },
	},
	["SensorMode"] = {
		{ Name = "Floor", Value = 0 },
		{ Name = "Ladder", Value = 1 },
	},
	["SensorUpdateType"] = {
		{ Name = "OnRead", Value = 0 },
		{ Name = "Manual", Value = 1 },
	},
	["ServerLiveEditingMode"] = {
		{ Name = "Uninitialized", Value = 0 },
		{ Name = "Enabled", Value = 1 },
		{ Name = "Disabled", Value = 2 },
	},
	["ServiceVisibility"] = {
		{ Name = "Always", Value = 0 },
		{ Name = "Off", Value = 1 },
		{ Name = "WithChildren", Value = 2 },
	},
	["Severity"] = {
		{ Name = "Error", Value = 1 },
		{ Name = "Warning", Value = 2 },
		{ Name = "Information", Value = 3 },
		{ Name = "Hint", Value = 4 },
	},
	["ShowAdResult"] = {
		{ Name = "ShowCompleted", Value = 1 },
		{ Name = "AdNotReady", Value = 2 },
		{ Name = "AdAlreadyShowing", Value = 3 },
		{ Name = "InternalError", Value = 4 },
		{ Name = "ShowInterrupted", Value = 5 },
		{ Name = "InsufficientMemory", Value = 6 },
	},
	["SignalBehavior"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Immediate", Value = 1 },
		{ Name = "Deferred", Value = 2 },
		{ Name = "AncestryDeferred", Value = 3 },
	},
	["SizeConstraint"] = {
		{ Name = "RelativeXY", Value = 0 },
		{ Name = "RelativeXX", Value = 1 },
		{ Name = "RelativeYY", Value = 2 },
	},
	["SolidPrimitiveType"] = {
		{ Name = "Capsule", Value = 5 },
		{ Name = "Cone", Value = 6 },
	},
	["SolverConvergenceMetricType"] = {
		{ Name = "IterationBased", Value = 0 },
		{ Name = "AlgorithmAgnostic", Value = 1 },
	},
	["SolverConvergenceVisualizationMode"] = {
		{ Name = "Disabled", Value = 0 },
		{ Name = "PerIsland", Value = 1 },
		{ Name = "PerEdge", Value = 2 },
	},
	["SortDirection"] = {
		{ Name = "Ascending", Value = 0 },
		{ Name = "Descending", Value = 1 },
	},
	["SortOrder"] = {
		{ Name = "Name", Value = 0 },
		{ Name = "Custom", Value = 1 },
		{ Name = "LayoutOrder", Value = 2 },
	},
	["SpecialKey"] = {
		{ Name = "Insert", Value = 0 },
		{ Name = "Home", Value = 1 },
		{ Name = "End", Value = 2 },
		{ Name = "PageUp", Value = 3 },
		{ Name = "PageDown", Value = 4 },
		{ Name = "ChatHotkey", Value = 5 },
	},
	["StartCorner"] = {
		{ Name = "TopLeft", Value = 0 },
		{ Name = "TopRight", Value = 1 },
		{ Name = "BottomLeft", Value = 2 },
		{ Name = "BottomRight", Value = 3 },
	},
	["StateObjectFieldType"] = {
		{ Name = "Boolean", Value = 0 },
		{ Name = "CFrame", Value = 1 },
		{ Name = "Color3", Value = 2 },
		{ Name = "Float", Value = 3 },
		{ Name = "Instance", Value = 4 },
		{ Name = "Random", Value = 5 },
		{ Name = "Vector2", Value = 6 },
		{ Name = "Vector3", Value = 7 },
		{ Name = "INVALID", Value = 8 },
	},
	["Status"] = {
		{ Name = "Poison", Value = 0 },
		{ Name = "Confusion", Value = 1 },
	},
	["StepFrequency"] = {
		{ Name = "Hz60", Value = 0 },
		{ Name = "Hz30", Value = 1 },
		{ Name = "Hz15", Value = 2 },
		{ Name = "Hz10", Value = 3 },
		{ Name = "Hz5", Value = 4 },
		{ Name = "Hz1", Value = 5 },
	},
	["StreamOutBehavior"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "LowMemory", Value = 1 },
		{ Name = "Opportunistic", Value = 2 },
	},
	["StreamingIntegrityMode"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Disabled", Value = 1 },
		{ Name = "MinimumRadiusPause", Value = 2 },
		{ Name = "PauseOutsideLoadedArea", Value = 3 },
	},
	["StreamingPauseMode"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Disabled", Value = 1 },
		{ Name = "ClientPhysicsPause", Value = 2 },
	},
	["StrokeSizingMode"] = {
		{ Name = "FixedSize", Value = 0 },
		{ Name = "ScaledSize", Value = 1 },
	},
	["StudioCloseMode"] = {
		{ Name = "None", Value = 0 },
		{ Name = "CloseStudio", Value = 1 },
		{ Name = "CloseDoc", Value = 2 },
		{ Name = "LogOut", Value = 3 },
	},
	["StudioDataModelType"] = {
		{ Name = "Edit", Value = 0 },
		{ Name = "PlayClient", Value = 1 },
		{ Name = "PlayServer", Value = 2 },
		{ Name = "Standalone", Value = 3 },
		{ Name = "None", Value = 4 },
	},
	["StudioPlaceUpdateFailureReason"] = {
		{ Name = "Other", Value = 0 },
		{ Name = "TeamCreateConflict", Value = 1 },
	},
	["StudioScriptEditorColorCategories"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Operator", Value = 1 },
		{ Name = "Number", Value = 2 },
		{ Name = "String", Value = 3 },
		{ Name = "Comment", Value = 4 },
		{ Name = "Keyword", Value = 5 },
		{ Name = "Builtin", Value = 6 },
		{ Name = "Method", Value = 7 },
		{ Name = "Property", Value = 8 },
		{ Name = "Nil", Value = 9 },
		{ Name = "Bool", Value = 10 },
		{ Name = "Function", Value = 11 },
		{ Name = "Local", Value = 12 },
		{ Name = "Self", Value = 13 },
		{ Name = "LuauKeyword", Value = 14 },
		{ Name = "FunctionName", Value = 15 },
		{ Name = "TODO", Value = 16 },
		{ Name = "Background", Value = 17 },
		{ Name = "SelectionText", Value = 18 },
		{ Name = "SelectionBackground", Value = 19 },
		{ Name = "FindSelectionBackground", Value = 20 },
		{ Name = "MatchingWordBackground", Value = 21 },
		{ Name = "Warning", Value = 22 },
		{ Name = "Error", Value = 23 },
		{ Name = "Info", Value = 24 },
		{ Name = "Hint", Value = 25 },
		{ Name = "Whitespace", Value = 26 },
		{ Name = "ActiveLine", Value = 27 },
		{ Name = "DebuggerCurrentLine", Value = 28 },
		{ Name = "DebuggerErrorLine", Value = 29 },
		{ Name = "Ruler", Value = 30 },
		{ Name = "Bracket", Value = 31 },
		{ Name = "Type", Value = 32 },
		{ Name = "MenuPrimaryText", Value = 33 },
		{ Name = "MenuSecondaryText", Value = 34 },
		{ Name = "MenuSelectedText", Value = 35 },
		{ Name = "MenuBackground", Value = 36 },
		{ Name = "MenuSelectedBackground", Value = 37 },
		{ Name = "MenuScrollbarBackground", Value = 38 },
		{ Name = "MenuScrollbarHandle", Value = 39 },
		{ Name = "MenuBorder", Value = 40 },
		{ Name = "DocViewCodeBackground", Value = 41 },
		{ Name = "AICOOverlayText", Value = 42 },
		{ Name = "AICOOverlayButtonBackground", Value = 43 },
		{ Name = "AICOOverlayButtonBackgroundHover", Value = 44 },
		{ Name = "AICOOverlayButtonBackgroundPressed", Value = 45 },
		{ Name = "IndentationRuler", Value = 46 },
	},
	["StudioScriptEditorColorPresets"] = {
		{ Name = "RobloxDefault", Value = 0 },
		{ Name = "Extra1", Value = 1 },
		{ Name = "Extra2", Value = 2 },
		{ Name = "Custom", Value = 3 },
	},
	["StudioStyleGuideColor"] = {
		{ Name = "MainBackground", Value = 0 },
		{ Name = "Titlebar", Value = 1 },
		{ Name = "Dropdown", Value = 2 },
		{ Name = "Tooltip", Value = 3 },
		{ Name = "Notification", Value = 4 },
		{ Name = "ScrollBar", Value = 5 },
		{ Name = "ScrollBarBackground", Value = 6 },
		{ Name = "TabBar", Value = 7 },
		{ Name = "Tab", Value = 8 },
		{ Name = "FilterButtonDefault", Value = 9 },
		{ Name = "FilterButtonHover", Value = 10 },
		{ Name = "FilterButtonChecked", Value = 11 },
		{ Name = "FilterButtonAccent", Value = 12 },
		{ Name = "FilterButtonBorder", Value = 13 },
		{ Name = "FilterButtonBorderAlt", Value = 14 },
		{ Name = "RibbonTab", Value = 15 },
		{ Name = "RibbonTabTopBar", Value = 16 },
		{ Name = "Button", Value = 17 },
		{ Name = "MainButton", Value = 18 },
		{ Name = "RibbonButton", Value = 19 },
		{ Name = "ViewPortBackground", Value = 20 },
		{ Name = "InputFieldBackground", Value = 21 },
		{ Name = "Item", Value = 22 },
		{ Name = "TableItem", Value = 23 },
		{ Name = "CategoryItem", Value = 24 },
		{ Name = "GameSettingsTableItem", Value = 25 },
		{ Name = "GameSettingsTooltip", Value = 26 },
		{ Name = "EmulatorBar", Value = 27 },
		{ Name = "EmulatorDropDown", Value = 28 },
		{ Name = "ColorPickerFrame", Value = 29 },
		{ Name = "CurrentMarker", Value = 30 },
		{ Name = "Border", Value = 31 },
		{ Name = "DropShadow", Value = 32 },
		{ Name = "Shadow", Value = 33 },
		{ Name = "Light", Value = 34 },
		{ Name = "Dark", Value = 35 },
		{ Name = "Mid", Value = 36 },
		{ Name = "MainText", Value = 37 },
		{ Name = "SubText", Value = 38 },
		{ Name = "TitlebarText", Value = 39 },
		{ Name = "BrightText", Value = 40 },
		{ Name = "DimmedText", Value = 41 },
		{ Name = "LinkText", Value = 42 },
		{ Name = "WarningText", Value = 43 },
		{ Name = "ErrorText", Value = 44 },
		{ Name = "InfoText", Value = 45 },
		{ Name = "SensitiveText", Value = 46 },
		{ Name = "ScriptSideWidget", Value = 47 },
		{ Name = "ScriptBackground", Value = 48 },
		{ Name = "ScriptText", Value = 49 },
		{ Name = "ScriptSelectionText", Value = 50 },
		{ Name = "ScriptSelectionBackground", Value = 51 },
		{ Name = "ScriptFindSelectionBackground", Value = 52 },
		{ Name = "ScriptMatchingWordSelectionBackground", Value = 53 },
		{ Name = "ScriptOperator", Value = 54 },
		{ Name = "ScriptNumber", Value = 55 },
		{ Name = "ScriptString", Value = 56 },
		{ Name = "ScriptComment", Value = 57 },
		{ Name = "ScriptKeyword", Value = 58 },
		{ Name = "ScriptBuiltInFunction", Value = 59 },
		{ Name = "ScriptWarning", Value = 60 },
		{ Name = "ScriptError", Value = 61 },
		{ Name = "ScriptInformation", Value = 62 },
		{ Name = "ScriptHint", Value = 63 },
		{ Name = "ScriptWhitespace", Value = 64 },
		{ Name = "ScriptRuler", Value = 65 },
		{ Name = "DocViewCodeBackground", Value = 66 },
		{ Name = "DebuggerCurrentLine", Value = 67 },
		{ Name = "DebuggerErrorLine", Value = 68 },
		{ Name = "DiffFilePathText", Value = 69 },
		{ Name = "DiffTextHunkInfo", Value = 70 },
		{ Name = "DiffTextNoChange", Value = 71 },
		{ Name = "DiffTextAddition", Value = 72 },
		{ Name = "DiffTextDeletion", Value = 73 },
		{ Name = "DiffTextSeparatorBackground", Value = 74 },
		{ Name = "DiffTextNoChangeBackground", Value = 75 },
		{ Name = "DiffTextAdditionBackground", Value = 76 },
		{ Name = "DiffTextDeletionBackground", Value = 77 },
		{ Name = "DiffLineNum", Value = 78 },
		{ Name = "DiffLineNumSeparatorBackground", Value = 79 },
		{ Name = "DiffLineNumNoChangeBackground", Value = 80 },
		{ Name = "DiffLineNumAdditionBackground", Value = 81 },
		{ Name = "DiffLineNumDeletionBackground", Value = 82 },
		{ Name = "DiffFilePathBackground", Value = 83 },
		{ Name = "DiffFilePathBorder", Value = 84 },
		{ Name = "ChatIncomingBgColor", Value = 85 },
		{ Name = "ChatIncomingTextColor", Value = 86 },
		{ Name = "ChatOutgoingBgColor", Value = 87 },
		{ Name = "ChatOutgoingTextColor", Value = 88 },
		{ Name = "ChatModeratedMessageColor", Value = 89 },
		{ Name = "Separator", Value = 90 },
		{ Name = "ButtonBorder", Value = 91 },
		{ Name = "ButtonText", Value = 92 },
		{ Name = "InputFieldBorder", Value = 93 },
		{ Name = "CheckedFieldBackground", Value = 94 },
		{ Name = "CheckedFieldBorder", Value = 95 },
		{ Name = "CheckedFieldIndicator", Value = 96 },
		{ Name = "HeaderSection", Value = 97 },
		{ Name = "Midlight", Value = 98 },
		{ Name = "StatusBar", Value = 99 },
		{ Name = "DialogButton", Value = 100 },
		{ Name = "DialogButtonText", Value = 101 },
		{ Name = "DialogButtonBorder", Value = 102 },
		{ Name = "DialogMainButton", Value = 103 },
		{ Name = "DialogMainButtonText", Value = 104 },
		{ Name = "InfoBarWarningBackground", Value = 105 },
		{ Name = "InfoBarWarningText", Value = 106 },
		{ Name = "ScriptEditorCurrentLine", Value = 107 },
		{ Name = "ScriptMethod", Value = 108 },
		{ Name = "ScriptProperty", Value = 109 },
		{ Name = "ScriptNil", Value = 110 },
		{ Name = "ScriptBool", Value = 111 },
		{ Name = "ScriptFunction", Value = 112 },
		{ Name = "ScriptLocal", Value = 113 },
		{ Name = "ScriptSelf", Value = 114 },
		{ Name = "ScriptLuauKeyword", Value = 115 },
		{ Name = "ScriptFunctionName", Value = 116 },
		{ Name = "ScriptTodo", Value = 117 },
		{ Name = "ScriptBracket", Value = 118 },
		{ Name = "AttributeCog", Value = 119 },
		{ Name = "AICOOverlayText", Value = 128 },
		{ Name = "AICOOverlayButtonBackground", Value = 129 },
		{ Name = "AICOOverlayButtonBackgroundHover", Value = 130 },
		{ Name = "AICOOverlayButtonBackgroundPressed", Value = 131 },
		{ Name = "OnboardingCover", Value = 132 },
		{ Name = "OnboardingHighlight", Value = 133 },
		{ Name = "OnboardingShadow", Value = 134 },
		{ Name = "BreakpointMarker", Value = 136 },
		{ Name = "DiffLineNumHover", Value = 137 },
		{ Name = "DiffLineNumSeparatorBackgroundHover", Value = 138 },
	},
	["StudioStyleGuideModifier"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Selected", Value = 1 },
		{ Name = "Pressed", Value = 2 },
		{ Name = "Disabled", Value = 3 },
		{ Name = "Hover", Value = 4 },
	},
	["Style"] = {
		{ Name = "AlternatingSupports", Value = 0 },
		{ Name = "BridgeStyleSupports", Value = 1 },
		{ Name = "NoSupports", Value = 2 },
	},
	["SubscriptionExpirationReason"] = {
		{ Name = "ProductInactive", Value = 0 },
		{ Name = "ProductDeleted", Value = 1 },
		{ Name = "SubscriberCancelled", Value = 2 },
		{ Name = "SubscriberRefunded", Value = 3 },
		{ Name = "Lapsed", Value = 4 },
	},
	["SubscriptionPaymentStatus"] = {
		{ Name = "Paid", Value = 0 },
		{ Name = "Refunded", Value = 1 },
	},
	["SubscriptionPeriod"] = {
		{ Name = "Month", Value = 0 },
	},
	["SubscriptionState"] = {
		{ Name = "NeverSubscribed", Value = 0 },
		{ Name = "SubscribedWillRenew", Value = 1 },
		{ Name = "SubscribedWillNotRenew", Value = 2 },
		{ Name = "SubscribedRenewalPaymentPending", Value = 3 },
		{ Name = "Expired", Value = 4 },
	},
	["SurfaceConstraint"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Hinge", Value = 1 },
		{ Name = "SteppingMotor", Value = 2 },
		{ Name = "Motor", Value = 3 },
	},
	["SurfaceGuiShape"] = {
		{ Name = "Flat", Value = 0 },
		{ Name = "CurvedHorizontally", Value = 1 },
	},
	["SurfaceGuiSizingMode"] = {
		{ Name = "FixedSize", Value = 0 },
		{ Name = "PixelsPerStud", Value = 1 },
	},
	["SurfaceType"] = {
		{ Name = "Smooth", Value = 0 },
		{ Name = "Glue", Value = 1 },
		{ Name = "Weld", Value = 2 },
		{ Name = "Studs", Value = 3 },
		{ Name = "Inlet", Value = 4 },
		{ Name = "Universal", Value = 5 },
		{ Name = "Hinge", Value = 6 },
		{ Name = "Motor", Value = 7 },
		{ Name = "SteppingMotor", Value = 8 },
		{ Name = "SmoothNoOutlines", Value = 10 },
	},
	["SwipeDirection"] = {
		{ Name = "Right", Value = 0 },
		{ Name = "Left", Value = 1 },
		{ Name = "Up", Value = 2 },
		{ Name = "Down", Value = 3 },
		{ Name = "None", Value = 4 },
	},
	["SystemThemeValue"] = {
		{ Name = "error", Value = 0 },
		{ Name = "light", Value = 1 },
		{ Name = "dark", Value = 2 },
		{ Name = "systemLight", Value = 3 },
		{ Name = "systemDark", Value = 4 },
	},
	["TableMajorAxis"] = {
		{ Name = "RowMajor", Value = 0 },
		{ Name = "ColumnMajor", Value = 1 },
	},
	["TeamCreateErrorState"] = {
		{ Name = "PlaceSizeTooLarge", Value = 0 },
		{ Name = "PlaceSizeApproachingLimit", Value = 1 },
		{ Name = "PlaceUploadFailing", Value = 2 },
		{ Name = "NoError", Value = 3 },
	},
	["Technology"] = {
		{ Name = "Legacy", Value = 0 },
		{ Name = "Voxel", Value = 1 },
		{ Name = "Compatibility", Value = 2 },
		{ Name = "ShadowMap", Value = 3 },
		{ Name = "Future", Value = 4 },
		{ Name = "Unified", Value = 5 },
	},
	["TelemetryBackend"] = {
		{ Name = "UNSPECIFIED", Value = 0 },
		{ Name = "EventIngest", Value = 1 },
		{ Name = "Points", Value = 2 },
		{ Name = "Teletune", Value = 3 },
		{ Name = "EphemeralCounter", Value = 4 },
		{ Name = "EphemeralStat", Value = 5 },
		{ Name = "Counter", Value = 6 },
		{ Name = "Stat", Value = 7 },
	},
	["TelemetryStandardizedField"] = {
		{ Name = "AddDatacenterId", Value = 0 },
		{ Name = "AddPlaceId", Value = 1 },
		{ Name = "AddUniverseId", Value = 2 },
		{ Name = "AddPlaceInstanceId", Value = 3 },
		{ Name = "AddPlaySessionId", Value = 4 },
		{ Name = "AddCurrentContextName", Value = 5 },
		{ Name = "AddOsInfo", Value = 6 },
		{ Name = "AddArchitectureInfo", Value = 7 },
		{ Name = "AddCpuInfo", Value = 8 },
		{ Name = "AddMemoryInfo", Value = 9 },
		{ Name = "AddSessionInfo", Value = 10 },
	},
	["TeleportMethod"] = {
		{ Name = "TeleportToSpawnByName", Value = 0 },
		{ Name = "TeleportToPlaceInstance", Value = 1 },
		{ Name = "TeleportToPrivateServer", Value = 2 },
		{ Name = "TeleportPartyAsync", Value = 3 },
		{ Name = "TeleportToVIPServer", Value = 4 },
		{ Name = "TeleportToInstanceBack", Value = 5 },
		{ Name = "TeleportUnknown", Value = 6 },
	},
	["TeleportResult"] = {
		{ Name = "Success", Value = 0 },
		{ Name = "Failure", Value = 1 },
		{ Name = "GameNotFound", Value = 2 },
		{ Name = "GameEnded", Value = 3 },
		{ Name = "GameFull", Value = 4 },
		{ Name = "Unauthorized", Value = 5 },
		{ Name = "Flooded", Value = 6 },
		{ Name = "IsTeleporting", Value = 7 },
	},
	["TeleportState"] = {
		{ Name = "RequestedFromServer", Value = 0 },
		{ Name = "Started", Value = 1 },
		{ Name = "WaitingForServer", Value = 2 },
		{ Name = "Failed", Value = 3 },
		{ Name = "InProgress", Value = 4 },
	},
	["TeleportType"] = {
		{ Name = "ToPlace", Value = 0 },
		{ Name = "ToInstance", Value = 1 },
		{ Name = "ToReservedServer", Value = 2 },
		{ Name = "ToVIPServer", Value = 3 },
		{ Name = "ToInstanceBack", Value = 4 },
	},
	["TerrainAcquisitionMethod"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Legacy", Value = 1 },
		{ Name = "Template", Value = 2 },
		{ Name = "Generate", Value = 3 },
		{ Name = "Import", Value = 4 },
		{ Name = "Convert", Value = 5 },
		{ Name = "EditAddTool", Value = 6 },
		{ Name = "EditSeaLevelTool", Value = 7 },
		{ Name = "EditReplaceTool", Value = 8 },
		{ Name = "RegionFillTool", Value = 9 },
		{ Name = "RegionPasteTool", Value = 10 },
		{ Name = "Other", Value = 11 },
	},
	["TerrainFace"] = {
		{ Name = "Top", Value = 0 },
		{ Name = "Side", Value = 1 },
		{ Name = "Bottom", Value = 2 },
	},
	["TerrainLiquidMergeOperation"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Source", Value = 1 },
		{ Name = "Union", Value = 2 },
		{ Name = "Difference", Value = 3 },
		{ Name = "Intersect", Value = 4 },
	},
	["TerrainSolidMergeOperation"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Paint", Value = 1 },
		{ Name = "Source", Value = 2 },
		{ Name = "Union", Value = 3 },
		{ Name = "Dig", Value = 4 },
		{ Name = "Difference", Value = 5 },
		{ Name = "Intersect", Value = 6 },
		{ Name = "Cut", Value = 7 },
		{ Name = "Place", Value = 8 },
	},
	["TextChatMessageStatus"] = {
		{ Name = "Unknown", Value = 1 },
		{ Name = "Success", Value = 2 },
		{ Name = "Sending", Value = 3 },
		{ Name = "TextFilterFailed", Value = 4 },
		{ Name = "Floodchecked", Value = 5 },
		{ Name = "InvalidPrivacySettings", Value = 6 },
		{ Name = "InvalidTextChannelPermissions", Value = 7 },
		{ Name = "MessageTooLong", Value = 8 },
		{ Name = "ModerationTimeout", Value = 9 },
	},
	["TextDirection"] = {
		{ Name = "Auto", Value = 0 },
		{ Name = "LeftToRight", Value = 1 },
		{ Name = "RightToLeft", Value = 2 },
	},
	["TextFilterContext"] = {
		{ Name = "PublicChat", Value = 1 },
		{ Name = "PrivateChat", Value = 2 },
	},
	["TextInputType"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "NoSuggestions", Value = 1 },
		{ Name = "Number", Value = 2 },
		{ Name = "Email", Value = 3 },
		{ Name = "Phone", Value = 4 },
		{ Name = "Password", Value = 5 },
		{ Name = "PasswordShown", Value = 6 },
		{ Name = "Username", Value = 7 },
		{ Name = "OneTimePassword", Value = 8 },
		{ Name = "NewPassword", Value = 9 },
		{ Name = "NewPasswordShown", Value = 10 },
	},
	["TextTruncate"] = {
		{ Name = "None", Value = 0 },
		{ Name = "AtEnd", Value = 1 },
		{ Name = "SplitWord", Value = 2 },
	},
	["TextXAlignment"] = {
		{ Name = "Left", Value = 0 },
		{ Name = "Right", Value = 1 },
		{ Name = "Center", Value = 2 },
	},
	["TextYAlignment"] = {
		{ Name = "Top", Value = 0 },
		{ Name = "Center", Value = 1 },
		{ Name = "Bottom", Value = 2 },
	},
	["TextureMode"] = {
		{ Name = "Stretch", Value = 0 },
		{ Name = "Wrap", Value = 1 },
		{ Name = "Static", Value = 2 },
	},
	["TextureQueryType"] = {
		{ Name = "NonHumanoid", Value = 0 },
		{ Name = "NonHumanoidOrphaned", Value = 1 },
		{ Name = "Humanoid", Value = 2 },
		{ Name = "HumanoidOrphaned", Value = 3 },
	},
	["ThreadPoolConfig"] = {
		{ Name = "Auto", Value = 0 },
		{ Name = "Threads1", Value = 1 },
		{ Name = "Threads2", Value = 2 },
		{ Name = "Threads3", Value = 3 },
		{ Name = "Threads4", Value = 4 },
		{ Name = "Threads8", Value = 8 },
		{ Name = "Threads16", Value = 16 },
		{ Name = "PerCore1", Value = 101 },
		{ Name = "PerCore2", Value = 102 },
		{ Name = "PerCore3", Value = 103 },
		{ Name = "PerCore4", Value = 104 },
	},
	["ThrottlingPriority"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "ElevatedOnServer", Value = 1 },
		{ Name = "Extreme", Value = 2 },
	},
	["ThumbnailSize"] = {
		{ Name = "Size48x48", Value = 0 },
		{ Name = "Size180x180", Value = 1 },
		{ Name = "Size420x420", Value = 2 },
		{ Name = "Size60x60", Value = 3 },
		{ Name = "Size100x100", Value = 4 },
		{ Name = "Size150x150", Value = 5 },
		{ Name = "Size352x352", Value = 6 },
	},
	["ThumbnailType"] = {
		{ Name = "HeadShot", Value = 0 },
		{ Name = "AvatarBust", Value = 1 },
		{ Name = "AvatarThumbnail", Value = 2 },
	},
	["TickCountSampleMethod"] = {
		{ Name = "Fast", Value = 0 },
		{ Name = "Benchmark", Value = 1 },
		{ Name = "Precise", Value = 2 },
	},
	["TonemapperPreset"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Retro", Value = 1 },
	},
	["TopBottom"] = {
		{ Name = "Top", Value = 0 },
		{ Name = "Center", Value = 1 },
		{ Name = "Bottom", Value = 2 },
	},
	["TouchCameraMovementMode"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Classic", Value = 1 },
		{ Name = "Follow", Value = 2 },
		{ Name = "Orbital", Value = 3 },
	},
	["TouchMovementMode"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Thumbstick", Value = 1 },
		{ Name = "DPad", Value = 2 },
		{ Name = "Thumbpad", Value = 3 },
		{ Name = "ClickToMove", Value = 4 },
		{ Name = "DynamicThumbstick", Value = 5 },
	},
	["TrackerError"] = {
		{ Name = "Ok", Value = 0 },
		{ Name = "NoService", Value = 1 },
		{ Name = "InitFailed", Value = 2 },
		{ Name = "NoVideo", Value = 3 },
		{ Name = "VideoError", Value = 4 },
		{ Name = "VideoNoPermission", Value = 5 },
		{ Name = "VideoUnsupported", Value = 6 },
		{ Name = "NoAudio", Value = 7 },
		{ Name = "AudioError", Value = 8 },
		{ Name = "AudioNoPermission", Value = 9 },
		{ Name = "UnsupportedDevice", Value = 10 },
	},
	["TrackerExtrapolationFlagMode"] = {
		{ Name = "ForceDisabled", Value = 0 },
		{ Name = "ExtrapolateFacsAndPose", Value = 1 },
		{ Name = "ExtrapolateFacsOnly", Value = 2 },
		{ Name = "Auto", Value = 3 },
	},
	["TrackerFaceTrackingStatus"] = {
		{ Name = "FaceTrackingSuccess", Value = 0 },
		{ Name = "FaceTrackingNoFaceFound", Value = 1 },
		{ Name = "FaceTrackingUnknown", Value = 2 },
		{ Name = "FaceTrackingLost", Value = 3 },
		{ Name = "FaceTrackingHasTrackingError", Value = 4 },
		{ Name = "FaceTrackingIsOccluded", Value = 5 },
		{ Name = "FaceTrackingUninitialized", Value = 6 },
	},
	["TrackerLodFlagMode"] = {
		{ Name = "ForceFalse", Value = 0 },
		{ Name = "ForceTrue", Value = 1 },
		{ Name = "Auto", Value = 2 },
	},
	["TrackerLodValueMode"] = {
		{ Name = "Force0", Value = 0 },
		{ Name = "Force1", Value = 1 },
		{ Name = "Auto", Value = 2 },
	},
	["TrackerMode"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Audio", Value = 1 },
		{ Name = "Video", Value = 2 },
		{ Name = "AudioVideo", Value = 3 },
	},
	["TrackerPromptEvent"] = {
		{ Name = "LODCameraRecommendDisable", Value = 0 },
	},
	["TrackerType"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Face", Value = 1 },
		{ Name = "UpperBody", Value = 2 },
	},
	["TriStateBoolean"] = {
		{ Name = "Unknown", Value = 0 },
		{ Name = "True", Value = 1 },
		{ Name = "False", Value = 2 },
	},
	["TweenStatus"] = {
		{ Name = "Canceled", Value = 0 },
		{ Name = "Completed", Value = 1 },
	},
	["UICaptureMode"] = {
		{ Name = "All", Value = 0 },
		{ Name = "None", Value = 1 },
	},
	["UIDragDetectorBoundingBehavior"] = {
		{ Name = "Automatic", Value = 0 },
		{ Name = "EntireObject", Value = 1 },
		{ Name = "HitPoint", Value = 2 },
	},
	["UIDragDetectorDragRelativity"] = {
		{ Name = "Absolute", Value = 0 },
		{ Name = "Relative", Value = 1 },
	},
	["UIDragDetectorDragSpace"] = {
		{ Name = "Parent", Value = 0 },
		{ Name = "LayerCollector", Value = 1 },
		{ Name = "Reference", Value = 2 },
	},
	["UIDragDetectorDragStyle"] = {
		{ Name = "TranslatePlane", Value = 0 },
		{ Name = "TranslateLine", Value = 1 },
		{ Name = "Rotate", Value = 2 },
		{ Name = "Scriptable", Value = 3 },
	},
	["UIDragDetectorResponseStyle"] = {
		{ Name = "Offset", Value = 0 },
		{ Name = "Scale", Value = 1 },
		{ Name = "CustomOffset", Value = 2 },
		{ Name = "CustomScale", Value = 3 },
	},
	["UIDragSpeedAxisMapping"] = {
		{ Name = "XY", Value = 0 },
		{ Name = "XX", Value = 1 },
		{ Name = "YY", Value = 2 },
	},
	["UIFlexAlignment"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Fill", Value = 1 },
		{ Name = "SpaceAround", Value = 2 },
		{ Name = "SpaceBetween", Value = 3 },
		{ Name = "SpaceEvenly", Value = 4 },
	},
	["UIFlexMode"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Grow", Value = 1 },
		{ Name = "Shrink", Value = 2 },
		{ Name = "Fill", Value = 3 },
		{ Name = "Custom", Value = 4 },
	},
	["UITheme"] = {
		{ Name = "Light", Value = 0 },
		{ Name = "Dark", Value = 1 },
	},
	["UiMessageType"] = {
		{ Name = "UiMessageError", Value = 0 },
		{ Name = "UiMessageInfo", Value = 1 },
	},
	["UpdateState"] = {
		{ Name = "UpdateNotAvailable", Value = 0 },
		{ Name = "UpdateAvailable", Value = 1 },
		{ Name = "UpdateInProgress", Value = 2 },
		{ Name = "UpdateReady", Value = 3 },
		{ Name = "UpdateFailed", Value = 4 },
	},
	["UploadCaptureResult"] = {
		{ Name = "Success", Value = 0 },
		{ Name = "NeedPermission", Value = 1 },
		{ Name = "CaptureModerated", Value = 2 },
		{ Name = "CaptureNotInGallery", Value = 3 },
		{ Name = "IneligibleCapture", Value = 4 },
		{ Name = "UploadQuotaReached", Value = 5 },
		{ Name = "UploadPending", Value = 6 },
		{ Name = "UploadFailed", Value = 7 },
	},
	["UsageContext"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Preview", Value = 1 },
	},
	["UserCFrame"] = {
		{ Name = "Head", Value = 0 },
		{ Name = "LeftHand", Value = 1 },
		{ Name = "RightHand", Value = 2 },
		{ Name = "Floor", Value = 3 },
	},
	["UserInputState"] = {
		{ Name = "Begin", Value = 0 },
		{ Name = "Change", Value = 1 },
		{ Name = "End", Value = 2 },
		{ Name = "Cancel", Value = 3 },
		{ Name = "None", Value = 4 },
	},
	["UserInputType"] = {
		{ Name = "MouseButton1", Value = 0 },
		{ Name = "MouseButton2", Value = 1 },
		{ Name = "MouseButton3", Value = 2 },
		{ Name = "MouseWheel", Value = 3 },
		{ Name = "MouseMovement", Value = 4 },
		{ Name = "Touch", Value = 7 },
		{ Name = "Keyboard", Value = 8 },
		{ Name = "Focus", Value = 9 },
		{ Name = "Accelerometer", Value = 10 },
		{ Name = "Gyro", Value = 11 },
		{ Name = "Gamepad1", Value = 12 },
		{ Name = "Gamepad2", Value = 13 },
		{ Name = "Gamepad3", Value = 14 },
		{ Name = "Gamepad4", Value = 15 },
		{ Name = "Gamepad5", Value = 16 },
		{ Name = "Gamepad6", Value = 17 },
		{ Name = "Gamepad7", Value = 18 },
		{ Name = "Gamepad8", Value = 19 },
		{ Name = "TextInput", Value = 20 },
		{ Name = "InputMethod", Value = 21 },
		{ Name = "None", Value = 22 },
	},
	["VRComfortSetting"] = {
		{ Name = "Comfort", Value = 0 },
		{ Name = "Normal", Value = 1 },
		{ Name = "Expert", Value = 2 },
		{ Name = "Custom", Value = 3 },
	},
	["VRControllerModelMode"] = {
		{ Name = "Disabled", Value = 0 },
		{ Name = "Transparent", Value = 1 },
	},
	["VRDeviceType"] = {
		{ Name = "Unknown", Value = 0 },
		{ Name = "OculusRift", Value = 1 },
		{ Name = "HTCVive", Value = 2 },
		{ Name = "ValveIndex", Value = 3 },
		{ Name = "OculusQuest", Value = 4 },
	},
	["VRLaserPointerMode"] = {
		{ Name = "Disabled", Value = 0 },
		{ Name = "Pointer", Value = 1 },
		{ Name = "DualPointer", Value = 2 },
	},
	["VRSafetyBubbleMode"] = {
		{ Name = "NoOne", Value = 0 },
		{ Name = "OnlyFriends", Value = 1 },
		{ Name = "Anyone", Value = 2 },
	},
	["VRScaling"] = {
		{ Name = "World", Value = 0 },
		{ Name = "Off", Value = 1 },
	},
	["VRSessionState"] = {
		{ Name = "Undefined", Value = 0 },
		{ Name = "Idle", Value = 1 },
		{ Name = "Visible", Value = 2 },
		{ Name = "Focused", Value = 3 },
		{ Name = "Stopping", Value = 4 },
	},
	["VRTouchpad"] = {
		{ Name = "Left", Value = 0 },
		{ Name = "Right", Value = 1 },
	},
	["VRTouchpadMode"] = {
		{ Name = "Touch", Value = 0 },
		{ Name = "VirtualThumbstick", Value = 1 },
		{ Name = "ABXY", Value = 2 },
	},
	["VelocityConstraintMode"] = {
		{ Name = "Line", Value = 0 },
		{ Name = "Plane", Value = 1 },
		{ Name = "Vector", Value = 2 },
	},
	["VerticalAlignment"] = {
		{ Name = "Center", Value = 0 },
		{ Name = "Top", Value = 1 },
		{ Name = "Bottom", Value = 2 },
	},
	["VerticalScrollBarPosition"] = {
		{ Name = "Right", Value = 0 },
		{ Name = "Left", Value = 1 },
	},
	["VibrationMotor"] = {
		{ Name = "Large", Value = 0 },
		{ Name = "Small", Value = 1 },
		{ Name = "LeftTrigger", Value = 2 },
		{ Name = "RightTrigger", Value = 3 },
		{ Name = "LeftHand", Value = 4 },
		{ Name = "RightHand", Value = 5 },
	},
	["VideoCaptureResult"] = {
		{ Name = "Success", Value = 0 },
		{ Name = "OtherError", Value = 1 },
		{ Name = "ScreenSizeChanged", Value = 2 },
		{ Name = "TimeLimitReached", Value = 3 },
	},
	["VideoCaptureStartedResult"] = {
		{ Name = "Success", Value = 0 },
		{ Name = "OtherError", Value = 1 },
		{ Name = "CapturingAlready", Value = 2 },
		{ Name = "NoDeviceSupport", Value = 3 },
		{ Name = "NoSpaceOnDevice", Value = 4 },
	},
	["VideoDeviceCaptureQuality"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Low", Value = 1 },
		{ Name = "Medium", Value = 2 },
		{ Name = "High", Value = 3 },
	},
	["VideoError"] = {
		{ Name = "Ok", Value = 0 },
		{ Name = "Eof", Value = 1 },
		{ Name = "EAgain", Value = 2 },
		{ Name = "BadParameter", Value = 3 },
		{ Name = "AllocFailed", Value = 4 },
		{ Name = "CodecInitFailed", Value = 5 },
		{ Name = "CodecCloseFailed", Value = 6 },
		{ Name = "DecodeFailed", Value = 7 },
		{ Name = "ParsingFailed", Value = 8 },
		{ Name = "Unsupported", Value = 9 },
		{ Name = "Generic", Value = 10 },
		{ Name = "DownloadFailed", Value = 11 },
		{ Name = "StreamNotFound", Value = 12 },
		{ Name = "EncodeFailed", Value = 13 },
		{ Name = "CreateFailed", Value = 14 },
		{ Name = "NoPermission", Value = 15 },
		{ Name = "NoService", Value = 16 },
		{ Name = "ReleaseFailed", Value = 17 },
		{ Name = "Unknown", Value = 18 },
	},
	["VideoSampleSize"] = {
		{ Name = "Small", Value = 0 },
		{ Name = "Medium", Value = 1 },
		{ Name = "Large", Value = 2 },
		{ Name = "Full", Value = 3 },
	},
	["ViewMode"] = {
		{ Name = "None", Value = 0 },
		{ Name = "GeometryComplexity", Value = 1 },
		{ Name = "Transparent", Value = 2 },
		{ Name = "Decal", Value = 3 },
	},
	["VirtualCursorMode"] = {
		{ Name = "Default", Value = 0 },
		{ Name = "Disabled", Value = 1 },
		{ Name = "Enabled", Value = 2 },
	},
	["VirtualInputMode"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Recording", Value = 1 },
		{ Name = "Playing", Value = 2 },
	},
	["VoiceChatDistanceAttenuationType"] = {
		{ Name = "Inverse", Value = 0 },
		{ Name = "Legacy", Value = 1 },
	},
	["VoiceChatState"] = {
		{ Name = "Idle", Value = 0 },
		{ Name = "Joining", Value = 1 },
		{ Name = "JoiningRetry", Value = 2 },
		{ Name = "Joined", Value = 3 },
		{ Name = "Leaving", Value = 4 },
		{ Name = "Ended", Value = 5 },
		{ Name = "Failed", Value = 6 },
	},
	["VoiceClientLeaveReasons"] = {
		{ Name = "Unknown", Value = 0 },
		{ Name = "ClientNetworkDisconnected", Value = 1 },
		{ Name = "PlayerLeft", Value = 2 },
		{ Name = "ClientShutdown", Value = 3 },
		{ Name = "PublishFailed", Value = 4 },
		{ Name = "RejoinReceived", Value = 5 },
		{ Name = "VoiceReboot", Value = 6 },
		{ Name = "ImguiDebugLeave", Value = 7 },
		{ Name = "LuaInitiated", Value = 8 },
	},
	["VoiceControlPath"] = {
		{ Name = "Publish", Value = 0 },
		{ Name = "Subscribe", Value = 1 },
		{ Name = "Join", Value = 2 },
	},
	["VoiceRccReconnectReason"] = {
		{ Name = "Unknown", Value = 0 },
		{ Name = "Migration", Value = 1 },
		{ Name = "CloseRoom", Value = 2 },
	},
	["VolumetricAudio"] = {
		{ Name = "Disabled", Value = 0 },
		{ Name = "Automatic", Value = 1 },
		{ Name = "Enabled", Value = 2 },
	},
	["WaterDirection"] = {
		{ Name = "NegX", Value = 0 },
		{ Name = "X", Value = 1 },
		{ Name = "NegY", Value = 2 },
		{ Name = "Y", Value = 3 },
		{ Name = "NegZ", Value = 4 },
		{ Name = "Z", Value = 5 },
	},
	["WaterForce"] = {
		{ Name = "None", Value = 0 },
		{ Name = "Small", Value = 1 },
		{ Name = "Medium", Value = 2 },
		{ Name = "Strong", Value = 3 },
		{ Name = "Max", Value = 4 },
	},
	["WebSocketState"] = {
		{ Name = "Connecting", Value = 0 },
		{ Name = "Open", Value = 1 },
		{ Name = "Closing", Value = 2 },
		{ Name = "Closed", Value = 3 },
	},
	["WebStreamClientState"] = {
		{ Name = "Connecting", Value = 0 },
		{ Name = "Open", Value = 1 },
		{ Name = "Error", Value = 2 },
		{ Name = "Closed", Value = 3 },
	},
	["WebStreamClientType"] = {
		{ Name = "SSE", Value = 0 },
		{ Name = "RawStream", Value = 1 },
		{ Name = "WebSocket", Value = 2 },
	},
	["WeldConstraintPreserve"] = {
		{ Name = "All", Value = 0 },
		{ Name = "None", Value = 1 },
		{ Name = "Touching", Value = 2 },
	},
	["WhisperChatPrivacyMode"] = {
		{ Name = "AllUsers", Value = 0 },
		{ Name = "NoOne", Value = 1 },
	},
	["WrapLayerAutoSkin"] = {
		{ Name = "Disabled", Value = 0 },
		{ Name = "EnabledPreserve", Value = 1 },
		{ Name = "EnabledOverride", Value = 2 },
	},
	["WrapLayerDebugMode"] = {
		{ Name = "None", Value = 0 },
		{ Name = "BoundCage", Value = 1 },
		{ Name = "LayerCage", Value = 2 },
		{ Name = "BoundCageAndLinks", Value = 3 },
		{ Name = "Reference", Value = 4 },
		{ Name = "Rbf", Value = 5 },
		{ Name = "OuterCage", Value = 6 },
		{ Name = "ReferenceMeshAfterMorph", Value = 7 },
		{ Name = "HSROuterDetail", Value = 8 },
		{ Name = "HSROuter", Value = 9 },
		{ Name = "HSRInner", Value = 10 },
		{ Name = "HSRInnerReverse", Value = 11 },
		{ Name = "LayerCageFittedToBase", Value = 12 },
		{ Name = "LayerCageFittedToPrev", Value = 13 },
		{ Name = "PreWrapDeformerOuterCage", Value = 14 },
	},
	["WrapTargetDebugMode"] = {
		{ Name = "None", Value = 0 },
		{ Name = "TargetCageOriginal", Value = 1 },
		{ Name = "TargetCageCompressed", Value = 2 },
		{ Name = "TargetCageInterface", Value = 3 },
		{ Name = "TargetLayerCageOriginal", Value = 4 },
		{ Name = "TargetLayerCageCompressed", Value = 5 },
		{ Name = "TargetLayerInterface", Value = 6 },
		{ Name = "Rbf", Value = 7 },
		{ Name = "OuterCageDetail", Value = 8 },
		{ Name = "PreWrapDeformerCage", Value = 9 },
	},
	["ZIndexBehavior"] = {
		{ Name = "Global", Value = 0 },
		{ Name = "Sibling", Value = 1 },
	},
}
do -- Xayd env checker
	local function validateCoreFuncs()
		local _pcall = pcall
		local _xpcall = xpcall
		local _pairs = pairs
		local _ipairs = ipairs
		local _tostring = tostring
		local _type = type
		local _typeof = typeof
		local _getfenv = getfenv
		local _rawget = rawget
		local _rawset = rawset
		local _rawequal = rawequal
		local _rawlen = rawlen
		local _select = select
		local _table = table
		local _string = string
		local _math = math
		local _coroutine = coroutine
		local _bit32 = bit32
		local _utf8 = utf8
		local _task = task
		local _debug = debug

		local function try(callback)
			local success, result = _pcall(callback)
			return success and result
		end

		local definitions = {
			-- // MATH LIBRARIES //
			[math.abs] = {
				name = "math.abs",
				verify = function(f) return f(-10) == 10 and f(10) == 10 end,
				error_check = function(f)
					local success, err = _pcall(f, "fail")
					return not success and _string.find(err, "number expected")
				end
			},
			[math.random] = {
				name = "math.random",
				verify = function(f)
					local r = f(1, 10)
					return r >= 1 and r <= 10 and r % 1 == 0
				end,
				error_check = function(f)
					local success, err = _pcall(f, 10, 1)
					return not success and _string.find(err, "interval is empty")
				end
			},
			[math.clamp] = {
				name = "math.clamp",
				verify = function(f) return f(10, 1, 5) == 5 and f(-5, 1, 5) == 1 end,
				error_check = function(f)
					local success, err = _pcall(f, math.abs, "1", 5)
					return not success and _string.find(err, "number expected")
				end
			},
			[math.floor] = {
				name = "math.floor",
				verify = function(f) return f(5.9) == 5 and f(-5.1) == -6 end,
				error_check = function(f)
					local success, err = _pcall(f, math.huge)
					return success and (err == "inf" or err == math.huge)
				end
			},
			[math.sign] = {
				name = "math.sign",
				verify = function(f) return f(10) == 1 and f(-10) == -1 and f(0) == 0 end,
				error_check = function(f)
					local success, err = _pcall(f, "s")
					return not success and _string.find(err, "number expected")
				end
			},

			-- // TABLE LIBRARIES //
			[table.insert] = {
				name = "table.insert",
				verify = function(f) local t = {} f(t, "a") return t[1] == "a" end,
				error_check = function(f)
					local success, err = _pcall(f, "not a table", "val")
					return not success and _string.find(err, "table expected")
				end
			},
			[table.find] = {
				name = "table.find",
				verify = function(f) return f({"a", "b", "c"}, "b") == 2 end,
				error_check = function(f)
					local success, err = _pcall(f, 123, "a")
					return not success and _string.find(err, "table expected")
				end
			},
			[table.concat] = {
				name = "table.concat",
				verify = function(f) return f({"a", "b"}, "-") == "a-b" end,
				error_check = function(f)
					local success, err = _pcall(f, "fail")
					return not success and _string.find(err, "table expected")
				end
			},

			[tostring] = {
				name = "tostring",
				verify = function(f) return f(123) == "123" end,
				error_check = function(f) return true end
			},
			[tonumber] = {
				name = "tonumber",
				verify = function(f) return f("10") == 10 and f("0xFF") == 255 end,
				error_check = function(f)
					local success, err = _pcall(f, "10", 999)
					return not success and _string.find(err, "base out of range")
				end
			},
			[string.byte] = {
				name = "string.byte",
				verify = function(f) return f("A") == 65 end,
				error_check = function(f)
					local success, err = _pcall(f, math.huge)
					return success and err == 105
				end
			},
			[string.len] = {
				name = "string.len",
				verify = function(f) return f("hello") == 5 end,
				error_check = function(f)
					local success, err = _pcall(f, {})
					return not success and _string.find(err, "string expected")
				end
			},

			-- // ROBLOX DATATYPES //
			[Random.new] = {
				name = "Random.new",
				verify = function(f)
					local rng = f(12345)
					local int_match = rng:NextInteger(1, 100) == 91
					local vec_match = math.abs(rng:NextUnitVector().X - -0.370608) == 0.19109019831848145
					return int_match and vec_match
				end,
				error_check = function(f)
					local success, err = _pcall(f, "nuh uh")
					return not success and _string.find(err, "number expected")
				end
			},
			[Color3.fromRGB] = {
				name = "Color3.fromRGB",
				verify = function(f)
					local c = f(255, 127.5, 0)
					return c.R == 1 and math.abs(c.G - 0.5) < 0.01
				end,
				error_check = function(f)
					local success, err = _pcall(f, "J", 6, 7)
					return success and err.R == 0 or (not success)
				end
			},
			[Color3.new] = {
				name = "Color3.new",
				verify = function(f)
					local c = f(1, 0, 0)
					return c.R == 1 and c.G == 0
				end,
				error_check = function(f)
					local success, err = _pcall(f, "a", math.round, "c")
					return success and tostring(err) == "0, 0, 0"
				end
			},
			[Vector3.new] = {
				name = "Vector3.new",
				verify = function(f)
					local v = f(1, 2, 3)
					return v.X == 1 and v.Y == 2 and v.Z == 3
				end,
				error_check = function(f)
					local success, err = _pcall(f, Enum.EasingStyle, 2, 3)
					return success and err.X == 0
				end
			},
			[CFrame.new] = {
				name = "CFrame.new",
				verify = function(f)
					local cf = f(10, 20, 30)
					return cf.X == 10 and cf.Y == 20 and cf.Z == 30 and cf.Position.Y == 20
				end,
				error_check = function(f)
					local success, err = _pcall(f, "fail")
					return not success and _string.find(err, "Vector3 expected")
				end
			},
			[CFrame.Angles] = {
				name = "CFrame.Angles",
				verify = function(f)
					local cf = f(0, math.pi, 0)
					local v = cf:VectorToWorldSpace(Vector3.new(0, 0, 1))
					return math.abs(v.Z - -1) < 0.01
				end,
				error_check = function(f)
					local success, err = _pcall(f, "a", 2, 3)
					return not success and err == "Unable to cast string to float"
				end
			},
			[UDim2.new] = {
				name = "UDim2.new",
				verify = function(f)
					local u = f(0.5, 10, 0.2, 5)
					return tostring(u) == "{0.5, 10}, {0.200000003, 5}"
				end,
				error_check = function(f)
					local success, err = _pcall(f, "a", 2, math.huge, 4)
					return success and tostring(err) == "{0, 2}, {INF, 4}"
				end
			},
			[Instance.new] = {
				name = "Instance.new",
				verify = function(f)
					local p = f("Part")
					local ok = p.ClassName == "Part" and p.Transparency == 0
					p:Destroy()
					return ok
				end,
				error_check = function(f)
					local success, err = _pcall(f, 123)
					return not success and _string.find(err, "Instance of type")
				end
			},
			[setmetatable] = {
				name = "setmetatable",
				verify = function(f) return f({}, {__index = {a = 1}}).a == 1 end,
				error_check = function(f)
					local success, err = _pcall(f, nil, {})
					return not success and _string.find(err, "table expected")
				end
			},
			[NumberRange.new] = {
				name = "NumberRange.new",
				verify = function(f)
					local v = f(1, 5)
					return v.Min == 1 and v.Max == 5
				end,
				error_check = function(f)
					local success, err = _pcall(f, 5, 1)
					return not success and _string.find(err, "invalid range")
				end
			},
			[NumberSequence.new] = {
				name = "NumberSequence.new",
				verify = function(f)
					local v = f(0.5, 1)
					return v.Keypoints[1].Value == 0.5 and v.Keypoints[2].Value == 1
				end,
				error_check = function(f)
					local success = _pcall(f, "1", "2")
					return not success
				end
			},
			[ColorSequence.new] = {
				name = "ColorSequence.new",
				verify = function(f)
					local v = f(Color3.new(1, 0, 0), Color3.new(0, 1, 0))
					return v.Keypoints[1].Value.R == 1 and v.Keypoints[#v.Keypoints].Value.G == 1
				end,
				error_check = function(f)
					local success = _pcall(f, math.random, "2")
					return not success
				end
			},
			[BrickColor.new] = {
				name = "BrickColor.new",
				verify = function(f)
					local v = f("Tr. Yellow")
					return v.Name == "Tr. Yellow" and tostring(v.Color) == "0.968628, 0.945098, 0.552941" and v.Number == 44
				end,
				error_check = function(f)
					local success, err = _pcall(f, "Bright red", "Bright red", "Bright red", "Bright red", "Bright red", "Bright red", "Bright red", "Bright red", "Bright red")
					return success and tostring(err) == "Really black"
				end
			},
			[Region3.new] = {
				name = "Region3.new",
				verify = function(f)
					local v = f(Vector3.new(0, 0, 0), Vector3.new(2, 2, 2))
					return v.Size.X == 2 and v.CFrame.Position.X == 1
				end,
				error_check = function(f)
					local success, err = _pcall(f, Vector3.new(0, 0, 0), "fail")
					return not success and _string.find(err, "Vector3 expected")
				end
			},
			[Ray.new] = {
				name = "Ray.new",
				verify = function(f)
					local r = f(Vector3.new(0, 10, 0), Vector3.new(0, -10, 0))
					return r.Origin.Y == 10 and r.Direction.Y == -10
				end,
				error_check = function(f)
					local success, err = _pcall(f, 123, 456)
					return not success and _string.find(err, "Vector3 expected")
				end
			},
			[Region3int16.new] = {
				name = "Region3int16.new",
				verify = function(f)
					local v = f(Vector3int16.new(40000, 40000, 40000), Vector3int16.new(-40000, -40000, -40000))
					return tostring(v) == "-25536, -25536, -25536; 25536, 25536, 25536"
				end,
				error_check = function(f)
					local success, err = _pcall(f, Random.new, "2")
					return not success and tostring(err) == "invalid argument #1 to 'new' (Vector3int16 expected, got function)"
				end
			},
			[Vector3int16.new] = {
				name = "Vector3int16.new",
				verify = function(f)
					local v = f(400000000000, 400000000000, 400000000000)
					local v2 = f(40000, 40000, 40000)
					return tostring(v) == "0, 0, 0" and tostring(v2) == "-25536, -25536, -25536"
				end,
				error_check = function(f)
					local success, err = _pcall(f, Random.new, math.huge, 1)
					return success and tostring(err) == "0, 0, 1"
				end
			},

			-- // BASIC LUA GLOBALS //
			[pairs] = {
				name = "pairs",
				verify = function(f)
					local t = {x = 1}
					local iter, state, k = f(t)
					local k_res, v_res = iter(state, k)
					return k_res == "x" and v_res == 1 and state == t and k == nil
				end,
				error_check = function(f)
					local s, e = _pcall(f, nil)
					return not s and _string.find(e, "table expected")
				end
			},
			[ipairs] = {
				name = "ipairs",
				verify = function(f)
					local t = {10, 20}
					local iter, state, k = f(t)
					local k1, v1 = iter(state, k)
					return v1 == 10 and k1 == 1 and k == 0 and state == t
				end,
				error_check = function(f)
					local s, e = _pcall(f, "fail")
					return not s and (_string.find(e, "table expected") or _string.find(e, "argument"))
				end
			},
			[next] = {
				name = "next",
				verify = function(f)
					local t = {a = 10}
					return f(t, nil) == "a" and f(t, "a") == nil
				end,
				error_check = function(f)
					local s, e = _pcall(f, 1)
					return not s and _string.find(e, "table expected")
				end
			},
			[type] = {
				name = "type",
				verify = function(f) return f(1) == "number" and f("s") == "string" and f({}) == "table" end,
				error_check = function(f)
					return not _pcall(f)
				end
			},
			[typeof] = {
				name = "typeof",
				verify = function(f) return f(Vector3.new()) == "Vector3" and f(CFrame.new()) == "CFrame" end,
				error_check = function(f)
					return not _pcall(f)
				end
			},
			[select] = {
				name = "select",
				verify = function(f)
					local a, b = f(2, "a", "b", "c")
					return f("#", 1, 2, 3) == 3 and a == "b" and b == "c"
				end,
				error_check = function(f)
					local s, e = _pcall(f, 0, 1)
					return not s and _string.find(e, "index out of range")
				end
			},
			[unpack] = {
				name = "unpack",
				verify = function(f)
					local a, b = f({10, 20})
					return a == 10 and b == 20
				end,
				error_check = function(f)
					local s, e = _pcall(f, 123)
					return not s and _string.find(e, "table expected")
				end
			},

			-- // TASK LIBRARY //
			[task.wait] = {
				name = "task.wait",
				verify = function(f)
					local t = os.clock()
					f(0.05)
					return (os.clock() - t) >= 0.04
				end,
				error_check = function(f)
					local s, e = _pcall(f, "invalid")
					return not s and _string.find(e, "number expected")
				end
			},
			[task.spawn] = {
				name = "task.spawn",
				verify = function(f)
					local ran = false
					f(function() ran = true end)
					task.wait()
					return ran == true
				end,
				error_check = function(f)
					local s, e = _pcall(f, "not a func")
					return not s and (_string.find(e, "function") or _string.find(e, "thread"))
				end
			},

			-- // OS LIBRARY //
			[os.clock] = {
				name = "os.clock",
				verify = function(f)
					local t1 = f()
					local t2 = f()
					return type(t1) == "number" and t2 >= t1
				end,
				error_check = function(f) return true end
			},
			[os.time] = {
				name = "os.time",
				verify = function(f) return type(f()) == "number" end,
				error_check = function(f)
					local s = _pcall(f, {year = 1970})
					return s == true or s == false
				end
			},

			[math.rad] = {
				name = "math.rad",
				verify = function(f) return math.abs(f(180) - 3.14159) < 0.001 end,
				error_check = function(f)
					return not _pcall(f, "s")
				end
			},
			[math.deg] = {
				name = "math.deg",
				verify = function(f) return math.abs(f(math.pi) - 180) < 0.001 end,
				error_check = function(f)
					return not _pcall(f, "s")
				end
			},

			[CFrame.lookAt] = {
				name = "CFrame.lookAt",
				verify = function(f)
					local origin = Vector3.new(0, 10, 0)
					local target = Vector3.new(0, 20, 0)
					local cf = f(origin, target)
					return math.abs(cf.LookVector.Y - 1) < 0.0001
				end,
				error_check = function(f)
					local success, err = _pcall(f, "bad_arg", Vector3.new())
					return not success and _string.find(err, "Vector3 expected")
				end
			},

			[TweenInfo.new] = {
				name = "TweenInfo.new",
				verify = function(f)
					local ti = f(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
					return ti.Time == 1.5 and ti.EasingStyle == Enum.EasingStyle.Quad
				end,
				error_check = function(f)
					local success, err = _pcall(f, "not_number")
					return not success and _string.find(err, "TweenInfo.new first argument expects a number for time.")
				end
			},

			[RaycastParams.new] = {
				name = "RaycastParams.new",
				verify = function(f)
					local p = f()
					p.FilterType = Enum.RaycastFilterType.Include
					return p.FilterType == Enum.RaycastFilterType.Include
				end,
				error_check = function(f)
					return typeof(f()) == "RaycastParams"
				end
			},

			[bit32.bxor] = {
				name = "bit32.bxor",
				verify = function(f)
					return f(240, 15) == 255
				end,
				error_check = function(f)
					local success, err = _pcall(f, "string", 1)
					return not success and _string.find(err, "number expected")
				end
			},

			[PhysicalProperties.new] = {
				name = "PhysicalProperties.new",
				verify = function(f)
					local p = f(0.1, 0.2, 0.3, 0.4, 0.5)
					return math.abs(p.Density - 0.1) < 0.001 and math.abs(p.Friction - 0.2) < 0.001
				end,
				error_check = function(f)
					local success, err = _pcall(f, "fail")
					return success and tostring(err) == "default"
				end
			},

			[utf8.char] = {
				name = "utf8.char",
				verify = function(f)
					return f(97, 98, 99) == "abc"
				end,
				error_check = function(f)
					local success, err = _pcall(f, -1)
					return not success and _string.find(err, "out of range")
				end
			},

			[game:GetService("TweenService").Create] = {
				name = "TweenService:Create",
				verify = function(f)
					local TS = game:GetService("TweenService")
					local tempValue = Instance.new("Vector3Value")
					tempValue.Value = Vector3.new(0, 0, 0)
					local targetPos = Vector3.new(100, 100, 100)

					local tween = f(TS, tempValue, TweenInfo.new(0.01), {Value = targetPos})
					tween:Play()
					task.wait(0.015)

					local result = (tempValue.Value == targetPos)
					tempValue:Destroy()
					return result
				end,
				error_check = function(f)
					local success, err = _pcall(f, game:GetService("TweenService"), Instance.new("Part"), nil, {})
					return not success and _string.find(err, "Argument 2 missing")
				end
			},

			-- // TABLE MANIPULATION //
			[table.remove] = {
				name = "table.remove",
				verify = function(f)
					local t = {10, 20, 30}
					local val = f(t, 2)
					return val == 20 and #t == 2 and t[2] == 30
				end,
				error_check = function(f)
					local success, err = _pcall(f, "not_table")
					return not success and _string.find(err, "table expected")
				end
			},
			[table.sort] = {
				name = "table.sort",
				verify = function(f)
					local t = {1, 5, 2}
					f(t, function(a, b) return a > b end)
					return t[1] == 5 and t[3] == 1
				end,
				error_check = function(f)
					local success, err = _pcall(f, "fail")
					return not success and _string.find(err, "table expected")
				end
			},

			-- // BITWISE OPERATIONS //
			[bit32.band] = {
				name = "bit32.band",
				verify = function(f)
					return f(0xF0, 0xCC) == 0xC0
				end,
				error_check = function(f)
					local success, err = _pcall(f, "string", 1)
					return not success and _string.find(err, "number expected")
				end
			},
			[bit32.rrotate] = {
				name = "bit32.rrotate",
				verify = function(f)
					return f(8, 1) == 4
				end,
				error_check = function(f)
					return not _pcall(f, {}, 1)
				end
			},

			-- // THREADING //
			[coroutine.create] = {
				name = "coroutine.create",
				verify = function(f)
					local co = f(function() end)
					return type(co) == "thread" and coroutine.status(co) == "suspended"
				end,
				error_check = function(f)
					local success, err = _pcall(f, nil)
					return not success and (_string.find(err, "function") or _string.find(err, "expected"))
				end
			},
			[coroutine.wrap] = {
				name = "coroutine.wrap",
				verify = function(f)
					local wrapper = f(function(n) return n * 2 end)
					return wrapper(10) == 20
				end,
				error_check = function(f)
					local success = _pcall(f, "fail")
					return not success
				end
			},

			[Vector2.new] = {
				name = "Vector2.new",
				verify = function(f)
					local v = f(3, 4)
					return v.X == 3 and v.Y == 4 and v.Magnitude == 5
				end,
				error_check = function(f)
					local success, err = _pcall(f, "a", math.maxinteger)
					return success and tostring(err) == "0, 0"
				end
			},
			[UDim.new] = {
				name = "UDim.new",
				verify = function(f)
					local u = f(0.5, 10)
					return u.Scale == 0.5 and u.Offset == 10
				end,
				error_check = function(f)
					local success, err = _pcall(f, Vector3.new, nil)
					return success and tostring(err) == "0, 0"
				end
			},
		}

		local passed = 0
		local total = 0
		local failures = {}

		local function addFailure(name, reason)
			_table.insert(failures, {
				name = name,
				reason = reason
			})
		end

		for func, def in _pairs(definitions) do
			total = total + 1
			local is_valid = true
			local fail_reason = nil

			local okSource, source = _pcall(_debug.info, func, "s")
			if not okSource or source ~= "[C]" then
				is_valid = false
				fail_reason = "source tampered"
			end

			if is_valid then
				local okLine, line = _pcall(_debug.info, func, "l")
				if not okLine or line ~= -1 then
					is_valid = false
					fail_reason = "line num mismatch (expected -1, got " .. _tostring(line) .. ")"
				end
			end

			if is_valid then
				local passed_behavior = try(function()
					return def.verify(func)
				end)
				if not passed_behavior then
					is_valid = false
					fail_reason = "logic check failed"
				end
			end

			if is_valid and def.error_check then
				local passed_error_check = try(function()
					return def.error_check(func)
				end)
				if not passed_error_check then
					is_valid = false
					fail_reason = "error check failed"
				end
			end

			if is_valid then
				passed = passed + 1
			else
				addFailure(def.name, fail_reason)
			end
		end

		local function safeToString(v)
			local ok, s = pcall(tostring, v)
			return ok and s or "<unprintable>"
		end

		local function getEnumTypeName(enumType)
			local ok, name = pcall(function()
				return enumType.Name
			end)

			if ok and type(name) == "string" and name ~= "" then
				return name
			end

			local s = safeToString(enumType)
			local last = string.match(s, "%.([^.]+)$")
			return last or s
		end

		local function getEnumItemName(item)
			local ok, name = pcall(function()
				return item.Name
			end)

			if ok and type(name) == "string" and name ~= "" then
				return name
			end

			local s = safeToString(item)
			local last = string.match(s, "%.([^.]+)$")
			return last or s
		end

		local function getEnumItemValue(item)
			local ok, value = pcall(function()
				return item.Value
			end)

			if ok and type(value) == "number" then
				return value
			end

			return nil
		end

		local function buildCurrentEnumMapFromGetEnums()
			local currentEnumMap = {}

			local okEnums, enumTypes = pcall(function()
				return Enum:GetEnums()
			end)

			if not okEnums or type(enumTypes) ~= "table" then
				return nil
			end

			for _, enumType in ipairs(enumTypes) do
				local enumName = getEnumTypeName(enumType)
				currentEnumMap[enumName] = {
					mode = "getenums",
					enumType = enumType,
				}
			end

			return currentEnumMap
		end

		local function buildCurrentEnumMapFromSnapshotIndex(expectedSnapshot)
			local currentEnumMap = {}

			for expectedEnumName, expectedItems in pairs(expectedSnapshot) do
				local okEnum, enumType = pcall(function()
					return Enum[expectedEnumName]
				end)

				if okEnum and enumType ~= nil then
					local itemMap = {}

					for _, expectedItem in ipairs(expectedItems) do
						local expectedItemName = expectedItem.Name

						local okItem, enumItem = pcall(function()
							return enumType[expectedItemName]
						end)

						if okItem and enumItem ~= nil then
							itemMap[expectedItemName] = getEnumItemValue(enumItem)
						end
					end

					currentEnumMap[expectedEnumName] = {
						mode = "indexed",
						itemsByName = itemMap,
					}
				end
			end

			return currentEnumMap
		end

		local function checkEnumsPerEnum(expectedSnapshot, failures)
			local currentEnumMap = buildCurrentEnumMapFromGetEnums()
			local usedFallback = false

			if currentEnumMap == nil then
				currentEnumMap = buildCurrentEnumMapFromSnapshotIndex(expectedSnapshot)
				usedFallback = true
			end

			local passed = 0
			local total = 0

			for expectedEnumName, expectedItems in pairs(expectedSnapshot) do
				total = total + 1

				local currentEntry = currentEnumMap[expectedEnumName]

				if currentEntry == nil then
					table.insert(failures, {
						name = "enum." .. expectedEnumName,
						reason = usedFallback and "enum type missing (fallback index check)" or "enum type missing"
					})
				else
					local currentItemsByName = {}
					local canValidate = true
					local failReason = nil

					if currentEntry.mode == "getenums" then
						local okItems, currentItems = pcall(function()
							return currentEntry.enumType:GetEnumItems()
						end)

						if not okItems or type(currentItems) ~= "table" then
							canValidate = false
							failReason = "GetEnumItems failed"
						else
							for _, item in ipairs(currentItems) do
								local itemName = getEnumItemName(item)
								local itemValue = getEnumItemValue(item)
								currentItemsByName[itemName] = itemValue
							end
						end
					elseif currentEntry.mode == "indexed" then
						currentItemsByName = currentEntry.itemsByName or {}
					else
						canValidate = false
						failReason = "unknown enum entry mode"
					end

					if not canValidate then
						table.insert(failures, {
							name = "enum." .. expectedEnumName,
							reason = failReason
						})
					else
						local enumProblems = {}

						for _, expectedItem in ipairs(expectedItems) do
							local expectedName = expectedItem.Name
							local expectedValue = expectedItem.Value
							local currentValue = currentItemsByName[expectedName]

							if currentValue == nil then
								table.insert(enumProblems, "missing item " .. expectedName)
							elseif currentValue ~= expectedValue then
								table.insert(
									enumProblems,
									string.format(
										"value mismatch for %s (got %s expected %s)",
										expectedName,
										tostring(currentValue),
										tostring(expectedValue)
									)
								)
							end
						end

						if #enumProblems > 0 then
							table.insert(failures, {
								name = "enum." .. expectedEnumName,
								reason = table.concat(enumProblems, "; ")
							})
						else
							passed = passed + 1
						end
					end
				end
			end

			return passed, total
		end

		do
			local enumPassed, enumTotal = checkEnumsPerEnum(roblox_enums, failures)
			passed = passed + enumPassed
			total = total + enumTotal
		end

		return passed, total, failures
	end

	local passed, total, failures = validateCoreFuncs()
	local score = math.floor((passed / total) * 100)

	print(string.format("Environment Score: %d%% (%d/%d)", score, passed, total))

	if #failures > 0 then
		warn("Detections found:")
		for _, fail in ipairs(failures) do
			warn(string.format("[-] %s: %s", fail.name, fail.reason))
		end
	else
		print("All checks passed!")
	end
end