% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function DCM_NED2ECEF = fcnLLA2DCM_NED2ECEF(LLA)
DCM_NED2ECEF = fcnLLA2DCM_ECEF2NED(LLA)'; %transpose
end

