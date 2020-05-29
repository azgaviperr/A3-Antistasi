/*
Function:
	A3A_fnc_punishment_release

Description:
	Releases a detainee from his sentence if he is incarcerated.
	Forgives all punishment stats.

Scope:
	<ANY>

Environment:
	<ANY>

Parameters:
	<OBJECT> The detainee.
	<STRING> Who is calling the function. All external calls should only use "forgive".

Returns:
	<BOOLEAN> True if hasn't crashed; nothing if it has crashed.

Examples:
	[cursorObject,"forgive"] call A3A_fnc_punishment_release; // Forgive all sins and release from Ocean Gulag.

Author: Caleb Serafin
Date Updated: 29 May 2020
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params ["_detainee",["_source",""]];
private _filename = "fn_punishment_release.sqf";

private _keyPairs = [ ["_punishmentPlatform",objNull] ];
private _UID = getPlayerUID _detainee;
private _data_instigator = [_UID,_keyPairs] call A3A_fnc_punishment_dataGet;
_data_instigator params ["_punishmentPlatform"];
private _playerStats = format["Player: %1 [%2]", name _detainee, _UID];

private _releaseFromSentence = {
	deleteVehicle _punishmentPlatform;
	_detainee switchMove "";
	_detainee setPos posHQ;
	[_detainee] remoteExec ["A3A_fnc_punishment_removeActionForgive",0,false];
};
private _forgiveStats = {
	private _keyPairs = [["timeTotal",0],["offenceTotal",0],["overhead",0],["_sentenceEndTime",serverTime]];
	[_UID,_keyPairs] call A3A_fnc_punishment_dataSet;
};

switch (_source) do {
	case "punishment_warden": {
		call _forgiveStats;
		call _releaseFromSentence;
		[2, format ["RELEASE | %1", _playerStats], _filename] call A3A_fnc_log;
		["FF Notification", "Enough then."] remoteExec ["A3A_fnc_customHint", _detainee, false];
	};
	case "punishment_warden_manual": {
		call _forgiveStats;
		call _releaseFromSentence;
		[2, format ["FORGIVE | %1", _playerStats], _filename] call A3A_fnc_log;
		["FF Notification", "An admin looks with pity upon your soul.<br/>You have been forgiven."] remoteExec ["A3A_fnc_customHint", _detainee, false];
	};
	case "forgive": {
		call _forgiveStats;
	};
	default {
		[1, format ["INVALID PARAMS | _source=""%1""", _source], _filename] call A3A_fnc_log;
	};
};
true;