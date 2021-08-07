-- Enter parameters here --
local version = "frlg" -- choose between rs, e and frlg
-- End of parameters --

local pidpointer = 0x02039894
local pid_addr
local pidoffset
local egglowpid
local x_coord
local y_coord
local coord_base
local map_offset

function press(button, delay)
    i = 0
    while i < delay do
        joypad.set(1, button)
        i = i + 1
        emu.frameadvance()
    end
end



if version == 'frlg' then
	pidpointer = 0x02039894
	pidoffset = 0x2CE0
	coord_base = 0x03004F58
	x_offset = 0
	y_offset = 2
	map_offset = 5
end

function walk_x(x)
	while memory.readbyte(x_coord) < x do
		press({right = true}, 2)
	end
	while memory.readbyte(x_coord) > x do
		press({left = true}, 2)
	end
end

function walk_y(y)
	while memory.readbyte(y_coord) < y do
		press({down = true}, 2)
	end
	while memory.readbyte(y_coord) > y do
		press({up = true}, 2)
	end
end

state = savestate.create()

while true do
	pid_addr = math.floor(memory.readdwordunsigned(pidpointer) + pidoffset)
	egglowpid = memory.readwordunsigned(pid_addr)	
	x_coord = math.floor(memory.readdwordunsigned(coord_base) + x_offset)
	y_coord = math.floor(memory.readdwordunsigned(coord_base) + y_offset)
	while egglowpid % 0x10000 <= 0 do
		egglowpid = memory.readwordunsigned(pid_addr)	
		walk_y(15)
		walk_x(9)
		walk_x(28)
		print("Walking..")
		print(string.format("PID addr.: %X \nPID: %X", pid_addr,egglowpid))
	end
	if egglowpid % 0x10000 > 0 then
		print("Egg generated!")
		break
	end
	
end
vba.pause()