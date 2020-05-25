params["_detainee","_sentenceTime"];

_detainee setVariable ["punishment_coolDown", serverTime + _sentenceTime, true];
_punishment_warden_handle = [_detainee,_sentenceTime] spawn {
	params["_detainee","_sentenceTime"];

	_countX = floor _sentenceTime;
	while {_countX > 0} do {
		["FF Notification", format ["Please do not teamkill. Play with the turtles for %1 more seconds.",_countX], true] remoteExec ["A3A_fnc_customHint", _detainee, false];
		uiSleep 1;
		_countX = _countX - 1;
	};
	[_detainee,"punishment_warden"] call A3A_fnc_punishment_release;
};

///////////////////////// TODO: PLAYER TEAM FORGIVE SCRIPT
[_detainee] call A3A_fnc_punishment_sentence;
[_detainee] remoteExec ["A3A_fnc_punishment_addActionForgive",0,false];
[_detainee] remoteExec ["A3A_fnc_punishment_notifyAdmin",0,false];

_punishment_vars = _detainee getVariable ["punishment_vars", [0,0,[0,0],scriptNull]];	// [timeTotal,offenceTotal,[lastOffenceServerTime,overhead],[wardenHandle]]
_punishment_vars set [3,_punishment_warden_handle];
_detainee setVariable ["punishment_vars", _punishment_vars, true];