local repo = "https://raw.githubusercontent.com/NightForRoblox/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles
local Sliders = Library.Sliders

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
	Title = "",
	Footer = "productviewer v1.0 [universal]",
	Icon = 115273366480969,
  IconSize = UDim2.fromOffset(150, 61),
  Size = UDim2.fromOffset(1400, 700),
	NotifySide = "Right",
	ShowCustomCursor = true,
})

Library:Notify({
    Title = "Product Viewer",
    Description = "Waiting to script load...",
    Time = 4,
})

local Tabs = {
	Products = Window:AddTab("Products", "user"),
	["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

local HelperScriptsBox = Tabs.Products:AddRightGroupbox("Helper Scripts", "boxes")

HelperScriptsBox:AddButton({
    Text = "SimpleSpy",
    Func = function()
      loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpyBeta.lua"))()
    end
})

local MarketplaceService = game:GetService("MarketplaceService")

local success, result = pcall(function()
    return MarketplaceService:GetDeveloperProductsAsync()
end)

if success then
    for _, product in pairs(result:GetCurrentPage()) do
        local ProductBox = Tabs.Products:AddLeftGroupbox(product.Name, "boxes")
        ProductBox:AddDivider("Divider")
        local ProductName = ProductBox:AddLabel("Product Name: "..product.Name, false)
        local ProductDesc = ProductBox:AddLabel("Product Desc: "..product.Description, false)
        local ProductImage = ProductBox:AddImage("ProductImage", {
            Image = "rbxassetid://"..product.IconImageAssetId,
            Transparency = 0,
            Color = Color3.new(1, 1, 1),
            RectOffset = Vector2.zero,
            RectSize = Vector2.zero,
            ScaleType = Enum.ScaleType.Fit,
            Height = 200,
        })
        local ProductID = ProductBox:AddLabel("Product ID: "..product.ProductId, false)
        local ProductIsForSale = ProductBox:AddLabel("Is Product For Sale: "..tostring(product.IsForSale), false)
        local ProductPrice = ProductBox:AddLabel("Product Price: "..tostring(product.PriceInRobux), false)
        if player then
			if game.PlaceId == 537413528 or 1930665568 or 1930863474 or 1930866268 then
	          	ProductBox:AddButton({
	            	Text = "Fire Buy Prompt",
	            	Func = function()
	            	  local args = {
	            	    product.ProductId,
	            	    "Product"
	            	  }
	            	  workspace:WaitForChild("PromptRobuxEvent"):InvokeServer(unpack(args))
					end
	        	})
			end
        	else
				print("game is not babft")
		end
    end
else
    ProductBox:AddDivider("Divider")
    ProductBox:UpdateWarningBox({
      Title = "Product ???",
      Text = "Failed to load product!",
      IsNormal = false, -- Error Box = false, Normal Box = true
      Visible = true,
      LockSize = true,
    })
end


local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "wrench")

MenuGroup:AddToggle("KeybindMenuOpen", {
	Default = Library.KeybindFrame.Visible,
	Text = "Open Keybind Menu",
	Callback = function(value)
		Library.KeybindFrame.Visible = value
	end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
	Text = "Custom Cursor",
	Default = true,
	Callback = function(Value)
		Library.ShowCustomCursor = Value
	end,
})
MenuGroup:AddDropdown("NotificationSide", {
	Values = { "Left", "Right" },
	Default = "Right",

	Text = "Notification Side",

	Callback = function(Value)
		Library:SetNotifySide(Value)
	end,
})
MenuGroup:AddDropdown("DPIDropdown", {
	Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
	Default = "100%",

	Text = "DPI Scale",

	Callback = function(Value)
		Value = Value:gsub("%%", "")
		local DPI = tonumber(Value)

		Library:SetDPIScale(DPI)
	end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
	:AddKeyPicker("MenuKeybind", { Default = "Insert", NoUI = true, Text = "Menu keybind" })

MenuGroup:AddButton("Unload", function()
	Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("ProductViewer")

SaveManager:SetFolder("ProductViewer/specific-game")
SaveManager:SetSubFolder("specific-place")

SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

task.wait(0.2)

Library:Notify({
    Title = "Product Viewer",
    Description = "Script loaded! Ready to use.",
    Time = 4,
})
