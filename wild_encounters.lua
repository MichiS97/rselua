-- Enter parameters here --
local species = 0x137
local version = "rs" -- choose between rs, e and frlg
-- End of parameters --

local species_offset = 0x02020146
local cursor = 0x02024E60
local text_wait = 0x0300422D
local anim_wait = 0x030042E4
local anim_const = 0x17D5
local battle_const = 0x1b45
local battle_choice_const = 0x24f9
local field_const = 0x4085

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

if version == 'frlg' then
	species_offset = 0x0202077E
	cursor = 0x02023FF8
	text_wait = 0x03007D22
	anim_wait = 0x03004ed4
	battle_const = 0x3669
	battle_choice_const = 0x3fc5
	field_const = 0x5add
end

state = savestate.create()

while true do
	while memory.readbyte(species_offset) == 0 or memory.readbyte(species_offset) == 1 do
		press({left = true}, 10); press({left = false}, 10)
		press({right = true}, 10); press({right = false}, 10)
	end
	if memory.readword(species_offset) == species then
		print("Desired species encountered!")
		break
	else
		print(string.format("Encountered species: 0x%X", memory.readword(species_offset)))
		flee()
	end
end