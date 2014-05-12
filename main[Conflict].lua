--casino game. Apply random force to cube, whatever comes up on top is the outcome.
display.setStatusBar(display.HiddenStatusBar)
local W,H = display.contentWidth, display.contentHeight
local cube = display.newRect(100,100,100,100)
local cubetext = display.newText("click to roll the dice", 0,cube.y-cube.height/2-20,system.nativeFont, 16)
cubetext:setReferencePoint(display.CenterReferencePoint)
cubetext.x = cube.x
local value1, value2,over8, cubetres, winval, roll1, roll2, roll3,youwin,cubedos,cubetext2,cubetext3,checkquestion,checksum, bankupdate
local entry_fee = 3
local logpath = system.pathForFile( "logbook", system.DocumentsDirectory )
local path = system.pathForFile( "bank", system.DocumentsDirectory )
local bankfile = io.open(path, "r")
bankstring = bankfile:read("*a")
bank = tonumber(bankstring)
local file = io.open(logpath, "a+")

if bankfile then
	print("found")
else
	print("notfound")
end
local banktext = display.newText("Bank: $"..bank,750,20,native.systemFont, 40)
banktext:setTextColor(0,255,0)
local endgame = display.newText("end this game",200,550,native.systemFont,30)
local replay = display.newText("Play Again!",200,600,native.systemFont,30)
bankupdate = io.open(path, "w")



function playGame()
	function createCubetres()
		if over8 == false then
			cubetres = display.newRect(100,300,100,100)
			cubetres_yval = cubetres.y-cubetres.height/2-20
			cubetres_xval = 0
		elseif over8 == true then
			cubetres = display.newImage("triangle.gif",100,300)
			cubetres.xScale = 0.088
			cubetres.yScale = 0.1024
			cubetres:setReferencePoint(display.CenterReferencePoint)
			cubetres.x = 150
			cubetres.y = 300
			cubetres_yval = 230
			cubetres_xval = 250

		end
		cubetext3 = display.newText("click to roll the dice again again", cubetres_xval,cubetres_yval,system.nativeFont, 16)
		cubetext3:setReferencePoint(display.CenterReferencePoint)
		cubetext3.x = cubetres.x
		roll3 = display.newText("",0,0,system.nativeFont,30)
		roll3:setReferencePoint(display.CenterReferencePoint)
		roll3.x = cubetres.x
		roll3.y = cubetres.y
		roll3:setTextColor(0)
		function cubetres:touch (event)
			local counter = 0
			if event.phase == "began" then
				if over8 == false then
					value3 = math.random(1,6)
					roll3.text = value3
					winval = value3
					
					file:write(bank.."+"..winval.."+"..entry_fee.."="..bank+winval+entry_fee)

					bankupdate:write(bank + winval)
					banktext.text = "Bank: $"..bank
					youwin = display.newText("You Lose "..winval.." dollars",600,600,system.nativeFont,40)

				elseif over8 == true then

					value3 = math.random(1,20)
					roll3.text = value3
					winval = value3/2
					file:write(bank.."-"..winval.."+"..entry_fee.."="..bank-winval+entry_fee)
					local contents = file:read("*a")
					print(contents)
					bankupdate:write(bank + winval)
					banktext.text = "Bank: $"..bank
					youwin = display.newText("You win "..winval.." dollars",600,600,native.systemFont,40)

				end
					cubetres:removeEventListener("touch",cubetres)

			end
		end
		cubetres:addEventListener("touch",cubetres)
	end
	function createCubedos()
		cubedos = display.newRect(300,100,100,100)
		cubetext2 = display.newText("click to roll the dice again", 0,cubedos.y-cubedos.height/2-20,system.nativeFont, 16)
		cubetext2:setReferencePoint(display.CenterReferencePoint)
		cubetext2.x = cubedos.x
		roll2 = display.newText("",0,0,system.nativeFont,30)
		roll2:setReferencePoint(display.CenterReferencePoint)
		roll2.x = cubedos.x
		roll2.y = cubedos.y
		roll2:setTextColor(0)
		checkquestion = display.newText("Is the sum greater than or equal to 8?",470,80,system.nativeFont,16)
		checksum = display.newText("",checkquestion.x,100,system.nativeFont, 25)
		function cubedos:touch (event)

			if event.phase == "began" then

				value2 = math.random(1,6)
				roll2.text = value2
				if value1 + value2 >= 8 then
					checksum.text = "YES"
					over8 = true
					createCubetres()
				elseif value1 + value2 < 8 then
					checksum.text = "NO"
					over8 = false
					createCubetres()
				end
				cubedos:removeEventListener("touch",cubedos)
			end
		end

		cubedos:addEventListener("touch",cubedos)

		

	end

	roll1 = display.newText("",0,0,system.nativeFont,30)
	roll1:setReferencePoint(display.CenterReferencePoint)
	roll1.x = cube.x
	roll1.y = cube.y
	roll1:setTextColor(0)



	function cube:touch (event)
		bank = bank + entry_fee
		banktext.text = "Bank: $"..bank
		if event.phase == "began" then
			value1 = math.random(1,6)
			roll1.text = value1
			if value1 == 6 then 
				winval = 5
				
				file:write(bank.."-"..winval.."+"..entry_fee.."="..bank-winval+entry_fee)
				bankupdate:write(bank - winval)
				banktext.text = "Bank: $"..bank
				youwin = display.newText("You win "..winval.." dollars!",0,0,system.nativeFont,40)
				youwin:setReferencePoint(display.CenterReferencePoint)
				youwin.x, youwin.y = W/2, H/2
				--timer.performWithDelay(2000,destroyGame)
			else
				createCubedos()

			end
		cube:removeEventListener("touch",cube)

		end
	end

	cube:addEventListener("touch",cube)




end



playGame()

tomato = io.open(logpath, "r")
local content = tomato:read("*a")
print(content)

--[[
function endgame:touch( event )
	if event.phase == "began" then
		destroyGame()

		endgame:removeEventListener("touch",endgame)
	end

end
function replay:touch( event )
	if event.phase == "began" then
		playGame()
		--endgame:addEventListener("touch",endgame)
		--replay:removeEventListener("touch",endgame)
	end
end
replay:addEventListener("touch",replay)
]]
