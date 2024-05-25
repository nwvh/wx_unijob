wx.Client = {}

wx.Client.repairItem = "repairkit" ---@param item string Item that you need to repair vehicle

---Custom function for invoices
---@param target number Player ID of the receiver
---@param amount number Amount for the invoice
---@param reason string Brief description of the invoice reason
---@param society string From whom is the invoice coming
wx.Client.Invoice = function(target, amount, reason, society)
    -- okokBilling V2
    TriggerServerEvent("okokBilling:CreateCustomInvoice",
        target,
        amount,
        reason,
        "Invoice from an Officer",
        society,
        wx.Jobs[society].label
    )

    -- esx_billing
    -- TriggerServerEvent('esx_billing:sendBill', target, 'society_' .. society, wx.Jobs[society].label, amount)

    -- Feel free to add your own billing function / event
end

---Custom function for notifications
---@param title string Title of the notification
---@param message string Message of the notification
---@param type string Type of the notification (success, error, warning, info)
---@param time number Time in milliseconds for how long the notification should be displayed

wx.Client.Notify = function(title, message, type, time)
    lib.notify({
        title = title,
        type = type,
        description = message,
        time = time
    })
end