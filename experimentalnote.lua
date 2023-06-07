getgenv().Internal = {}
local GameSettings = game:GetService("ReplicatedStorage"):WaitForChild("Game")
function Internal:GetHighlight(obj)
    local holder = game:GetService("CoreGui"):FindFirstChild("HighlightHolder") or Instance.new("Folder")
    holder.Name = "HighlightHolder"
    holder.Parent = game:GetService("CoreGui")
    local high = holder:FindFirstChild(obj) or Instance.new("Highlight")
    high.Parent = holder
    high.Name = obj
    high.Enabled = true
    return high
end
function Internal:Text(obj, isid, tname, def)
    local ESPholder = game.CoreGui:FindFirstChild("TextHolder") or Instance.new("Folder", game.CoreGui)
    ESPholder.Name = "TextHolder"
    if ESPholder:FindFirstChild(tname) then ESPholder:FindFirstChild(tname):Destroy() end
    local BillboardGui = Instance.new("BillboardGui")
	local TextLabel = Instance.new("TextLabel")
	BillboardGui.Adornee = obj
	BillboardGui.Name = tname
	BillboardGui.Parent = ESPholder
	BillboardGui.AlwaysOnTop = true
	BillboardGui.Size = UDim2.new(0, 100, 0, 150)
	TextLabel.Parent = BillboardGui
	TextLabel.BackgroundTransparency = 1
	TextLabel.Size = UDim2.new(0, 100, 0, 100)
	TextLabel.Font = Enum.Font.SourceSansSemibold
	TextLabel.TextStrokeTransparency = 0
	TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom
	TextLabel.ZIndex = 15
	if isid then
	    obj.SurfaceGui:GetPropertyChangedSignal("Enabled"):Connect(function()
	        if obj.SurfaceGui.Enabled == false then
	            BillboardGui:Destroy()
	        end
	    end)
	    TextLabel.Text = tname
	    TextLabel.TextSize = 15
	    BillboardGui.StudsOffset = Vector3.new(0, 0, 0)
	    TextLabel.Position = UDim2.new(0, 0, 0, -25)
	    if tname == "Your Id" then TextLabel.TextColor3 = Main.SelfIdProperties.FillColor; TextLabel.TextStrokeColor3 = Main.SelfIdProperties.OutlineColor; else TextLabel.TextColor3 = Main.OtherIdProperties.FillColor; TextLabel.TextStrokeColor3 = Main.OtherIdProperties.OutlineColor; end
	else
	    if not def then
	    TextLabel.Text = tname .. " | Suspected Kira"
	    TextLabel.TextColor3 = Main.SuspectedKiraProperties.FillColor
	    TextLabel.TextStrokeColor3 = Main.SuspectedKiraProperties.OutlineColor
	    else
	    TextLabel.Text = tname .. " | Definitely Kira"
	    TextLabel.TextColor3 = Main.DefiniteKiraProperties.FillColor
	    TextLabel.TextStrokeColor3 = Main.DefiniteKiraProperties.OutlineColor
	    end
	    BillboardGui.StudsOffset = Vector3.new(0, 1, 0)
	    TextLabel.Position = UDim2.new(0, 0, 0, -50)
	    TextLabel.TextSize = 20
	end
	obj.Destroying:Connect(function()
	    BillboardGui:Destroy()
	end)
	
end
function Internal:LText(obj, isid, tname)
    local ESPholder = game.CoreGui:FindFirstChild("TextHolder") or Instance.new("Folder", game.CoreGui)
    ESPholder.Name = "TextHolder"
    if ESPholder:FindFirstChild(tname) then ESPholder:FindFirstChild(tname):Destroy() end
    local BillboardGui = Instance.new("BillboardGui")
	local TextLabel = Instance.new("TextLabel")
	BillboardGui.Adornee = obj
	BillboardGui.Name = tname
	BillboardGui.Parent = ESPholder
	BillboardGui.AlwaysOnTop = true
	BillboardGui.Size = UDim2.new(0, 100, 0, 150)
	TextLabel.Parent = BillboardGui
	TextLabel.BackgroundTransparency = 1
	TextLabel.Size = UDim2.new(0, 100, 0, 100)
	TextLabel.Font = Enum.Font.SourceSansSemibold
	TextLabel.TextStrokeTransparency = 0
	TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom
	TextLabel.ZIndex = 15
	if isid then
	    obj.SurfaceGui:GetPropertyChangedSignal("Enabled"):Connect(function()
	        if obj.SurfaceGui.Enabled == false then
	            BillboardGui:Destroy()
	        end
	    end)
	    TextLabel.Text = tname
	    TextLabel.TextSize = 15
	    BillboardGui.StudsOffset = Vector3.new(0, 0, 0)
	    TextLabel.Position = UDim2.new(0, 0, 0, -25)
	    if tname == "Your Id" then TextLabel.TextColor3 = Main.SelfIdProperties.FillColor; TextLabel.TextStrokeColor3 = Main.SelfIdProperties.OutlineColor; else TextLabel.TextColor3 = Main.OtherIdProperties.FillColor; TextLabel.TextStrokeColor3 = Main.OtherIdProperties.OutlineColor; end
	else
	    TextLabel.Text = tname .. " | Possibly L"
	    TextLabel.TextColor3 = Main.PossibleLProperties.FillColor
	    TextLabel.TextStrokeColor3 = Main.PossibleLProperties.OutlineColor
	    BillboardGui.StudsOffset = Vector3.new(0, 1, 0)
	    TextLabel.Position = UDim2.new(0, 0, 0, -50)
	    TextLabel.TextSize = 20
	end
	obj.Destroying:Connect(function()
	    BillboardGui:Destroy()
	end)
end
function Internal:IsSelfId(id)
    local idimg = id:FindFirstChild("ImageLabel", true) -- Uses the image instead of text because of the possibility of multiple same display names
    if idimg then
        local img = idimg.Image
        if img == "rbxasset://textures/ui/GuiImagePlaceholder.png" then return "Default", "Default" end
        img = string.gsub(img, "rbxthumb://type=AvatarHeadShot&id=", "")
        img = string.gsub(img, "&w=420&h=420", "")
        img = tonumber(img)
        local nm
        if Main.UseDisplayNames then
            local infos = game:GetService("UserService"):GetUserInfosByUserIdsAsync({img})
            nm = (infos[1]).DisplayName
            print(nm)
        else
            nm = game.Players:GetNameFromUserIdAsync(img)
        end
        return (game.Players.LocalPlayer.UserId == img), nm
    end
    return
end
function Internal:GetClosestToTakenId(Position)
    local Map = workspace.Map
    local Players = game:GetService("Players")
    local MaxRange = math.huge
    local Closest = nil
    for _, v in pairs(Players:GetPlayers()) do
        local RootPart = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
        if RootPart then
            local Magnitude = (RootPart.Position - Position).Magnitude
            if Magnitude < MaxRange then
                Closest = v.Character
                MaxRange = Magnitude
            end
        end
    end
    return Closest
end
function Main:HighlightSuspectedKira(plr, def)
	if plr.Name == "synapsium" then return end
    local high = Internal:GetHighlight(plr.Name)
    high.Adornee = plr
    if not def then
    for property, value in pairs(Main.SuspectedKiraProperties) do
        high[property] = value
    end
    if Main.OverheadName then
        local head = plr:WaitForChild("Head")
        if Main.UseDisplayNames then Internal:Text(head, false, game.Players:GetPlayerFromCharacter(plr).DisplayName) else Internal:Text(head, false, plr.Name) end
    end
    else
    for property, value in pairs(Main.DefiniteKiraProperties) do
        high[property] = value
    end
    if Main.OverheadName then
        local head = plr:WaitForChild("Head")
        if Main.UseDisplayNames then Internal:Text(head, false, game.Players:GetPlayerFromCharacter(plr).DisplayName, true) else Internal:Text(head, false, plr.Name, true) end
    end
    end
end
function Main:HighlightPossibleL(plr)
	if plr.Name == "synapsium" or not Main.HighlightPossibleLs then return end
    local high = Internal:GetHighlight(plr.Name)
    high.Adornee = plr
    for property, value in pairs(Main.PossibleLProperties) do
        high[property] = value
    end
    if Main.OverheadName then
        local head = plr:WaitForChild("Head")
        if Main.UseDisplayNames then Internal:LText(head, false, game.Players:GetPlayerFromCharacter(plr).DisplayName) else Internal:LText(head, false, plr.Name) end
    end
end
function Main:HighlightId(id)
    local isself, plrname = Internal:IsSelfId(id)
    if isself ~= nil and plrname ~= nil and isself ~= "Default" then
    local high
    id.Transparency = 0
    if isself == true and Main.HighlightSelfId then
        high = Internal:GetHighlight("Your Id")
        high.Adornee = id
        for property, value in pairs(Main.SelfIdProperties) do
            high[property] = value
        end
        if Main.ShowIdNames then
            Internal:Text(id, true, "Your Id")
        end
    elseif isself == false and Main.HighlightOtherId then
        high = Internal:GetHighlight(plrname .. "'s Id")
        high.Adornee = id
        for property, value in pairs(Main.OtherIdProperties) do
            high[property] = value
        end
        if Main.ShowIdNames then
            Internal:Text(id, true, plrname .. "'s Id")
        end
    end
    end
end
Internal.FoundToPossiblyBeL = {}
function Internal.LWeightChecker(plr)
	local weight = plr:WaitForChild("LChance_Weight", 99999)
	task.wait()
	local ov = weight.Value
	weight.Changed:Connect(function(nv)
		if nv < ov and plr.Character then
			table.insert(Internal.FoundToPossiblyBeL, plr.Character)
			Main:HighlightPossibleL(plr.Character)
		end
		ov = nv
	end)
end
function Internal.DoYourThing(map)
    task.wait()
    if map.Name == "Map" and not game.Players:GetPlayerFromCharacter(map) then -- Avoiding the "edgiest" of edge cases in which a player named Map joins the game
    local defkiras = {}
    local connections = {}
    local function DoStuffWithIds(id)
        task.wait()
        if id.Name == "Id" then
            local sui = id:WaitForChild("SurfaceGui")
            if sui.Enabled then
                Main:HighlightId(id)
            end
            local conn = sui:GetPropertyChangedSignal("Enabled"):Connect(function()
                if sui.Enabled == false and GameSettings.GamePhase.Value == "IdScatter" then
                    id.Transparency = 1
                    local closest = Internal:GetClosestToTakenId(id.Position)
                    if closest and Main.HighlightSuspectedKiras and not table.find(defkiras, closest) and closest ~= game.Players.LocalPlayer.Character and not table.find(Internal.FoundToPossiblyBeL, closest) then
                        Main:HighlightSuspectedKira(closest)
                    end
                else
                    id.Transparency = 0
                    Main:HighlightId(id)
                end
            end)
            local conn2 = sui:WaitForChild("Frame"):WaitForChild("ImageLabel"):GetPropertyChangedSignal("Image"):Connect(function()
                Main:HighlightId(id)
            end)
            table.insert(connections, conn)
            table.insert(connections, conn2)
        end
    end
    map.Destroying:Connect(function()
        for _, conn in pairs(connections) do
            conn:Disconnect()
        end
        Internal.FoundToPossiblyBeL = {}
        if game.CoreGui:FindFirstChild("HighlightHolder") then game.CoreGui:FindFirstChild("HighlightHolder"):Destroy() end
        if game.CoreGui:FindFirstChild("TextHolder") then game.CoreGui:FindFirstChild("TextHolder"):Destroy() end
    end)
    local caro = map.ChildAdded:Connect(DoStuffWithIds)
    table.insert(connections, caro)
    for _, v in pairs(map:GetChildren()) do DoStuffWithIds(v) end
    local kann = GameSettings.GamePhase.Changed:Connect(function(nv)
        if nv == "IdScatter" then
            for _, v in pairs(map:GetChildren()) do DoStuffWithIds(v) end
        end
    end)
    if Main.HighlightDefiniteKiras then
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= game.Players.LocalPlayer and plr.Character then
            local defense = plr.Character.ChildAdded:Connect(function(book)
                task.wait()
                if book.Name == "DeathNoteBook" then
                    table.insert(defkiras, plr.Character)
                    Main:HighlightSuspectedKira(plr.Character, true)
                end
            end)
            table.insert(connections, defense)
        end
    end
    end
    end
end
if game.Workspace:FindFirstChild("Map") then Internal.DoYourThing(game.Workspace:FindFirstChild("Map")) end
workspace.ChildAdded:Connect(Internal.DoYourThing)
for a, plr in pairs(game.Players:GetPlayers()) do
	Internal.LWeightChecker(plr)
end
game.Players.PlayerAdded:Connect(Internal.LWeightChecker)
