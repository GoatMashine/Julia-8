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

# functions

function evaluate(opcode::UInt16)
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
        pc_jmp(NNN)
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
        X = UInt8(opcode >> 8 & 0xF)
        Y = UInt8(opcode >> 4 & 0xF)
        N = UInt8(opcode & 0xF)
        draw_screen(X,Y,N)
    elseif nib1 == 0xE

    elseif nib1 == 0xF
    end
end

# 1NNN
function pc_jmp(NNN::UInt16)
    global pc = NNN
end

# 6XNN
function set_register(XNN::UInt16)
    X = UInt8(XNN >> 8) & 0xF
    NN = UInt8(XNN & 0xFF)
    v[X + 1] = NN     #
end    

# 7XNN
function add_register(XNN::UInt16)
    X = UInt8(XNN >> 8) & 0xF
    NN = UInt8(XNN & 0xFF)
    v[X + 1] += NN    
end    

# ANNN
function set_I(NNN::UInt16)
    global I = NNN
end    

# 00E0
function clear_screen()
    global screen = falses(32, 64)
end    

#DXYN
function draw_screen(X::UInt8, Y::UInt8, N::UInt8)
    global screen, v, mem, I

    v[16] = 0x00  

    x0 = Int(v[X + 1]) % 64
    y0 = Int(v[Y + 1]) % 32

    base = Int(I) + 1   

    for row in 0:(N-1)
        sprite = mem[base + row]
        y = (y0 + row) % 32

        for bit in 0:7
            sprite_pixel = (sprite >> (7 - bit)) & 0x1
            if sprite_pixel == 1
                x = (x0 + bit) % 64

                if screen[y + 1, x + 1]
                    v[16] = 0x01   
                end

                screen[y + 1, x + 1] ⊻= true
            end
        end
    end
    for y in 1:32
    for x in 1:64
        print(screen[y, x] ? "#" : ".")
    end
    println()
end
println()

end

rom = UInt8[
    0x00, 0xE0,   
    0x60, 0x10,   
    0x61, 0x08,   
    0xA0, 0x50,   
    0xD0, 0x15,   
    0x12, 0x00    
]

for i in eachindex(rom)
    mem[0x200 + i] = rom[i]
end

pc = 0x200


# main F/D/E Loop
while pc + 2 < 4097
    opcode = (UInt16(mem[pc + 1]) << 8) | UInt16(mem[pc + 2])
    global pc += 2
    if opcode == 0
        println("opcode is zero")
        break 
    else    
        evaluate(opcode)
    end
end    