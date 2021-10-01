function read_str(address)
	text = ""
	for i = 0,7 do
		text = text .. string.char(memory.readbyte(address+i))
	end
	return text
end

local version

v_str = read_str(0x080000A8)
if v_str == "FIREBPRD" or v_str == "LEAFBPGD" then
	version = "frlg"
elseif v_str == "RUBYAXVD" or v_str == "SAPPAXPD" then
	version = "rs"
elseif v_str == "EMERBPED" then
	version = "e"
else
	version = "unknown"
end

local pidpointer
local pid_addr
local pidoffset
local egglowpid
local x_coord
local y_coord
local coord_base
local map_offset
local left_x
local right_x
local y_bound

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
	left_x = 9
	right_x = 28
	y_bound = 15
end
if version == 'rs' then
	pidpointer = 0
	pidoffset = 0x020287E8
	coord_base = 0
	x_offset = 0x02025734
	y_offset = 0x02025736
	map_offset = 5
	left_x = 0x1F
	right_x = 0x3B
	y_bound = 6
end
if version == 'e' then
	pidpointer = 0x0203BC78
	pidoffset = 0x988
	coord_base = 0x03005D8C
	x_offset = 0x0
	y_offset = 0x02
	map_offset = 5
	left_x = 0x1F
	right_x = 0x3B
	y_bound = 7
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
	if pidpointer ~= 0 then
		pid_addr = math.floor(memory.readdwordunsigned(pidpointer) + pidoffset)
	else
		pid_addr = pidoffset
	end
	egglowpid = memory.readwordunsigned(pid_addr)	
	if coord_base ~= 0 then
		x_coord = math.floor(memory.readdwordunsigned(coord_base) + x_offset)
		y_coord = math.floor(memory.readdwordunsigned(coord_base) + y_offset)
	else
		x_coord = x_offset
		y_coord = y_offset
	end
	while egglowpid % 0x10000 <= 0 do
		egglowpid = memory.readwordunsigned(pid_addr)	
		walk_y(y_bound)
		walk_x(left_x)
		walk_x(right_x)
		print("Walking..")
		print(string.format("PID addr.: %X \nPID: %X", pid_addr,egglowpid))
	end
	if egglowpid % 0x10000 > 0 then
		print("Egg generated!")
		break
	end
	
end
vba.pause()