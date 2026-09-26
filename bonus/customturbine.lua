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
	Footer = "custom turbine v1.0 [babft]",
	Icon = 104693353467812,
  IconSize = UDim2.fromOffset(55, 55),
	NotifySide = "Right",
	ShowCustomCursor = true,
})

Library:Notify({
    Title = "Custom Turbine",
    Description = "Waiting to script load...",
    Time = 4,
})

local Tabs = {
	Turbine = Window:AddTab("Turbines", "user"),
	["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

for _, turbine in ipairs(workspace.Blocks:WaitForChild(game.Players.LocalPlayer.Name):GetDescendants()) do
    if turbine.Name == "JetTurbine" then
      local function update()
              local TurbinesBox = Tabs.Turbine:AddLeftGroupbox(turbine.Name.." Settings", "boxes")
      local InfoBox = Tabs.Turbine:AddRightGroupbox(turbine.Name.." Info / List", "boxes")
      local TurbineViewport = TurbinesBox:AddViewport("TurbineViewport", {
        Object = turbine,
        Camera = Instance.new("Camera"),
        Interactive = true,
        AutoFocus = true,
        Height = 150,
      })
      TurbinesBox:AddLabel("Settings", false)
      TurbinesBox:AddDivider()
      TurbinesBox:AddInput("Fuel", {
        Default = turbine.Fuel.Value,
        Numeric = true, -- true / false, only allows numbers
        Finished = false, -- true / false, only calls callback when you press enter
        ClearTextOnFocus = false, -- true / false, if false the text will not clear when textbox focused

        Text = "Fuel:",

        Placeholder = "For example: 1000",

        Callback = function(value)
          turbine.Fuel.Value = value
        end,
      })
      TurbinesBox:AddInput("Speed", {
        Default = turbine.MaxSpeed.Value,
        Numeric = true, -- true / false, only allows numbers
        Finished = false, -- true / false, only calls callback when you press enter
        ClearTextOnFocus = false, -- true / false, if false the text will not clear when textbox focused

        Text = "Speed:",

        Placeholder = "For example: 180",

        Callback = function(value)
          turbine.MaxSpeed.Value = value
        end,
      })
      TurbinesBox:AddInput("Force", {
        Default = turbine.MaxForce.Value,
        Numeric = true, -- true / false, only allows numbers
        Finished = false, -- true / false, only calls callback when you press enter
        ClearTextOnFocus = false, -- true / false, if false the text will not clear when textbox focused

        Text = "Force:",

        Placeholder = "For example: 100000000",

        Callback = function(value)
          turbine.MaxForce.Value = value
        end,
      })
      TurbinesBox:AddDivider()
      TurbinesBox:AddLabel("Color", false)
      TurbinesBox:AddDivider()
      local Wings = TurbinesBox:AddLabel("Wings Color", false)
      Wings:AddColorPicker("TurbineWings", {
        Default = Color3.new(248, 248, 248),
        Title = "Peek a color",
        Resizable = true,
        Callback = function(value)
            turbine.Wings.Color = value
        end
      })
      local Nose = TurbinesBox:AddLabel("Nose Color", false)
      Nose:AddColorPicker("TurbineNose", {
        Default = Color3.new(248, 248, 248),
        Title = "Peek a color",
        Resizable = true,
        Callback = function(value)
            turbine.Nose.Color = value
        end
      })
      InfoBox:AddLabel("Info / List", false)
      InfoBox:AddDivider()
      local TurbinePosition = InfoBox:AddLabel("Turbine Position: ", false)
      local Fuel = InfoBox:AddLabel("Fuel: ", false)
      game:GetService("RunService").RenderStepped:Connect(function()
        if turbine then
            TurbinePosition:SetText("Turbine Position: "..tostring(turbine.PPart.CFrame))
            Fuel:SetText("Fuel: "..turbine.Fuel.Value)
          else
            task.wait(0.5)
            print("Turbine doesn't exist!")
        end
      end)
      InfoBox:AddDivider()
            InfoBox:AddButton("Update List", function()
        delete()
        task.wait(0.1)
        update()
      end)
      end
      local function delete()
        TurbineViewport:Destroy()
      end
      update()
      task.wait(0.5)
    end
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
    Title = "Custom Turbine",
    Description = "Script loaded! Ready to use.",
    Time = 4,
})
