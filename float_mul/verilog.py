

import os,sys,string,random,math
import veri
sys.path.append('/home/ubuntu/projects/env/vlsistuff/verification_libs3')
import logs


import struct
import random

def generate_random_float():
    """Generate a random floating-point number."""
    return random.uniform(-10.0, 100.0)

def float_to_ieee754_32bit(float_value):
    """Convert a floating-point number to a 32-bit IEEE 754 string."""
    # Convert the float to its IEEE 754 32-bit representation
    ieee754_int = struct.unpack('I', struct.pack('f', float_value))[0]
    
    # Extract the sign, exponent, and mantissa bits
    sign = '1' if ieee754_int >> 31 else '0'
    exponent = f'{(ieee754_int >> 23) & 0xFF:08b}'
    mantissa = f'{ieee754_int & 0x7FFFFF:023b}'
    
    # Combine the sign, exponent, and mantissa into the final IEEE 754 string
    ieee754_string = sign + exponent + mantissa
    #print("ieee754_string",ieee754_string)
    return ieee754_string

def ieee754_32bit_to_float(ieee754_string):
    """Convert a 32-bit IEEE 754 string to a floating-point number."""
    # Extract the sign, exponent, and mantissa bits from the string
    #sign = -1 
    
    if (ieee754_string[0] == '1'):
        sign = -1
    else:
        sign = 1
    exponent = int(ieee754_string[1:9], 2)
    mantissa = int(ieee754_string[9:], 2)
    #print("expo ",dec2ieee(exponent))
    #print("matissa ",dec2ieee(mantissa))
    # Calculate the floating-point value
    float_value = sign * (1 + mantissa * 2 ** -23) * (2 ** (exponent - 127))
    
    return float_value


def ieee754_mult_two_32bits(ain,bin):
#multiply two 32bits ieee754 numbers and returns sum also in ieee754 32bits
    ain_int = ieee754_32bit_to_float(ain)
    bin_int = ieee754_32bit_to_float(bin)
    sum = ain_int * bin_int
    return float_to_ieee754_32bit(sum)

def ieee754_adds_two_32bits(ain,bin):
#multiply two 32bits ieee754 numbers and returns sum also in ieee754 32bits
    ain_int = ieee754_32bit_to_float(ain)
    bin_int = ieee754_32bit_to_float(bin)
    sum = ain_int + bin_int
    return float_to_ieee754_32bit(sum)

def dec2ieee(dec):
    return format(dec,'032b')

cycles=0
state='idle'
def negedge():
    global cycles,idle,ain,bin,state
    cycles += 1
    veri.force('tb.cycles',str(cycles))
    if (cycles==100):
        veri.listing('tb','1000','cucu.list')
        logs.finishing('ENOUGH CYCLES')
        return
    


    if state=='idle':
        
        ain = generate_random_float()
        bin = generate_random_float()
        
        ainf = float_to_ieee754_32bit(ain) # string
        binf = float_to_ieee754_32bit(bin) #string
        
        
        veri.force('tb.ain', str(int(ainf, 2)))
        veri.force('tb.bin', str(int(binf, 2)))
        
        state='wait0'
    
    elif state=='wait0':
        #veri.force('tb.vldin','0')
        #ready = logs.peek('tb.ready')
        #if ready==1:
        tbout = logs.peek('tb.out') #pyveri return int number 
        Out = ieee754_32bit_to_float(dec2ieee(tbout)) #convert int to ieee754 value
        #convert ieee754 to float number
        Exp = ain * bin;
        s
        if abs(abs(Out) - abs(Exp))< (0.001):
            logs.log_correct('ain=%f, bin =%f, out=%f, exp=%f'%(ain,bin,Out,Exp))
        else:
            logs.log_wrong('ain=%f, bin =%f, out=%f, exp=%f'%(ain,bin,Out,Exp))
        #veri.force('tb.start','0')
        state='idle'


