local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Rizz Hub",
    LoadingTitle = "Welcome to Rizz Hub!",
    LoadingSubtitle = "By sixpenny_fox4",
    Discord = {
        Enabled = true,
        Invite = "WgAcTZzStB",
        RememberJoins = true
    },
    KeySystem = false
})

local mainTab = Window:CreateTab("MAIN", 4483345998)

function chat(msg)

    if game:GetService("TextChatService").ChatVersion == Enum.ChatVersion.TextChatService then
        game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(msg)
    else
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
    end

end

Rayfield:Notify({
    Title = "Hello!",
    Content = "Hello " .. game.Players.LocalPlayer.Name .. " and thank you for using Rizz Hub!",
    Duration = 5,
    Image = 4483345998
})

mainTab:CreateButton({
    Name = "1. Can I be your snowflake?...",
    Callback = function()
        chat("Can I be your snowflake? I promise to never melt away from your heart.")
    end
})

mainTab:CreateButton({
    Name = "2. Are you a Wi-Fi signal?...",
    Callback = function()
        chat("Are you a Wi-Fi signal? Because I’m feeling a strong connection.")
    end
})

mainTab:CreateButton({
    Name = "3. Are you a heart?...",
    Callback = function()
        chat("Are you a heart? Because I'd never stop beating for you.")
    end
})

mainTab:CreateButton({
    Name = "4. I believe in following my dreams...",
    Callback = function()
        chat("I believe in following my dreams, so you lead the way.")
    end
})

mainTab:CreateButton({
    Name = "5. If being beautiful was a crime...",
    Callback = function()
        chat("If being beautiful was a crime, you’d be on the most wanted list.")
    end
})

mainTab:CreateButton({
    Name = "6. Are you iron?...",
    Callback = function()
        chat("Are you iron? Because I don’t get enough of you.")
    end
})

mainTab:CreateButton({
    Name = "7. You should be Jasmine..",
    Callback =function()
        chat("You should be Jasmine without the 'Jas'.")
    end
})

mainTab:CreateButton({
    Name = "8. Are you a Disney ride?...",
    Callback = function()
        chat("Are you a Disney ride? Because I'd wait forever for you.")
    end
})

mainTab:CreateButton({
    Name = "9. Hey, I’m sorry to bother you...",
    Callback = function()
        chat("Hey, I’m sorry to bother you, but my phone must be broken because it doesn’t seem to have your number in it.")
    end
})

mainTab:CreateButton({
    Name = "10. Are you good at math?...",
    Callback = function()
        chat("Are you good at math? Me neither, the only number I care about is yours.")
    end
})

mainTab:CreateButton({
    Name = "11. Is your name Elsa?...",
    Callback = function()
        chat("Is your name Elsa? Because I can't let you go.")
    end
})

mainTab:CreateButton({
    Name = "12. Do you know the difference between history and you?...",
    Callback = function()
        chat("Do you know the difference between history and you? History is the past and you are my future.")
    end
})

mainTab:CreateButton({
    Name = "13. Do you work for NASA?...",
    Callback = function()
        chat("Do you work for NASA? Because your beauty is out of this world.")
    end
})

mainTab:CreateButton({
    Name = "14. Math is so confusing. It's always talking...",
    Callback = function()
        chat("Math is so confusing. It's always talking about x and y and never you and I.")
    end
})

mainTab:CreateButton({
    Name = "15. Are you Christmas morning?...",
    Callback = function()
        chat("Are you Christmas morning? Because I’ve been waiting all year for you to arrive.")
    end
})

mainTab:CreateButton({
    Name = "16. Are you from Tennessee?..:",
    Callback = function()
        chat("Are you from Tennessee? Because you're the only ten I see.")
    end
})

mainTab:CreateButton({
    Name = "17. Are you Nemo?...",
    Callback = function()
        chat("Are you Nemo? Because I've been trying to find you.")
    end
})

mainTab:CreateButton({
    Name = "18. Are you a bank loan?...",
    Callback = function()
        chat("Are you a bank loan? Because you have my interest.")
    end
})

mainTab:CreateButton({
    Name = "19. I hope you know CPR...",
    Callback = function()
        chat("I hope you know CPR, because you just took my breath away.")
    end
})

mainTab:CreateButton({
    Name = "20. Are you the sun?...",
    Callback = function()
        chat("Are you the sun? Because I could stare at you all day, and it’d be worth the risk.")
    end
})

mainTab:CreateButton({
    Name = "21. Are you a keyboard?...",
    Callback = function()
        chat("Are you a keyboard? Because you're just my type.")
    end
})

mainTab:CreateButton({
    Name = "22. My mom said sharing is caring...",
    Callback = function()
        chat("My mom said sharing is caring but, no...you're all mine!")
    end
})

mainTab:CreateButton({
    Name = "23. It's time to pay up...",
    Callback = function()
        chat("It's time to pay up. It's the first of the month, and you've been living in my mind rent-free.")
    end
})

mainTab:CreateButton({
    Name = "24. Are you a light?...",
    Callback = function()
        chat("Are you a light? Because you always make me feel bright.")
    end
})

mainTab:CreateButton({
    Name = "25. Do you have a bandaid?...",
    Callback = function()
        chat("Do you have a bandaid? My knees hurt from falling for you.")
    end
})

mainTab:CreateButton({
    Name = "26. We may not be pants, but...",
    Callback = function()
        chat("We may not be pants, but we'd make a great pair.")
    end
})

mainTab:CreateButton({
    Name = "27. You know what's beautiful?...",
    Callback = function()
        chat("You know what's beautiful? Repeat the first word.")
    end
})

mainTab:CreateButton({
    Name = "28. Your eyes remind me of Ikea...",
    Callback = function()
        chat("Your eyes remind me of Ikea: easy to get lost in.")
    end
})

mainTab:CreateButton({
    Name = "29. If you were a Transformer...",
    Callback = function()
        chat("If you were a Transformer, you'd be Optimus Fine.")
    end
})

mainTab:CreateButton({
    Name = "30. I must be a time traveler...",
    Callback = function()
        chat("I must be a time traveler, because I can't imagine my future without you.")
    end
})

mainTab:CreateButton({
    Name = "31. Are you a light switch?...",
    Callback = function()
        chat("Are you a light switch? Because you turn me on.")
    end
})

mainTab:CreateButton({
    Name = "32. Are you a doctor? Because...",
    Callback = function()
        chat("Are you a doctor? Because you instantly make me feel better.")
    end
})

mainTab:CreateButton({
    Name = "33. You must be a masterpiece...",
    Callback = function()
        chat("You must be a masterpiece, because I can't take my eyes off of you.")
    end
})

mainTab:CreateButton({
    Name = "34. Are you my favorite song?...",
    Callback = function()
        chat("Are you my favorite song? Because I can't get you out of my head.")
    end
})

mainTab:CreateButton({
    Name = "35. I'm no photographer, but...",
    Callback = function()
        chat("I'm no photographer, but I can picture us together.")
    end
})

mainTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Rayfield:Destroy()
    end
})
