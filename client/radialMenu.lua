if not wx.radialMenus then return end

exports('handcuffHandler', function(menu, item)
    print(menu, item)

    if menu == 'wx_unijob:radial:police' and item == 1 then
        print('TODO: HANDCUFFS')
    end
end)

lib.registerRadial({
    id = 'wx_unijob:radial:police',
    items = {
        {
            label = 'Handcuff',
            icon = 'handcuffs',
            onSelect = 'myMenuHandler'
        },
    }
})
