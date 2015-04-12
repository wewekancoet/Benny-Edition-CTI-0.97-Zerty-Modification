diag_log " :: SAVE :: Trying to load";
_towns = profileNamespace getVariable ["CTI_SAVE_TOWNS",[]];
if (count _towns != count CTI_TOWNS) exitWith {diag_log " :: SAVE :: Loading fail";};

diag_log " :: SAVE :: Loading";
{ _x setVariable ["cti_town_lastSideID", (_towns select _foreachindex) select 0, true];[_x, ((_towns select _foreachindex) select 1) call CTI_CO_FNC_GetSideFromID] call CTI_SE_FNC_OnTownCaptured;true }foreach (CTI_TOWNS);


{
	_side=_x;
	_logic= (_side) call CTI_CO_FNC_GetSideLogic;
	_load=profileNamespace getVariable format ["CTI_SAVE_%1", _side];

	//hq
	_hq=(_side) call CTI_CO_FNC_GetSideHQ;
	_hq setposATL (((_load select 0 ) select 0)select 0);
	_hq setdir (((_load select 0 ) select 0)select 1);
	if !(((_load select 0 ) select 1)) then {_hq setDamage 1};

    // com funds
    _logic setvariable ["cti_commander_funds",(_load select 1 ),true];

    // upgrades
    _logic setVariable ["cti_upgrades", (_load select 2 ), true];

    //base area
    _logic setVariable ["cti_structures_areas", (_load select 3 ), true];

    //structures
    {_build=[(_x select 0), _side,(_x select 1)  select 0 ,(_x select 1)  select 1 ] call CTI_SE_FNC_BuildStructure;_build setvariable ["cti_completion",100,true];true} count (_load select 4);

    //WIP structures
    {_build=[(_x select 0), _side,(_x select 1)  select 0 ,(_x select 1)  select 1 ] call CTI_SE_FNC_BuildStructure;_build setvariable ["cti_completion",100,true];true} count (_load select 5);

    //defences
    {[_x select 0, _side,(( _x select 1) select 0), (( _x select 1) select 1),objnull, false, _x select 2] call CTI_SE_FNC_BuildDefense;true} count (_load select 6);

    //curent upgrade
    if (((_load select 7) select 0 ) > -1) then { [_side,((_load select 7) select 0 ), ((_load select 7) select 1 )] spawn CTI_SE_FNC_StartUpgrade; sleep 1; _logic setvariable ["cti_upgrade_lt",((_load select 7) select 2 ),true]; };


} forEach [east,west];




