local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Themes = {
    ["Default"] = "Default",
    ["Amber Glow"] = "AmberGlow",
    ["Amethyst"] = "Amethyst",
    ["Bloom"] = "Bloom",
    ["Dark Blue"] = "DarkBlue",
    ["Green"] = "Green",
    ["Light"] = "Light",
    ["Ocean"] = "Ocean",
    ["Serenity"] = "Serenity"
}

local SelectedTheme = "Amethyst"

local function CreateWindow(theme)
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    if Rayfield == nil then
        error("Rayfield did not load!")
        return nil
    end

    local Window = Rayfield:CreateWindow({
        Name =  "Silent Scripts V3.5 (Comeback)",
        Icon = 72666860753983,
        LoadingTitle = "SilentScript made by Pingz0 | Idea´s by Pyrotec_7",
        LoadingSubtitle = "Loading SilentScript...",
        ShowText = "Silent Script",
        Theme = theme or "Amethyst",
        ToggleUIKeybind = "K",
        DisableRayfieldPrompts = true,
        DisableBuildWarnings = true,
        KeySystem = false,
        FileName = "SilentScript",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "SilentScriptConfig", -- Defaults to "RayfieldConfigs"
            FileName = "SilentScriptConfig"
        }
    })

    local MainTab = Window:CreateTab("| Main", 8772194322)

    MainTab:CreateSlider({
        Name = "Speed Hack",
        Flag = "SpeedHackEnabled",
        Range = {16, 250},
        Increment = 1,
        Suffix = " WalkSpeed",
        CurrentValue = 16,
        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end,
    })

    MainTab:CreateSlider({
        Name = "Jump Hack",
        Range = {50, 250},
        Flag = "JumpHackEnabled",
        Increment = 5,
        Suffix = " JumpPower",
        CurrentValue = 50,
        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
        end,
    })

    local FlySpeed = 2

    MainTab:CreateSlider({
        Name = "Fly Speed",
        Range = {1, 100},
        Flag = "FlySpeed",
        Increment = 1,
        Suffix = "x",
        CurrentValue = FlySpeed,
        Callback = function(value)
            FlySpeed = value
        end,
    })

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local userInputService = game:GetService("UserInputService")
    local runService = game:GetService("RunService")
    local cam = workspace.CurrentCamera

    local flying = false
    local BodyVelocity
    local BodyGyro

    local function startFly()
        if flying then return end
        flying = true
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.Parent = rootPart

        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        BodyGyro.CFrame = rootPart.CFrame
        BodyGyro.Parent = rootPart
    end

    local function stopFly()
        if not flying then return end
        flying = false
        if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
        if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
    end

    local function updateFly()
        if not flying then return end
        local moveDir = Vector3.new()
        if userInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if userInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if userInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if userInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if userInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if userInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
        if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
        BodyVelocity.Velocity = moveDir * FlySpeed * 16
        BodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + cam.CFrame.LookVector)
    end

    MainTab:CreateButton({
        Name = "Toggle Fly",
        Flag = "FlightEnabled",
        Callback = function()
            if flying then
                stopFly()
            else
                startFly()
            end
        end,
    })

    runService.Heartbeat:Connect(function()
        if flying then
            updateFly()
        end
    end)

    player.CharacterAdded:Connect(function(char)
        character = char
        rootPart = char:WaitForChild("HumanoidRootPart")

        if flying then
            stopFly()
            task.wait(0.1)
            startFly()
        end
    end)

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local player = Players.LocalPlayer

    local noclipEnabled = false
    local noclipConnection = nil

    -- This function is kept now unused; we'll directly manipulate parts.
    local function setNoclip(state)
        noclipEnabled = state
        if state then
            -- Enable noclip
            if not player.Character then
                player.CharacterAdded:Wait()
            end
            -- Turn off collisions on immediate children (same as working GUI)
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            noclipConnection = RunService.Stepped:Connect(function()
                if noclipEnabled and player.Character then
                    for _, part in pairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            -- Disable noclip exactly like the GUI version
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end

            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Anchored = true
                end

                -- Re-enable collisions on immediate children
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end

                if hrp then
                    task.wait(0.05)
                    -- 2.5 stud lift
                    hrp.CFrame = hrp.CFrame + Vector3.new(0, 2.5, 0)
                    hrp.Velocity = Vector3.zero
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.Anchored = false
                end
            end
        end
    end

    -- Respawn handling (only if noclip was active)
    player.CharacterAdded:Connect(function(char)
        if noclipEnabled then
            char:WaitForChild("HumanoidRootPart", 5)
            task.wait(0.1)
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            if noclipConnection then
                noclipConnection:Disconnect()
            end
            noclipConnection = RunService.Stepped:Connect(function()
                if noclipEnabled and player.Character then
                    for _, part in pairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end)

    local NoclipToggle = MainTab:CreateToggle({
        Name = "Noclip",
        CurrentValue = false,
        Flag = "NoclipToggle",
        Callback = function(Value)
            setNoclip(Value)
        end,
    })

    local ESPDrawings = {}
    local ESPConnections = {}
    local ESPTracers = {}
    local ESPEnabled = false
    local TracersEnabled = false
    local ChamsEnabled = false
    local ESPRefreshConnection = nil
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local RunService = game:GetService("RunService")

    local ESPColors = {
        ["Red"] = Color3.new(1, 0, 0),
        ["Blue"] = Color3.new(0, 0, 1),
        ["Green"] = Color3.new(0, 1, 0),
        ["Yellow"] = Color3.new(1, 1, 0),
        ["Purple"] = Color3.new(0.5, 0, 0.5),
        ["White"] = Color3.new(1, 1, 1),
        ["Black"] = Color3.new(0, 0, 0),
        ["Orange"] = Color3.new(1, 0.5, 0),
        ["Pink"] = Color3.new(1, 0, 0.5),
        ["Cyan"] = Color3.new(0, 1, 1),
        ["Transparent"] = Color3.new(1, 1, 1)
    }
    
    local ESPColor = ESPColors["Red"]
    local function clearAllTracers()
        for _, tracerData in pairs(ESPTracers) do
            if tracerData.connection then
                pcall(function() tracerData.connection:Disconnect() end)
            end
            if tracerData.drawing then
                pcall(function() tracerData.drawing:Remove() end)
            end
        end
        ESPTracers = {}
    end

    local function createPerfectOutline(character, color)
        local drawings = {}
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPPerfectOutline"
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = Color3.new(1, 1, 1)
        highlight.FillTransparency = 1
        highlight.OutlineColor = color
        highlight.OutlineTransparency = 0
        highlight.Parent = character
        table.insert(drawings, highlight)
        
        return drawings
    end

    local function createChamsEffect(character, color)
        local drawings = {}
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPChams"
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = color
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = color
        highlight.OutlineTransparency = 0.3
        highlight.Parent = character
        table.insert(drawings, highlight)
        
        return drawings
    end

    local function createTracers(player, color)
        local tracerData = {}
        
        local tracer = Drawing.new("Line")
        tracer.Name = "ESPTracer"
        tracer.Visible = false
        tracer.Color = color
        tracer.Thickness = 1.5
        tracer.Transparency = 0.3
        
        local tracerConnection = RunService.RenderStepped:Connect(function()
            if not TracersEnabled then
                tracer.Visible = false
                return
            end
            
            local character = player.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then
                tracer.Visible = false
                return
            end
            
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local head = character:FindFirstChild("Head")
            local targetPart = head or rootPart
            
            if targetPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                
                if onScreen then
                    local startPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    local endPos = Vector2.new(screenPos.X, screenPos.Y)
                    
                    tracer.From = startPos
                    tracer.To = endPos
                    tracer.Color = ESPColor
                    tracer.Thickness = 1.5
                    tracer.Transparency = 0.3
                    tracer.Visible = true
                else
                    tracer.Visible = false
                end
            else
                tracer.Visible = false
            end
        end)
        
        tracerData.drawing = tracer
        tracerData.connection = tracerConnection
        tracerData.player = player
        
        ESPTracers[player] = tracerData
        
        return tracerData
    end

    local function createNametag(player, color)
        local drawings = {}
        local character = player.Character
        if not character then return drawings end
        
        local head = character:FindFirstChild("Head")
        if not head then return drawings end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESPName"
        billboard.Size = UDim2.new(0, 100, 0, 20)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = player.Name
        label.TextColor3 = color
        label.TextScaled = true
        label.Font = Enum.Font.SourceSansBold
        label.TextStrokeColor3 = Color3.new(0, 0, 0)
        label.TextStrokeTransparency = 0.5
        label.Parent = billboard
        
        table.insert(drawings, billboard)
        
        return drawings
    end

    local function clearAllESP()
        clearAllTracers()

        if ESPRefreshConnection then
            ESPRefreshConnection:Disconnect()
            ESPRefreshConnection = nil
        end
        
        for _, conn in pairs(ESPConnections) do
            if conn and typeof(conn) == "RBXScriptConnection" then
                pcall(function() conn:Disconnect() end)
            end
        end
        ESPConnections = {}

        for _, drawings in pairs(ESPDrawings) do
            if drawings then
                for _, obj in pairs(drawings) do
                    if obj then
                        pcall(function()
                            if typeof(obj) == "Instance" then
                                if obj.Parent then
                                    obj:Destroy()
                                end
                            elseif typeof(obj) == "Drawing" then
                                obj:Remove()
                            end
                        end)
                    end
                end
            end
        end
        ESPDrawings = {}
        

        for _, player in pairs(Players:GetPlayers()) do
            if player and player.Character then
                for _, obj in pairs(player.Character:GetDescendants()) do
                    if obj.Name == "ESPPerfectOutline" or 
                       obj.Name == "ESPChams" or 
                       obj.Name == "ESPName" then
                        pcall(function() obj:Destroy() end)
                    end
                end
            end
        end
    end


    local function updateTracerColors(color)
        for _, tracerData in pairs(ESPTracers) do
            if tracerData.drawing then
                tracerData.drawing.Color = color
            end
        end
    end

    local function createESP(player)
        if player == LocalPlayer then return end
        
        if ESPDrawings[player] then
            for _, obj in pairs(ESPDrawings[player]) do
                if obj then
                    pcall(function()
                        if typeof(obj) == "Instance" then
                            if obj.Parent then obj:Destroy() end
                        elseif typeof(obj) == "Drawing" then
                            obj:Remove()
                        end
                    end)
                end
            end
        end
        
        if ESPTracers[player] then
            if ESPTracers[player].connection then
                pcall(function() ESPTracers[player].connection:Disconnect() end)
            end
            if ESPTracers[player].drawing then
                pcall(function() ESPTracers[player].drawing:Remove() end)
            end
            ESPTracers[player] = nil
        end
        
        local drawings = {}
        ESPDrawings[player] = drawings

        local function updateESP()
            local character = player.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then return end
            for _, obj in pairs(character:GetDescendants()) do
                if obj.Name == "ESPPerfectOutline" or 
                   obj.Name == "ESPChams" or 
                   obj.Name == "ESPName" then
                    pcall(function() obj:Destroy() end)
                end
            end

            local displayColor = ESPColor
            
            if ChamsEnabled then
                local chamsDrawings = createChamsEffect(character, displayColor)
                for _, drawing in pairs(chamsDrawings) do
                    table.insert(drawings, drawing)
                end
            else
                local outlineDrawings = createPerfectOutline(character, displayColor)
                for _, drawing in pairs(outlineDrawings) do
                    table.insert(drawings, drawing)
                end
            end
            
            local nameDrawings = createNametag(player, displayColor)
            for _, drawing in pairs(nameDrawings) do
                table.insert(drawings, drawing)
            end
            
            if TracersEnabled and not ESPTracers[player] then
                createTracers(player, displayColor)
            end
        end

        updateESP()

        local respawnConnection = player.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            updateESP()
        end)
        table.insert(ESPConnections, respawnConnection)
    end

    local function refreshAllESP()
        if not ESPEnabled then return end
        clearAllESP()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createESP(player)
            end
        end
        
        if not ESPRefreshConnection then
            ESPRefreshConnection = RunService.Heartbeat:Connect(function()
            end)
        end
    end
    
    local lastRefresh = 0
    RunService.Heartbeat:Connect(function()
        if ESPEnabled then
            local currentTime = tick()
            if currentTime - lastRefresh >= 1 then
                lastRefresh = currentTime
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        createESP(player)
                    end
                end
            end
        end
    end)

    local ESPTab = Window:CreateTab("| ESP", 6523858394)

    ESPTab:CreateToggle({
        Name = "Enable ESP",
        Flag = "ESPEnabled",
        CurrentValue = false,
        Callback = function(state)
            ESPEnabled = state
            if state then
                refreshAllESP()
                lastRefresh = 0
            
                local playerAddedConnection = Players.PlayerAdded:Connect(function(player)
                    if ESPEnabled then
                        local function setupNewPlayer()
                            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                createESP(player)
                            else
                                player.CharacterAdded:Wait()
                                task.wait(0.5)
                                createESP(player)
                            end
                        end
                        task.spawn(setupNewPlayer)
                    end
                end)
                table.insert(ESPConnections, playerAddedConnection)
                
                local playerRemovingConnection = Players.PlayerRemoving:Connect(function(player)
                    if ESPDrawings[player] then
                        for _, obj in pairs(ESPDrawings[player]) do
                            if obj then
                                pcall(function()
                                    if typeof(obj) == "Instance" then
                                        if obj.Parent then obj:Destroy() end
                                    elseif typeof(obj) == "Drawing" then
                                        obj:Remove()
                                    end
                                end)
                            end
                        end
                        ESPDrawings[player] = nil
                    end
                    if ESPTracers[player] then
                        if ESPTracers[player].connection then
                            pcall(function() ESPTracers[player].connection:Disconnect() end)
                        end
                        if ESPTracers[player].drawing then
                            pcall(function() ESPTracers[player].drawing:Remove() end)
                        end
                        ESPTracers[player] = nil
                    end
                end)
                table.insert(ESPConnections, playerRemovingConnection)
            else
                clearAllESP()
                lastRefresh = 0
            end
        end
    })

    ESPTab:CreateToggle({
        Name = "Chams (See Through Walls)",
        Flag = "ChamsEnabled",
        CurrentValue = false,
        Callback = function(state)
            ChamsEnabled = state
            if ESPEnabled then
                refreshAllESP()
            end
        end
    })

    ESPTab:CreateToggle({
        Name = "Enable Tracers",
        Flag = "TracersEnabled",
        CurrentValue = false,
        Callback = function(state)
            TracersEnabled = state
            if not state then
                clearAllTracers()
            end
            if ESPEnabled then
                refreshAllESP()
            end
        end
    })

    local colorNames = {}
    for name, _ in pairs(ESPColors) do
        table.insert(colorNames, name)
    end

    ESPTab:CreateDropdown({
        Name = "ESP Color",
        Options = colorNames,
        Flag = "ESPColor",
        CurrentOption = {"Red"},
        MultipleOptions = false,
        Callback = function(option)
            local colorName = option
            if type(option) == "table" then
                colorName = option[1]
            end
            if ESPColors[colorName] then
                ESPColor = ESPColors[colorName]
                updateTracerColors(ESPColor)
                if ESPEnabled then
                    refreshAllESP()
                end
            end
        end
    })

    ESPTab:CreateButton({
        Name = "Clear All ESP",
        Callback = function()
            clearAllESP()
            if ESPEnabled then
                refreshAllESP()
            end
        end
    })

    ESPTab:CreateButton({
        Name = "Force Clear ESP",
        Callback = function()
            ESPEnabled = false
            TracersEnabled = false
            ChamsEnabled = false
            clearAllESP()
            
            Rayfield:Notify({
                Title = "ESP Cleared",
                Content = "All ESP elements have been force cleaned",
                Duration = 2,
                Image = 4483362458
            })
        end
    })

    local NoFallEnabled = false
    local NoFallConnections = {}

    MainTab:CreateToggle({
        Name = "No Fall Damage",
        Flag = "NoFallEnabled",
        CurrentValue = false,
        Callback = function(state)
            NoFallEnabled = state

            for _, conn in pairs(NoFallConnections) do
                if typeof(conn) == "RBXScriptConnection" then
                    conn:Disconnect()
                end
            end
            table.clear(NoFallConnections)

            if not state then return end

            table.insert(NoFallConnections, game:GetService("RunService").Stepped:Connect(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    if hrp.Velocity.Y < -50 then
                        hrp.Velocity = Vector3.new(hrp.Velocity.X, -50, hrp.Velocity.Z)
                    end
                end
            end))

            local function protectHumanoid(humanoid)
                table.insert(NoFallConnections, humanoid.StateChanged:Connect(function(_, new)
                    if NoFallEnabled and (new == Enum.HumanoidStateType.Freefall or new == Enum.HumanoidStateType.FallingDown) then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end))
            end

            local function setupCharacter(char)
                local humanoid = char:WaitForChild("Humanoid", 5)
                if humanoid then
                    protectHumanoid(humanoid)
                end
            end

            local plr = game.Players.LocalPlayer
            if plr.Character then setupCharacter(plr.Character) end

            table.insert(NoFallConnections, plr.CharacterAdded:Connect(function(char)
                setupCharacter(char)
            end))

            table.insert(NoFallConnections, game:GetService("RunService").Heartbeat:Connect(function()
                local char = plr.Character
                if NoFallEnabled and char and char:FindFirstChild("Humanoid") then
                    local hum = char.Humanoid
                    if hum:GetState() == Enum.HumanoidStateType.Freefall then
                        hum.Sit = true
                    end
                end
            end))
        end
    })


local InfiniteJumpEnabled = false
local JumpConnection
local LastJumpTime = 0

    MainTab:CreateToggle({
        Name = "Infinite Jump",
        Flag = "InfiniteJumpEnabled",
        CurrentValue = false,
        Callback = function(state)
            InfiniteJumpEnabled = state

            if InfiniteJumpEnabled then
                JumpConnection = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
                    if not gameProcessed and input.KeyCode == Enum.KeyCode.Space then
                        local character = game.Players.LocalPlayer.Character
                        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                        
                        if humanoid and rootPart then
                           local currentTime = tick()
                        
                            if currentTime - LastJumpTime < 0.1 then return end
                           LastJumpTime = currentTime
                        
                            if noclipEnabled then
                                rootPart.Velocity = Vector3.new(rootPart.Velocity.X, 50, rootPart.Velocity.Z)
                            else
                                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                            end
                        end
                    end
                end)
            else
                if JumpConnection then
                    JumpConnection:Disconnect()
                    JumpConnection = nil
                end
            end
        end
    })



    local AntiAFKEnabled = false
    local JumpConnection

    MainTab:CreateToggle({
        Name = "Anti-AFK (Auto Jump)",
        Flag = "AntiAFKEnabled",
        CurrentValue = false,
        Callback = function(state)
            AntiAFKEnabled = state

            if AntiAFKEnabled then
                JumpConnection = task.spawn(function()
                    while AntiAFKEnabled do
                        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        end
                        task.wait(5)
                    end
                end)
            else
                if JumpConnection then
                    task.cancel(JumpConnection)
                    JumpConnection = nil
                end
            end
        end,
    })

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

    local InvisTab = Window:CreateTab("| Invisibility", 4483362458)
    local invisEnabled = false
    local invisTransparency = 0.75
    local seatTeleportPosition = Vector3.new(-25.95, 400, 3537.55)
    local currentSeat = nil
    local seatReturnConnection = nil

    local function setCharTransparency(transparency)
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = transparency
                end
            end
        end
    end

    local function stopInvisibility()
        setCharTransparency(0)
        
        if currentSeat then
            pcall(function() currentSeat:Destroy() end)
            currentSeat = nil
        end
        
        if seatReturnConnection then
            seatReturnConnection:Disconnect()
            seatReturnConnection = nil
        end
    end

    local function startInvisibility()
        local player = game.Players.LocalPlayer
        local char = player.Character
        
        if not char then
            Rayfield:Notify({
                Title = "Invisibility Failed",
                Content = "Character not found!",
                Duration = 3,
                Image = 4483362458
            })
            invisEnabled = false
            return
        end
        
        setCharTransparency(invisTransparency)
        
        local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            Rayfield:Notify({
                Title = "Invisibility",
                Content = "Character is semi-transparent (no RootPart for seat)",
                Duration = 3,
                Image = 4483362458
            })
            return
        end

        local savedPos = humanoidRootPart.CFrame
        
        pcall(function() char:MoveTo(seatTeleportPosition) end)
        task.wait(0.1)

        if not char:FindFirstChild("HumanoidRootPart") or char.HumanoidRootPart.Position.Y < -50 then
            pcall(function() char:MoveTo(savedPos) end)
            setCharTransparency(0)
            Rayfield:Notify({
                Title = "Invisibility Failed",
                Content = "Teleport to seat failed - void detected",
                Duration = 3,
                Image = 4483362458
            })
            invisEnabled = false
            return
        end
        
        local seat = Instance.new('Seat')
        seat.Parent = workspace
        seat.Anchored = false
        seat.CanCollide = false
        seat.Name = 'InvisSeat'
        seat.Transparency = 1
        seat.Position = seatTeleportPosition
        currentSeat = seat
        
        local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
        if torso then
            local weld = Instance.new("Weld")
            weld.Part0 = seat
            weld.Part1 = torso
            weld.Parent = seat
            
            task.wait()
            pcall(function() seat.CFrame = savedPos end)
            
            seatReturnConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if currentSeat and char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    if (hrp.Position - currentSeat.Position).Magnitude > 10 then
                        pcall(function() hrp.CFrame = currentSeat.CFrame end)
                    end
                end
            end)
            
            Rayfield:Notify({
                Title = "Invisibility Enabled",
                Content = "Character is now invisible",
                Duration = 2,
                Image = 4483362458
            })
        else
            seat:Destroy()
            currentSeat = nil
            Rayfield:Notify({
                Title = "Invisibility",
                Content = "Semi-transparent but torso missing for seat",
                Duration = 3,
                Image = 4483362458
            })
        end
    end

    InvisTab:CreateToggle({
        Name = "Enable Invisibility",
        Flag = "InvisEnabled",
        CurrentValue = false,
        Callback = function(state)
            invisEnabled = state
            
            if invisEnabled then
                startInvisibility()
            else
                stopInvisibility()
            end
        end
    })

    InvisTab:CreateSlider({
        Name = "Invisibility Transparency",
        Range = {0, 100},
        Increment = 5,
        Suffix = "%",
        Flag = "InvisTransparency",
        CurrentValue = 75,
        Callback = function(value)
            invisTransparency = value / 100
            
            if invisEnabled then
                setCharTransparency(invisTransparency)
            end
        end
    })

    game.Players.LocalPlayer.CharacterAdded:Connect(function()
        if invisEnabled then
            stopInvisibility()
            task.wait(0.5)
            startInvisibility()
        end
    end)
    

local AimbotEnabled = false
local MouseAimbotEnabled = false
local ShowFOV = false
local FOVRadius = 100
local DynamicFOVRadius = FOVRadius
local FOVCircle
local AimbotKey = "T"
local Smoothness = 0.2
local CurrentTarget = nil
local MaxFOVIncrease = 1.5
local MouseSensitivity = 1.0
local TriggerbotCrosshairEnabled = false
local TriggerbotMouseEnabled = false
local TriggerbotCrosshairPressed = false
local TriggerbotMousePressed = false
local PredictionEnabled = false
local PredictionAmount = 0.1

local AimbotTab = Window:CreateTab("| Aimbot", 10769687353)

-- Smooth RGB Color Cycle
local function GetRGBColor()
    local time = tick() * 0.5
    local r = (math.sin(time) + 1) / 2
    local g = (math.sin(time + 2 * math.pi / 3) + 1) / 2
    local b = (math.sin(time + 4 * math.pi / 3) + 1) / 2
    return Color3.new(r, g, b)
end

local function CreateFOVCircle()
    if FOVCircle then
        FOVCircle:Remove()
        FOVCircle = nil
    end
    if ShowFOV then
        FOVCircle = Drawing.new("Circle")
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Radius = DynamicFOVRadius
        FOVCircle.Thickness = 2
        FOVCircle.Color = GetRGBColor()
        FOVCircle.Filled = false
        FOVCircle.Visible = true
    end
end

RunService.RenderStepped:Connect(function()
    if FOVCircle and ShowFOV then
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Radius = DynamicFOVRadius
        FOVCircle.Color = GetRGBColor()
    elseif not ShowFOV and FOVCircle then
        FOVCircle:Remove()
        FOVCircle = nil
    end
end)

-- Your existing variables (add these if missing)
local TriggerbotCrosshairLastShot = 0
local TriggerbotMouseLastShot = 0
local TriggerbotCPS = 12  -- slightly higher feels snappier but still controllable
local TriggerbotClickInterval = 1 / TriggerbotCPS

-- ================== BETTER TRIGGERBOT (Combined + Visibility Check) ==================
local function isValidTarget(char)
    if not char or char == LocalPlayer.Character then return false end
    if not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then return false end
    -- Add team check here if you want: if LocalPlayer.Team == char:FindFirstChild("Team")?.Value then return false end
    return true
end

RunService.RenderStepped:Connect(function()
    local currentTime = tick()
    if currentTime - math.max(TriggerbotCrosshairLastShot, TriggerbotMouseLastShot) < TriggerbotClickInterval then
        return
    end

    local shouldShoot = false

    -- Crosshair Triggerbot (more reliable than old version)
    if TriggerbotCrosshairEnabled then
        local viewportCenter = Camera.ViewportSize / 2
        local ray = Camera:ViewportPointToRay(viewportCenter.X, viewportCenter.Y)

        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {LocalPlayer.Character or {}}
        params.FilterType = Enum.RaycastFilterType.Exclude

        local result = Workspace:Raycast(ray.Origin, ray.Direction * 500, params)
        if result and result.Instance then
            local model = result.Instance:FindFirstAncestorWhichIsA("Model") or result.Instance.Parent
            if isValidTarget(model) then
                -- Optional small screen check
                local _, onScreen = Camera:WorldToViewportPoint(result.Position)
                if onScreen then
                    shouldShoot = true
                end
            end
        end
    end

    -- Mouse Triggerbot (fallback)
    if TriggerbotMouseEnabled and not shouldShoot then
        local mouse = LocalPlayer:GetMouse()
        if mouse.Target then
            local model = mouse.Target:FindFirstAncestorWhichIsA("Model") or mouse.Target.Parent
            if isValidTarget(model) then
                shouldShoot = true
            end
        end
    end

    if shouldShoot then
        local now = tick()
        TriggerbotCrosshairLastShot = now
        TriggerbotMouseLastShot = now

        -- More reliable clicking (many executors prefer VirtualInputManager)
        local vim = game:GetService("VirtualInputManager")
        vim:SendMouseButtonEvent(0, 0, 0, true, game, 1)   -- press
        task.wait(0.001)  -- tiny delay
        vim:SendMouseButtonEvent(0, 0, 0, false, game, 1)  -- release
        -- Fallback if VirtualInputManager doesn't work in your executor:
        -- mouse1press()
        -- mouse1release()
    end
end)


    -- Prediction Toggle
AimbotTab:CreateToggle({
    Name = "Enable Prediction",
    Flag = "PredictionEnabled",
    CurrentValue = false,
    Callback = function(Value)
        PredictionEnabled = Value
    end
})

-- Prediction Amount Slider
AimbotTab:CreateSlider({
    Name = "Prediction Amount",
    Range = {0.01, 0.5},
    Flag = "PredictionAmount",
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = 0.1,
    Callback = function(Value)
        PredictionAmount = Value
    end
})

local function getMousePosition()
    return UserInputService:GetMouseLocation()
end

local function moveMouseTo(targetX, targetY)
    local currentMousePos = getMousePosition()
    local deltaX = targetX - currentMousePos.X
    local deltaY = targetY - currentMousePos.Y

    local smoothFactor = math.clamp(Smoothness * 10, 1, 20)
    local moveX = deltaX / smoothFactor
    local moveY = deltaY / smoothFactor

    mousemoverel(moveX * MouseSensitivity, moveY * MouseSensitivity)
end

local function GetClosestPlayerForMouse()
    local closestPlayer = CurrentTarget
    local shortestDistance = DynamicFOVRadius * 1.5
    local mousePos = getMousePosition()

    if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
        local head = closestPlayer.Character.Head
        local headPos = head.Position
        
        if PredictionEnabled then
            headPos = head.Position + head.Velocity * PredictionAmount
        end
        
        local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
        if onScreen then
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
            if distance > shortestDistance then
                closestPlayer = nil
            end
        else
            closestPlayer = nil
        end
    else
        closestPlayer = nil
    end

    if not closestPlayer then
        shortestDistance = DynamicFOVRadius
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                local headPos = head.Position
                
                if PredictionEnabled then
                    headPos = head.Position + head.Velocity * PredictionAmount
                end
                
                local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < shortestDistance then
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end

    CurrentTarget = closestPlayer
    return closestPlayer
end

RunService.RenderStepped:Connect(function(deltaTime)
    if MouseAimbotEnabled then
        local target = GetClosestPlayerForMouse()
        DynamicFOVRadius = FOVRadius
        
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head
            local headPos = head.Position
            
            local velocity = head.Velocity
            local prediction = headPos
            if PredictionEnabled then
                prediction = headPos + velocity * PredictionAmount
            end
            
            local screenPos, onScreen = Camera:WorldToViewportPoint(prediction)
            
            if onScreen then
                local mousePos = getMousePosition()
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                
                if distance > FOVRadius * 0.8 then
                    DynamicFOVRadius = math.min(FOVRadius * MaxFOVIncrease, FOVRadius + distance)
                end

                if distance <= DynamicFOVRadius then
                    moveMouseTo(screenPos.X, screenPos.Y)
                end
            end
        end
    end
end)

local function GetClosestPlayer()
    local closestPlayer = CurrentTarget
    local shortestDistance = DynamicFOVRadius * 1.5
    local cameraCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
        local head = closestPlayer.Character.Head
        local headPos = head.Position
        
        if PredictionEnabled then
            headPos = head.Position + head.Velocity * PredictionAmount
        end
        
        local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
        if onScreen then
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - cameraCenter).Magnitude
            if distance > shortestDistance then
                closestPlayer = nil
            end
        else
            closestPlayer = nil
        end
    else
        closestPlayer = nil
    end

    if not closestPlayer then
        shortestDistance = DynamicFOVRadius
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                local headPos = head.Position
                
                if PredictionEnabled then
                    headPos = head.Position + head.Velocity * PredictionAmount
                end
                
                local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - cameraCenter).Magnitude
                    if distance < shortestDistance then
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end

    CurrentTarget = closestPlayer
    return closestPlayer
end

RunService.RenderStepped:Connect(function(deltaTime)
    if AimbotEnabled then
        local target = GetClosestPlayer()
        DynamicFOVRadius = FOVRadius
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head
            local headPos = head.Position
            local velocity = head.Velocity
            local prediction = headPos
            if PredictionEnabled then
                prediction = headPos + velocity * PredictionAmount
            end
            local targetCFrame = CFrame.new(Camera.CFrame.Position, prediction)

            local headScreenPos, _ = Camera:WorldToViewportPoint(headPos)
            local distance = (Vector2.new(headScreenPos.X, headScreenPos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
            local speed = velocity.Magnitude
            local dynamicSmoothness = math.clamp(Smoothness * (1 + distance / FOVRadius + speed / 50), 0.05, 0.5)

            if distance > FOVRadius * 0.8 then
                DynamicFOVRadius = math.min(FOVRadius * MaxFOVIncrease, FOVRadius + distance)
            end

            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, dynamicSmoothness)
        end
    end
end)

AimbotTab:CreateToggle({
    Name = "Enable Mouse Aimbot (PC)",
    Flag = "MouseAimbotEnabled",
    CurrentValue = false,
    Callback = function(Value)
        MouseAimbotEnabled = Value
        if Value then
            AimbotEnabled = false
        end
    end
})

AimbotTab:CreateToggle({
    Name = "Enable Camera Aimbot (PC)",
    Flag = "CamAimbotEnabled",
    CurrentValue = false,
    Callback = function(Value)
        AimbotEnabled = Value
        if Value then
            MouseAimbotEnabled = false
        end
    end
})

-- Crosshair Triggerbot Toggle
AimbotTab:CreateToggle({
    Name = "Triggerbot (Crosshair)",
    Flag = "TriggerbotCrosshairEnabled",
    CurrentValue = false,
    Callback = function(Value)
        TriggerbotCrosshairEnabled = Value
        if not Value and TriggerbotCrosshairPressed then
            TriggerbotCrosshairPressed = false
            mouse1release()
        end
    end
})

-- Mouse Triggerbot Toggle
AimbotTab:CreateToggle({
    Name = "Triggerbot (Mouse)",
    Flag = "TriggerbotMouseEnabled",
    CurrentValue = false,
    Callback = function(Value)
        TriggerbotMouseEnabled = Value
        if not Value and TriggerbotMousePressed then
            TriggerbotMousePressed = false
            mouse1release()
        end
    end
})

AimbotTab:CreateToggle({
    Name = "Show FOV Circle",
    Flag = "FOVCircleEnabled",
    CurrentValue = false,
    Callback = function(Value)
        ShowFOV = Value
        CreateFOVCircle()
    end
})

AimbotTab:CreateSlider({
    Name = "FOV Changer",
    Range = {50, 500},
    Increment = 10,
    Flag = "FOVRadius",
    Suffix = "px",
    CurrentValue = 100,
    Callback = function(Value)
        FOVRadius = Value
        DynamicFOVRadius = Value
        CreateFOVCircle()
    end
})

AimbotTab:CreateSlider({
    Name = "Aimbot Smoothness",
    Range = {0.05, 1},
    Flag = "AimbotSmoothness",
    Increment = 0.01,
    Suffix = "factor",
    CurrentValue = 0.2,
    Callback = function(Value)
        Smoothness = Value
    end
})

AimbotTab:CreateSlider({
    Name = "Mouse Sensitivity",
    Range = {0.1, 2},
    Increment = 0.1,
    Flag = "MouseSensitivity",
    Suffix = "x",
    CurrentValue = 1.0,
    Callback = function(Value)
        MouseSensitivity = Value
    end
})

AimbotTab:CreateInput({
    Name = "Aimbot Key (PC)",
    PlaceholderText = "Default: T",
    Flag = "AimbotKey",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text and #Text > 0 then
            AimbotKey = Text:upper()
        end
    end
})

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode.Name == AimbotKey then
            AimbotEnabled = not AimbotEnabled
        end
    end
end)

local PhoneGui
local PhoneToggleButton

local function CreatePhoneGui()
    PhoneGui = Instance.new("ScreenGui")
    PhoneGui.Name = "PhoneAimbotGui"
    PhoneGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.25, 0, 0.12, 0)
    Frame.Position = UDim2.new(0.7, 0, 0.45, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BackgroundTransparency = 0.2
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = PhoneGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 15)

    PhoneToggleButton = Instance.new("TextButton")
    PhoneToggleButton.Size = UDim2.new(0.8, 0, 0.6, 0)
    PhoneToggleButton.Position = UDim2.new(0.1, 0, 0.2, 0)
    PhoneToggleButton.Text = AimbotEnabled and "ON" or "OFF"
    PhoneToggleButton.TextScaled = true
    PhoneToggleButton.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    PhoneToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    PhoneToggleButton.Parent = Frame
    Instance.new("UICorner", PhoneToggleButton).CornerRadius = UDim.new(0, 10)

    PhoneToggleButton.MouseButton1Click:Connect(function()
        AimbotEnabled = not AimbotEnabled
        ShowFOV = AimbotEnabled
        PhoneToggleButton.Text = AimbotEnabled and "ON" or "OFF"
        PhoneToggleButton.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        CreateFOVCircle()
    end)
end

local function RemovePhoneGui()
    if PhoneGui then
        PhoneGui:Destroy()
        PhoneGui = nil
    end
end

AimbotTab:CreateToggle({
    Name = "Phone Aimbot GUI",
    Flag = "PhoneAimbotGuiEnabled",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            if not PhoneGui then
                CreatePhoneGui()
            end
        else
            RemovePhoneGui()
        end
    end
})

local TeleportTab = Window:CreateTab("| Teleport", 138281706845765)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local selectedPlayerName = nil
local customTeleportPosition = nil
local customSpawnPosition = nil
local clickTeleportEnabled = false
local touchTeleportEnabled = false

local PlayerDropdown = TeleportTab:CreateDropdown({
    Name = "Teleport to Player",
    Options = {},
    CurrentOption = nil,
    Callback = function(option)
        if typeof(option) == "string" then
            selectedPlayerName = option
        elseif typeof(option) == "table" and typeof(option[1]) == "string" then
            selectedPlayerName = option[1]
        end
    end,
})

TeleportTab:CreateButton({
    Name = "Teleport",
    Callback = function()
        if not selectedPlayerName then
            Rayfield:Notify({
                Title = "Error",
                Content = "No player selected.",
                Duration = 3
            })
            return
        end

        local target = Players:FindFirstChild(selectedPlayerName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        else
            Rayfield:Notify({
                Title = "Teleport Error",
                Content = "Player not found or missing HumanoidRootPart.",
                Duration = 4
            })
        end
    end
})

local function UpdateDropdown()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    PlayerDropdown:Refresh(names, true)
end

UpdateDropdown()

Players.PlayerAdded:Connect(function()
    task.wait(0.2)
    UpdateDropdown()
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.2)
    UpdateDropdown()
end)

local function setTeleportPoint()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        customTeleportPosition = LocalPlayer.Character.HumanoidRootPart.Position
        Rayfield:Notify({
            Title = "TPpoint Set",
            Content = "Position: " .. tostring(customTeleportPosition),
            Duration = 5,
            Image = 4483362458
        })
    else
        Rayfield:Notify({
            Title = "Error",
            Content = "HumanoidRootPart not found! Please report in our Discord.",
            Duration = 5,
            Image = 4483362458
        })
    end
end

local function setSpawnPoint()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        customSpawnPosition = LocalPlayer.Character.HumanoidRootPart.Position
        Rayfield:Notify({
            Title = "Spawn Point Set",
            Content = "Spawn Position: " .. tostring(customSpawnPosition),
            Duration = 5,
            Image = 4483362458
        })
    else
        Rayfield:Notify({
            Title = "Error",
            Content = "HumanoidRootPart not found! Please report in our Discord.",
            Duration = 5,
            Image = 4483362458
        })
    end
end

LocalPlayer.CharacterAdded:Connect(function(character)
    if customSpawnPosition then
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(customSpawnPosition + Vector3.new(0, 5, 0))
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and clickTeleportEnabled and not gameProcessedEvent then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local mouse = LocalPlayer:GetMouse()
            local ray = workspace.CurrentCamera:ScreenPointToRay(mouse.X, mouse.Y)
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            local raycastResult = workspace:Raycast(ray.Origin, ray.Direction * 1000, raycastParams)
            
            if raycastResult then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(raycastResult.Position + Vector3.new(0, 5, 0))
                Rayfield:Notify({
                    Title = "Click Teleport",
                    Content = "Teleported to clicked position!",
                    Duration = 4,
                    Image = 4483362458
                })
            else
                Rayfield:Notify({
                    Title = "Click Teleport Failed",
                    Content = "No valid surface found at clicked position.",
                    Duration = 4,
                    Image = 4483362458
                })
            end
        end
    end
end)

UserInputService.TouchTap:Connect(function(touchPositions, gameProcessedEvent)
    if touchTeleportEnabled and not gameProcessedEvent and #touchPositions > 0 then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local touchPos = touchPositions[1] -- Use the first touch position
            local ray = workspace.CurrentCamera:ScreenPointToRay(touchPos.X, touchPos.Y)
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            local raycastResult = workspace:Raycast(ray.Origin, ray.Direction * 1000, raycastParams)
            
            if raycastResult then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(raycastResult.Position + Vector3.new(0, 5, 0))
                Rayfield:Notify({
                    Title = "Touch Teleport",
                    Content = "Teleported to tapped position!",
                    Duration = 4,
                    Image = 4483362458
                })
            else
                Rayfield:Notify({
                    Title = "Touch Teleport Failed",
                    Content = "No valid surface found at tapped position.",
                    Duration = 4,
                    Image = 4483362458
                })
            end
        end
    end
end)

TeleportTab:CreateButton({
    Name = "Set TPpoint",
    Callback = setTeleportPoint
})

TeleportTab:CreateButton({
    Name = "Teleport to TPpoint",
    Callback = function()
        if customTeleportPosition and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(customTeleportPosition + Vector3.new(0, 5, 0))
            Rayfield:Notify({
                Title = "Teleported!",
                Content = "You have been moved to your saved TPpoint.",
                Duration = 4,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Teleport Failed",
                Content = "Make sure you set a TPpoint first.",
                Duration = 4,
                Image = 4483362458
            })
        end
    end
})

TeleportTab:CreateButton({
    Name = "Change Spawn Point",
    Callback = setSpawnPoint
})

TeleportTab:CreateToggle({
    Name = "Enable Click TP",
    Flag = "ClickTpEnabled",
    CurrentValue = false,
    Callback = function(value)
        clickTeleportEnabled = value
        Rayfield:Notify({
            Title = "Click TP",
            Content = value and "Click TP enabled. Click anywhere to teleport." or "Click TP disabled.",
            Duration = 4,
            Image = 4483362458
        })
    end
})

TeleportTab:CreateToggle({
    Name = "Enable Click TP (Phone)",
    Flag = "ClickTPPhoneEnabled",
    CurrentValue = false,
    Callback = function(value)
        touchTeleportEnabled = value
        Rayfield:Notify({
            Title = "Touch TP",
            Content = value and "Touch TP enabled. Tap anywhere to teleport." or "Touch TP disabled.",
            Duration = 4,
            Image = 4483362458
        })
    end
})

local function GetVehicleFromDescendant(Descendant)
	return
		Descendant:FindFirstAncestor(LocalPlayer.Name .. "'s Car") or
		(Descendant:FindFirstAncestor("Body") and Descendant:FindFirstAncestor("Body").Parent) or
		(Descendant:FindFirstAncestor("Misc") and Descendant:FindFirstAncestor("Misc").Parent) or
		Descendant:FindFirstAncestorWhichIsA("Model")
end

local flightEnabled = false
local throttleEnabled = false
local brakeEnabled = false
local stopEnabled = false

local flightSpeed = 1
local accelPower = 0.025
local brakePower = 0.15

local vehicleTab = Window:CreateTab("| Vehicle", 13773498965)

vehicleTab:CreateToggle({
	Name = "Flight Mode (move with WASD + QE)",
    Flag = "FlightModeEnabled",
	CurrentValue = false,
	Callback = function(v)
		flightEnabled = v
	end
})

vehicleTab:CreateToggle({
	Name = "Full Throttle (triggered with W)",
    Flag = "FullThrottleEnabled",
	CurrentValue = false,
	Callback = function(v)
		throttleEnabled = v
	end
})

vehicleTab:CreateToggle({
	Name = "Quick Brake (triggered with S)",
    Flag = "QuickBrakeEnabled",
	CurrentValue = false,
	Callback = function(v)
		brakeEnabled = v
	end
})

vehicleTab:CreateToggle({
	Name = "Stop Vehicle",
	CurrentValue = false,
	Callback = function(v)
		stopEnabled = v
		if v then
			local Character = LocalPlayer.Character
			if not Character then return end
			local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
			if not Humanoid or not Humanoid.SeatPart then return end
			local SeatPart = Humanoid.SeatPart
			if SeatPart:IsA("VehicleSeat") then
				SeatPart.AssemblyLinearVelocity = Vector3.zero
				SeatPart.AssemblyAngularVelocity = Vector3.zero
			end
		end
	end
})

vehicleTab:CreateSlider({
	Name = "Flight Speed",
    Flag = "FlightSpeed",
	Range = {0.5, 10},
	Increment = 0.5,
	CurrentValue = 1,
	Callback = function(v)
		flightSpeed = v
	end
})

vehicleTab:CreateSlider({
	Name = "Acceleration Power",
    Flag = "AccelerationPower",
	Range = {0.01, 0.1},
	Increment = 0.005,
	CurrentValue = 0.025,
	Callback = function(v)
		accelPower = v
	end
})

vehicleTab:CreateSlider({
	Name = "Brake Power",
    Flag = "BrakePower",
	Range = {0.05, 0.3},
	Increment = 0.01,
	CurrentValue = 0.15,
	Callback = function(v)
		brakePower = v
	end
})

RunService.Stepped:Connect(function()
	local Character = LocalPlayer.Character
	if not Character then return end
	local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
	if not Humanoid then return end
	local SeatPart = Humanoid.SeatPart
	if not SeatPart or not SeatPart:IsA("VehicleSeat") then return end
	local Vehicle = GetVehicleFromDescendant(SeatPart)
	if not Vehicle or not Vehicle:IsA("Model") then return end

	if flightEnabled then
		if not Vehicle.PrimaryPart then
			Vehicle.PrimaryPart = SeatPart or Vehicle:FindFirstChildWhichIsA("BasePart")
		end
		local PrimaryPartCFrame = Vehicle:GetPrimaryPartCFrame()
		local moveVec = Vector3.new()
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec += Vector3.new(0, 0, -flightSpeed) end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec += Vector3.new(0, 0, flightSpeed) end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec += Vector3.new(-flightSpeed, 0, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec += Vector3.new(flightSpeed, 0, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.E) then moveVec += Vector3.new(0, flightSpeed / 2, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.Q) then moveVec += Vector3.new(0, -flightSpeed / 2, 0) end

		if moveVec.Magnitude > 0 then
			Vehicle:SetPrimaryPartCFrame(CFrame.new(PrimaryPartCFrame.Position, PrimaryPartCFrame.Position + workspace.CurrentCamera.CFrame.LookVector) * CFrame.new(moveVec))
		end
		SeatPart.AssemblyLinearVelocity = Vector3.zero
		SeatPart.AssemblyAngularVelocity = Vector3.zero
	end
end)

task.spawn(function()
	while true do
		task.wait(0.02)
		local Character = LocalPlayer.Character
		if not Character then continue end
		local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
		if not Humanoid or not Humanoid.SeatPart or not Humanoid.SeatPart:IsA("VehicleSeat") then continue end
		local SeatPart = Humanoid.SeatPart
		local v = SeatPart.AssemblyLinearVelocity
		if throttleEnabled and UserInputService:IsKeyDown(Enum.KeyCode.W) and v then
			SeatPart.AssemblyLinearVelocity = Vector3.new(v.X * (1 + accelPower), v.Y, v.Z * (1 + accelPower))
		end
		if brakeEnabled and UserInputService:IsKeyDown(Enum.KeyCode.S) and v then
			SeatPart.AssemblyLinearVelocity = Vector3.new(v.X * (1 - brakePower), v.Y, v.Z * (1 - brakePower))
		end
	end
end)
   

    local CameraTab = Window:CreateTab("| Camera", 16060788318)

    local freecamEnabled = false
    local freecamKey = "F4"
    local freecamSpeed = 50
    local freecamConnection = nil
    local freecamPosition = nil
    local originalCameraCFrame = nil
    local originalCameraSubject = nil
    local originalWalkSpeed = 16
    local rightClickHeld = false
    local mouseLocked = false
    local cameraRotationX = 0
    local cameraRotationY = 0

    local function storeCameraState()
        originalCameraCFrame = Camera.CFrame
        originalCameraSubject = Camera.CameraSubject
        local lookVector = Camera.CFrame.LookVector
        cameraRotationY = math.asin(lookVector.Y)
        cameraRotationX = math.atan2(lookVector.X, lookVector.Z)
    end

    local function restoreCameraState()
        if originalCameraCFrame then
            Camera.CFrame = originalCameraCFrame
        end
        if originalCameraSubject then
            Camera.CameraSubject = originalCameraSubject
        end
    end

    local function lockCharacter()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                originalWalkSpeed = humanoid.WalkSpeed
                humanoid.WalkSpeed = 0
                humanoid.JumpPower = 0
            end
            
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.Anchored = true
            end

            if humanoid then
                humanoid.AutoRotate = false
            end
        end
    end

    local function unlockCharacter()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = originalWalkSpeed
                humanoid.JumpPower = 50
                humanoid.AutoRotate = true
            end

            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.Anchored = false
            end
        end
    end

    local function startFreecam()
        if freecamEnabled then return end
        freecamEnabled = true
        
        storeCameraState()
        
        freecamPosition = Camera.CFrame
        
        lockCharacter()
        
        Camera.CameraType = Enum.CameraType.Scriptable
        Camera.CameraSubject = nil
        
        Rayfield:Notify({
            Title = "Freecam Enabled",
            Content = "Right click to look around. Press " .. freecamKey .. " to disable",
            Duration = 3,
            Image = 16060788318
        })
    end

    local function stopFreecam()
        if not freecamEnabled then return end
        freecamEnabled = false
        
        freecamPosition = Camera.CFrame
        
        restoreCameraState()
        Camera.CameraType = Enum.CameraType.Custom

        unlockCharacter()

        if mouseLocked then
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            mouseLocked = false
        end
        rightClickHeld = false
        
        Rayfield:Notify({
            Title = "Freecam Disabled",
            Content = "Camera restored to normal",
            Duration = 2,
            Image = 16060788318
        })
    end

    local function toggleFreecam()
        if freecamEnabled then
            stopFreecam()
        else
            startFreecam()
        end
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not freecamEnabled then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            rightClickHeld = true
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            mouseLocked = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if not freecamEnabled then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            rightClickHeld = false
            if mouseLocked then
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                mouseLocked = false
            end
        end
    end)

    freecamConnection = RunService.RenderStepped:Connect(function()
        if not freecamEnabled then return end

        if rightClickHeld then
            local mouseDelta = UserInputService:GetMouseDelta()
            local sensitivity = 0.2

            cameraRotationX = cameraRotationX - math.rad(mouseDelta.X * sensitivity)
            cameraRotationY = math.clamp(cameraRotationY - math.rad(mouseDelta.Y * sensitivity), -math.rad(89), math.rad(89))

            local horizontalRotation = CFrame.Angles(0, cameraRotationX, 0)
            local verticalRotation = CFrame.Angles(cameraRotationY, 0, 0)

            Camera.CFrame = CFrame.new(Camera.CFrame.Position) * horizontalRotation * verticalRotation

            freecamPosition = Camera.CFrame
        end
        
        local moveVector = Vector3.new(0, 0, 0)
        local speed = freecamSpeed * 0.1
        
        local cameraForward = Camera.CFrame.LookVector
        local cameraRight = Camera.CFrame.RightVector
        
        local forward = Vector3.new(cameraForward.X, 0, cameraForward.Z).Unit
        local right = Vector3.new(cameraRight.X, 0, cameraRight.Z).Unit
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVector += forward
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVector -= forward
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVector -= right
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVector += right
        end
        
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveVector += Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveVector -= Vector3.new(0, 1, 0)
        end
        
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            speed = speed * 3
        end
        
        if moveVector.Magnitude > 0 then
            moveVector = moveVector.Unit
            Camera.CFrame = Camera.CFrame + (moveVector * speed)
            -- Update freecam position
            freecamPosition = Camera.CFrame
        end
    end)

    local function teleportToFreecam()
        if not freecamPosition then
            Rayfield:Notify({
                Title = "No Camera Position",
                Content = "Enable freecam first to set a camera position",
                Duration = 3,
                Image = 16060788318
            })
            return
        end
        
        local targetPos = freecamPosition.Position
        
        if freecamEnabled then
            stopFreecam()
        end
        
        task.wait()
        
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            Rayfield:Notify({
                Title = "Teleport Failed",
                Content = "Character not found! Waiting for respawn...",
                Duration = 3,
                Image = 16060788318
            })
            
            local newCharacter = LocalPlayer.CharacterAdded:Wait()
            task.wait(0.5)
            if newCharacter and newCharacter:FindFirstChild("HumanoidRootPart") then
                newCharacter.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
            end
            return
        end
        
        character.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
        
        Rayfield:Notify({
            Title = "Teleported!",
            Content = "Teleported to freecam position",
            Duration = 2,
            Image = 16060788318
        })
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode[freecamKey] then
            toggleFreecam()
        end
    end)

    CameraTab:CreateToggle({
        Name = "Enable Freecam",
        Flag = "FreecamEnabled",
        CurrentValue = false,
        Callback = function(state)
            if state then
                startFreecam()
            else
                stopFreecam()
            end
        end
    })

    CameraTab:CreateSlider({
        Name = "Freecam Speed",
        Flag = "FreecamSpeed",
        Range = {10, 500},
        Increment = 10,
        Suffix = " studs/s",
        CurrentValue = 50,
        Callback = function(value)
            freecamSpeed = value
        end
    })

    CameraTab:CreateInput({
        Name = "Freecam Toggle Key",
        Flag = "FreecamKey",
        PlaceholderText = "Default: F4",
        RemoveTextAfterFocusLost = false,
        Callback = function(text)
            if text and #text > 0 then
                freecamKey = text:upper()
                Rayfield:Notify({
                    Title = "Freecam Key Set",
                    Content = "Press " .. freecamKey .. " to toggle freecam",
                    Duration = 2,
                    Image = 4483362458
                })
            end
        end
    })

    CameraTab:CreateButton({
        Name = "Teleport to Freecam",
        Callback = function()
            teleportToFreecam()
        end
    })

    CameraTab:CreateParagraph({
        Title = "Freecam Controls",
        Content = [[

WASD - Move camera (horizontal)
Space - Move up
Left Shift - Move down
Left Ctrl - Speed boost (3x)
Hold Right Click - Look around
]] .. freecamKey .. [[ - Toggle freecam
        ]]
    })

    local SettingsTab = Window:CreateTab("| Settings", 6034509993)

    local ArrayListEnabled = false
    local ArrayListPosition = "Right Top"
    local ArrayListColor = "White"
    local ArrayListRainbow = false
    local ArrayListGui = nil
    local ArrayListFrame = nil
    local ArrayListUpdateConnection = nil
    local ArrayListLabels = {}
    local ArrayListAnimations = {}
    
    local ArrayListColors = {
        ["White"] = Color3.fromRGB(255, 255, 255),
        ["Red"] = Color3.fromRGB(255, 0, 0),
        ["Blue"] = Color3.fromRGB(0, 100, 255),
        ["Green"] = Color3.fromRGB(0, 255, 0),
        ["Yellow"] = Color3.fromRGB(255, 255, 0),
        ["Purple"] = Color3.fromRGB(150, 0, 255),
        ["Orange"] = Color3.fromRGB(255, 150, 0),
        ["Pink"] = Color3.fromRGB(255, 0, 150),
        ["Cyan"] = Color3.fromRGB(0, 255, 255),
        ["Rainbow"] = Color3.fromRGB(255, 255, 255)
    }
    
    local function getRainbowColor()
        local time = tick() * 3
        local r = (math.sin(time) + 1) / 2
        local g = (math.sin(time + 2 * math.pi / 3) + 1) / 2
        local b = (math.sin(time + 4 * math.pi / 3) + 1) / 2
        return Color3.fromRGB(r * 255, g * 255, b * 255)
    end

    local function animateLabelIn(label)
        label.BackgroundTransparency = 1
        label.TextTransparency = 1
        
        local startTime = tick()
        local animConnection
        animConnection = RunService.RenderStepped:Connect(function()
            local elapsed = tick() - startTime
            local duration = 0.3
            
            if elapsed >= duration then
                label.TextTransparency = 0
                animConnection:Disconnect()
                return
            end
            
            local alpha = elapsed / duration
            alpha = alpha * alpha * (3 - 2 * alpha)
            
            label.TextTransparency = 1 - alpha
        end)
        table.insert(ArrayListAnimations, animConnection)
    end

    -- Function to animate label color change
    local function pulseLabel(label)
        task.spawn(function()
            local originalSize = label.TextSize
            local startTime = tick()
            local duration = 0.2
            
            while label and label.Parent and tick() - startTime < duration do
                local elapsed = tick() - startTime
                local alpha = elapsed / duration
                local size = originalSize + (2 * math.sin(alpha * math.pi))
                label.TextSize = math.floor(size)
                task.wait()
            end
            
            if label and label.Parent then
                label.TextSize = originalSize
            end
        end)
    end

    local function getEnabledCheats()
        local cheats = {}
        
        if flying then table.insert(cheats, "Fly") end
        if noclipEnabled then table.insert(cheats, "Noclip") end
        if ESPEnabled then table.insert(cheats, "ESP") end
        if TracersEnabled then table.insert(cheats, "Tracers") end
        if ChamsEnabled then table.insert(cheats, "Chams") end
        if NoFallEnabled then table.insert(cheats, "NoFall") end
        if InfiniteJumpEnabled then table.insert(cheats, "InfJump") end
        if AntiAFKEnabled then table.insert(cheats, "AntiAFK") end
        if AimbotEnabled then table.insert(cheats, "CamAimbot") end
        if MouseAimbotEnabled then table.insert(cheats, "MouseAimbot") end
        if TriggerbotEnabled then table.insert(cheats, "Triggerbot") end
        if invisEnabled then table.insert(cheats, "Invis") end
        if freecamEnabled then table.insert(cheats, "Freecam") end
        if clickTeleportEnabled then table.insert(cheats, "ClickTP") end
        if touchTeleportEnabled then table.insert(cheats, "TouchTP") end
        if flightEnabled then table.insert(cheats, "VehicleFly") end
        if PredictionEnabled then table.insert(cheats, "Predict") end
        if ShowFOV then table.insert(cheats, "FOV") end
        
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            local hum = player.Character.Humanoid
            if hum.WalkSpeed > 16 then
                table.insert(cheats, "Speed:" .. tostring(hum.WalkSpeed))
            end
            if hum.JumpPower > 50 then
                table.insert(cheats, "Jump:" .. tostring(hum.JumpPower))
            end
        end
        
        table.sort(cheats, function(a, b) return a:lower() < b:lower() end)
        return cheats
    end

    local function createArrayList()
        if ArrayListGui then
            ArrayListGui:Destroy()
            ArrayListGui = nil
        end
        ArrayListLabels = {}

        for _, conn in pairs(ArrayListAnimations) do
            conn:Disconnect()
        end
        ArrayListAnimations = {}
        
        local player = game.Players.LocalPlayer
        if not player then return end
        
        ArrayListGui = Instance.new("ScreenGui")
        ArrayListGui.Name = "SilentArrayList"
        ArrayListGui.ResetOnSpawn = false
        ArrayListGui.DisplayOrder = 999
        ArrayListGui.IgnoreGuiInset = true
        ArrayListGui.Parent = player:WaitForChild("PlayerGui")
        
        ArrayListFrame = Instance.new("Frame")
        ArrayListFrame.Name = "Container"
        ArrayListFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        ArrayListFrame.BackgroundTransparency = 0.75
        ArrayListFrame.BorderSizePixel = 0
        ArrayListFrame.Size = UDim2.new(0, 200, 0, 0)
        ArrayListFrame.Parent = ArrayListGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = ArrayListFrame

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 12)
        padding.PaddingRight = UDim.new(0, 12)
        padding.PaddingTop = UDim.new(0, 10)
        padding.PaddingBottom = UDim.new(0, 10)
        padding.Parent = ArrayListFrame

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 4)
        layout.SortOrder = Enum.SortOrder.Name
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.Parent = ArrayListFrame

        if ArrayListPosition == "Right Top" then
            ArrayListFrame.AnchorPoint = Vector2.new(1, 0)
            ArrayListFrame.Position = UDim2.new(1, -10, 0, 10)
            layout.VerticalAlignment = Enum.VerticalAlignment.Top
        elseif ArrayListPosition == "Right Bottom" then
            ArrayListFrame.AnchorPoint = Vector2.new(1, 1)
            ArrayListFrame.Position = UDim2.new(1, -10, 1, -10)
            layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        elseif ArrayListPosition == "Left Top" then
            ArrayListFrame.AnchorPoint = Vector2.new(0, 0)
            ArrayListFrame.Position = UDim2.new(0, 10, 0, 10)
            layout.VerticalAlignment = Enum.VerticalAlignment.Top
        elseif ArrayListPosition == "Left Bottom" then
            ArrayListFrame.AnchorPoint = Vector2.new(0, 1)
            ArrayListFrame.Position = UDim2.new(0, 10, 1, -10)
            layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        end

        local lastCheats = {}
        ArrayListUpdateConnection = RunService.RenderStepped:Connect(function()
            local currentCheats = getEnabledCheats()

            local changed = false
            if #currentCheats ~= #lastCheats then
                changed = true
            else
                for i = 1, #currentCheats do
                    if currentCheats[i] ~= lastCheats[i] then
                        changed = true
                        break
                    end
                end
            end
            
            if changed then
                lastCheats = currentCheats

                for _, conn in pairs(ArrayListAnimations) do
                    conn:Disconnect()
                end
                ArrayListAnimations = {}
                
                for _, child in pairs(ArrayListFrame:GetChildren()) do
                    if child:IsA("TextLabel") then
                        child:Destroy()
                    end
                end
                ArrayListLabels = {}

                for i, cheat in ipairs(currentCheats) do
                    local label = Instance.new("TextLabel")
                    label.Name = "Cheat_" .. i
                    label.BackgroundTransparency = 1
                    label.Size = UDim2.new(1, 0, 0, 24)
                    label.Text = cheat
                    label.TextSize = 32
                    label.Font = Enum.Font.SourceSansBold
                    label.TextStrokeTransparency = 0.6
                    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    label.Parent = ArrayListFrame
                    
                    if ArrayListPosition == "Right Top" or ArrayListPosition == "Right Bottom" then
                        label.TextXAlignment = Enum.TextXAlignment.Right
                    else
                        label.TextXAlignment = Enum.TextXAlignment.Left
                    end
                    
                    if ArrayListRainbow then
                        label.TextColor3 = getRainbowColor()
                    else
                        label.TextColor3 = ArrayListColors[ArrayListColor] or Color3.fromRGB(255, 255, 255)
                    end
                    
                    local delay = i * 0.05
                    task.delay(delay, function()
                        if label and label.Parent then
                            animateLabelIn(label)
                        end
                    end)
                    
                    table.insert(ArrayListLabels, label)
                end
            end
            
            if ArrayListRainbow then
                local rainbowColor = getRainbowColor()
                for _, label in pairs(ArrayListLabels) do
                    if label and label.Parent then
                        label.TextColor3 = rainbowColor
                    end
                end
            end
        end)
    end

    local function destroyArrayList()
        if ArrayListUpdateConnection then
            ArrayListUpdateConnection:Disconnect()
            ArrayListUpdateConnection = nil
        end
        
        for _, conn in pairs(ArrayListAnimations) do
            conn:Disconnect()
        end
        ArrayListAnimations = {}
        
        if ArrayListGui then
            ArrayListGui:Destroy()
            ArrayListGui = nil
        end
        ArrayListLabels = {}
    end

    local themeNames = {}
    for name, _ in pairs(Themes) do table.insert(themeNames, name) end

    SettingsTab:CreateDropdown({
        Name = "Select Theme",
        Options = themeNames,
        Flag = "Theme",
        CurrentOption = {SelectedTheme},
        MultipleOptions = false,
        Callback = function(option)
            local o = option
            if type(o) == "table" then o = o[1] end
            if type(o) == "string" then SelectedTheme = o end
        end
    })

    SettingsTab:CreateToggle({
        Name = "Enable ArrayList",
        Flag = "ArrayListEnabled",
        CurrentValue = false,
        Callback = function(state)
            ArrayListEnabled = state
            if state then
                createArrayList()
            else
                destroyArrayList()
            end
        end
    })

    local positionNames = {"Right Top", "Right Bottom", "Left Top", "Left Bottom"}

    SettingsTab:CreateDropdown({
        Name = "ArrayList Position",
        Options = positionNames,
        CurrentOption = {"Right Top"},
        Flag = "ArrayListPosition",
        MultipleOptions = false,
        Callback = function(option)
            local pos = option
            if type(option) == "table" then pos = option[1] end
            if type(pos) == "string" then
                ArrayListPosition = pos
                if ArrayListEnabled then
                    createArrayList()
                end
            end
        end
    })

    local colorNames = {"White", "Red", "Blue", "Green", "Yellow", "Purple", "Orange", "Pink", "Cyan", "Rainbow"}

    SettingsTab:CreateDropdown({
        Name = "ArrayList Color",
        Options = colorNames,
        Flag = "ArrayListColor",
        CurrentOption = {"White"},
        MultipleOptions = false,
        Callback = function(option)
            local col = option
            if type(option) == "table" then col = option[1] end
            if type(col) == "string" then
                if col == "Rainbow" then
                    ArrayListRainbow = true
                    ArrayListColor = "White"
                else
                    ArrayListRainbow = false
                    ArrayListColor = col
                end
            end
        end
    })

    local function ResetAllSettings()
        if flying then
            if BodyVelocity then 
                BodyVelocity:Destroy() 
                BodyVelocity = nil 
            end
            if BodyGyro then 
                BodyGyro:Destroy() 
                BodyGyro = nil 
            end
            flying = false
        end
        
        noclipEnabled = false
        ESPEnabled = false
        NoFallEnabled = false
        InfiniteJumpEnabled = false
        AntiAFKEnabled = false
        AimbotEnabled = false
        ShowFOV = false
        clickTeleportEnabled = false
        touchTeleportEnabled = false
        flightEnabled = false
        throttleEnabled = false
        brakeEnabled = false
        stopEnabled = false
    
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = game.Players.LocalPlayer.Character.Humanoid
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
        
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
            hrp.Velocity = Vector3.new(0, 0, 0)
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end

        FlySpeed = 2
        ESPColor = Color3.new(1, 0, 0)
        FOVRadius = 100
        DynamicFOVRadius = 100
        Smoothness = 0.2
        customTeleportPosition = nil
        customSpawnPosition = nil
        selectedPlayerName = nil
        flightSpeed = 1
        accelPower = 0.025
        brakePower = 0.15

        clearAllESP()

        if noclipEnabled then
            setNoclip(false)
        end

        if JumpConnection then
            JumpConnection:Disconnect()
            JumpConnection = nil
        end

        for _, conn in pairs(NoFallConnections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
        table.clear(NoFallConnections)

        if FOVCircle then
            FOVCircle:Remove()
            FOVCircle = nil
        end

        RemovePhoneGui()
    
        for _, conn in pairs(ESPConnections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
        ESPConnections = {}
        
        destroyArrayList()
    end

    SettingsTab:CreateButton({
        Name = "Load Config",
        Callback = function()
            Rayfield:LoadConfiguration()
        end
    })   

    SettingsTab:CreateButton({
        Name = "Apply Theme (Resets all Cheats!)",
        Callback = function()
            local themeToApply = Themes[SelectedTheme] or "Default"
            ResetAllSettings()
        
            task.defer(function()
                if Window and typeof(Window.Destroy) == "function" then
                    Window:Destroy()
                end
                CreateWindow(themeToApply)
            end)
        end
    })

    return Window
end

if CreateWindow == nil then
    error("CreateWindow is not defined!")
    return
end
CreateWindow(SelectedTheme)
