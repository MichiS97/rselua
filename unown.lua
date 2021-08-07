-- Enter parameters here --
local desired_letters = {'U','O'}
-- End of parameters --

rshift = bit.rshift
lshift = bit.lshift

local species_offset = 0x0202077E
local cursor = 0x02023FF8
local text_wait = 0x03007D22
local anim_wait = 0x03004ed4
local battle_const = 0x3669
local battle_choice_const = 0x3fc5
local field_const = 0x5add
local start = 0x0202402C

function press(button, delay)
    i = 0
    while i < delay do
        joypad.set(1, button)
        i = i + 1
        emu.frameadvance()
    end
end

function flee()
	while memory.readword(anim_wait) ~= battle_const do
		emu.frameadvance()
	end
	while memory.readbyte(text_wait) ~= 0 do
		emu.frameadvance()
	end
	press({A = true}, 5); press({A = false}, 5)
	while memory.readword(anim_wait) ~= battle_choice_const do
		press({A = true}, 5); press({A = false}, 5)
	end
	while memory.readbyte(cursor) ~= 1 do
		press({right = true}, 2); press({right = false}, 2)
	end
	while memory.readbyte(cursor) ~= 3 do
		press({down = true}, 2); press({down = false}, 2)
	end
	while memory.readword(anim_wait) ~= field_const do
		press({A = true}, 5); press({A = false}, 5)
	end
	i = 0
	while i < 60 do
		emu.frameadvance()
		i = i + 1
	end
end

function getUnownForm(pid)
	letter = bit.band(rshift(pid,24), 0x3)
	letter = lshift(letter,8)
	letter = bit.bor(letter,(bit.band(rshift(pid,16),0x3)))
	letter = lshift(letter,8)
	letter = bit.bor(letter,(bit.band(rshift(pid,8),0x3)))
	letter = lshift(letter,8)
	letter = bit.bor(letter,(bit.band(pid,0x3)))
	letter = letter % 28
	if letter == 26 then
		letter = "!"
	elseif letter == 27 then
		letter = "?"
	else
		letter = string.char(0x41 + letter)
	end
	return letter
end

state = savestate.create()

while true do
	found = false
	while memory.readbyte(species_offset) == 0 or memory.readbyte(species_offset) == 1 do
		press({left = true}, 10); press({left = false}, 10)
		press({right = true}, 10); press({right = false}, 10)
	end
	pid = memory.readdwordunsigned(start)
	if memory.readword(species_offset) == 0xC9 then
		personality = memory.readdwordunsigned(start)
		Form = getUnownForm(pid)
        print(string.format("Form: %s", Form))
		for _,x in ipairs(desired_letters) do
			if Form == x then
				found = true
			end
		end
	end
	if found then
		print("Encountered desired form!")
		break
	else
		flee()
	end
end

vba.pause()