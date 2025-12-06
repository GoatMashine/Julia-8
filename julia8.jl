# Initialization
mem = zeros(UInt8, 4096)
v = zeros(UInt8, 16)
stack = zeros(UInt16, 16) 
I = zero(UInt16) 
pc = zero(UInt16)
screen = falses(32, 64)

font = [
    0xF0, 0x90, 0x90, 0x90, 0xF0, # 0
    0x20, 0x60, 0x20, 0x20, 0x70, # 1
    0xF0, 0x10, 0xF0, 0x80, 0xF0, # 2
    0xF0, 0x10, 0xF0, 0x10, 0xF0, # 3
    0x90, 0x90, 0xF0, 0x10, 0x10, # 4
    0xF0, 0x80, 0xF0, 0x10, 0xF0, # 5
    0xF0, 0x80, 0xF0, 0x90, 0xF0, # 6
    0xF0, 0x10, 0x20, 0x40, 0x40, # 7
    0xF0, 0x90, 0xF0, 0x90, 0xF0, # 8
    0xF0, 0x90, 0xF0, 0x10, 0xF0, # 9
    0xF0, 0x90, 0xF0, 0x90, 0x90, # A
    0xE0, 0x90, 0xE0, 0x90, 0xE0, # B
    0xF0, 0x80, 0x80, 0x80, 0xF0, # C
    0xE0, 0x90, 0x90, 0x90, 0xE0, # D
    0xF0, 0x80, 0xF0, 0x80, 0xF0, # E
    0xF0, 0x80, 0xF0, 0x80, 0x80  # F
]

# load font into memory
for i in eachindex(font)
    mem[0x50 + i] = font[i]
end    

pc = 0x201

# functions

function load(x::UIn8, y::UInt8)
    opcode = (x << 8) | y
    pc += 2
    decode(opcode)
end

function decode(opcode::UInt16)
    nib1 = UInt8((opcode >> 12) & 0xF)
    if nib1 == 0x0
        if opcode == 0x00E0
            clear_screen()
        elseif opcode == 0x00EE
            
        else
            return
        end        

    elseif nib1 == 0x1
        NNN = UInt16(opcode & 0x0FFF)
        jump(NNN)
    elseif nib1 == 0x2

    elseif nib1 == 0x3

    elseif nib1 == 0x4

    elseif nib1 == 0x5

    elseif nib1 == 0x6
        XNN = UInt16(opcode & 0x0FFF)
        set_register(XNN)
    elseif nib1 == 0x7
        XNN = UInt16(opcode & 0x0FFF)
        add_register(XNN)
    elseif nib1 == 0x8

    elseif nib1 == 0x9

    elseif nib1 == 0xA
        NNN = UInt16(opcode & 0x0FFF)
        set_I(NNN)
    elseif nib1 == 0xB

    elseif nib1 == 0xC

    elseif nib1 == 0xD

    elseif nib1 == 0xE

    elseif nib1 == 0xF

    end
end

function

function jump(NNN::UInt16) # 1NNN
    pc = NNN
    return
end

function set_register(XNN::UInt16) # 6XNN
    X = UInt8(XNN >> 8) & 0xF
    NN = UInt8(XNN & 0xFF)
    v[X + 1] = NN
    return
end    

function add_register(XNN::UInt16) # 7XNN
    X = UInt8(XNN >> 8) & 0xF
    NN = UInt8(XNN & 0xFF)
    v[X + 1] += NN
    return
end    

function set_I(NNN::UInt16) # ANNN
    I = NNN
end    

function clear_screen() # 00E0
    screen = falses(32, 64)
    return
end    


# main F/D/E Loop
while true
    load(mem[pc + 1], mem[pc + 2]) 
end    