local function getTelemetryId(name)
	local field = getFieldInfo(name)
	return field and field.id or -1
end

local function getTelemetryUnit(name)
	local field = getFieldInfo(name)
	return (field and field.unit <= 10) and field.unit or 0
end

local rssi, low, crit = getRSSI()
local ver, radio, maj, minor, rev = getVersion()
local tx = string.sub(radio, 0, 2)
local tmp = tx == "x9" and EVT_PLUS_FIRST or (tx == "xl" and EVT_UP_FIRST)
local PREV = tx == "x7" and EVT_ROT_LEFT or tmp
local INCR = tx == "x7" and EVT_ROT_RIGHT or tmp
tmp = tx == "x9" and EVT_MINUS_FIRST or (tx == "xl" and EVT_DOWN_FIRST)
local NEXT = tx == "x7" and EVT_ROT_RIGHT or tmp
local DECR = tx == "x7" and EVT_ROT_LEFT or tmp
local MENU = tx == "xl" and EVT_SHIFT_BREAK or EVT_MENU_BREAK
local general = getGeneralSettings()
local distanceSensor = getTelemetryId("Dist") > -1 and "Dist" or (getTelemetryId("0420") > -1 and "0420" or "0007")
local data = {
	rssiLow = low,
	rssiCrit = crit,
	txBattMin = general.battMin,
	txBattMax = general.battMax,
	modelName = model.getInfo().name,
	mode_id = getTelemetryId("Tmp1"),
	rxBatt_id = getTelemetryId("RxBt"),
	satellites_id = getTelemetryId("Tmp2"),
	gpsAlt_id = getTelemetryId("GAlt"),
	gpsLatLon_id = getTelemetryId("GPS"),
	heading_id = getTelemetryId("Hdg"),
	altitude_id = getTelemetryId("Alt"),
	distance_id = getTelemetryId(distanceSensor),
	current_id = getTelemetryId("Curr"),
	altitudeMax_id = getTelemetryId("Alt+"),
	distanceMax_id = getTelemetryId(distanceSensor .. "+"),
	currentMax_id = getTelemetryId("Curr+"),
	batt_id = getTelemetryId("VFAS"),
	battMin_id = getTelemetryId("VFAS-"),
	fuel_id = getTelemetryId("Fuel"),
	rssi_id = getTelemetryId("RSSI"),
	rssiMin_id = getTelemetryId("RSSI-"),
	vspeed_id = getTelemetryId("VSpd"),
	txBatt_id = getTelemetryId("tx-voltage"),
	gpsAlt_unit = getTelemetryUnit("GAlt"),
	altitude_unit = getTelemetryUnit("Alt"),
	vspeed_unit = getTelemetryUnit("VSpd"),
	distance_unit = getTelemetryUnit(distanceSensor),
	throttle_id = getTelemetryId("thr"),
	mode = 0,
	modeId = 1,
	satellites = 0,
	gpsAlt = 0,
	heading = 0,
	altitude = 0,
	altitudeMax = 0,
	distance = 0,
	distanceMax = 0,
	speed = 0,
	speedMax = 0,
	current = 0,
	currentMax = 0,
	fuel = 0,
	batt = 0,
	battMin = 0,
	cell = 0,
	cellMin = 0,
	rxBatt = 0,
	txBatt = 0,
	rssiLast = 0,
	rssiMin = 0,
	vspeed = 0,
	hdop = 0,
	homeResetPrev = false,
	gpsFixPrev = false,
	altNextPlay = 0,
	altLastAlt = 0,
	battNextPlay = 0,
	battPercentPlayed = 100,
	armed = false,
	headFree = false,
	headingHold = false,
	altHold = false,
	telemFlags = 0,
	config = 0,
	configLast = 1,
	configTop = 1,
	configSelect = 0,
	systemError = maj + minor / 10 < 2.2 and "OpenTX v2.2+ Required" or false,
}

return data, PREV, INCR, NEXT, DECR, MENU