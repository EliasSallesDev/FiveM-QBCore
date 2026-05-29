local Translations = {
    error = {
        smash_own = "You can't scrap a vehicle you own.",
        cannot_scrap = "This vehicle cannot be scrapped.",
        not_driver = "You are not the driver.",
        demolish_vehicle = "You are not allowed to demolish vehicles now.",
        canceled = "Canceled",
        active_job = "You already have an active scrapyard job.",
        no_active_job = "You do not have an active scrapyard job.",
        cooldown = "Wait %{value} minute(s) before requesting another job.",
        not_enough_money = "You need $%{value} cash for rental and deposit.",
        wrong_vehicle = "That is not the requested vehicle.",
        vehicle_missing = "The job vehicle could not be found.",
        vehicle_too_far = "Bring the requested vehicle into the delivery area.",
        too_far = "You are too far from the delivery area.",
        expired = "The job expired.",
        job_canceled = "Scrapyard job canceled. The deposit was lost.",
    },
    success = {
        tow_rented = "Tow truck rented. Check your email for the vehicle lead.",
        job_started = "Job started: find a %{vehicle} in %{zone}.",
        job_complete = "Job complete. You received $%{value} including the deposit return.",
    },
    text = {
        scrapyard = 'Scrap Yard',
        request_job = '[E] - Request tow job | [G] - Cancel job',
        request_job_target = 'Request tow job',
        cancel_job_target = 'Cancel job',
        disassemble_vehicle = '[E] - Deliver and disassemble vehicle',
        disassemble_vehicle_target = 'Deliver and disassemble vehicle',
        demolish_vehicle = 'Disassembling vehicle',
        search_area = 'Scrapyard search area',
    },
    email = {
        sender = "Turner's Auto Wrecking",
        subject = 'Recovery Job',
        message = 'I have a lead for you.<br /><br /><strong>Vehicle:</strong> %{vehicle}<br /><strong>Rarity:</strong> %{rarity}<br /><strong>Area:</strong> %{zone}<br /><strong>Plate:</strong> %{plate}<br /><br />%{hint}<br /><br />Bring the car back to the yard within %{minutes} minutes. A tow truck is ready for you.',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
