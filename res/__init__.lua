local hxrt = require(game:GetService("ReplicatedStorage"):FindFirstChild("HxRuntime"));

hxrt._r_mcnt(MODULE_NUMBER_COUNT, function()
	for _, fn in hxrt._hxStaticInits do
		fn()
	end

	hxrt.import("ENTRY_POINT_TYPE").main();
end)
