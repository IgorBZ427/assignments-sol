

import os,sys,string,random,math
import veri
sys.path.append('../../vlsistuff/verification_libs3')
import logs

cycles=0
state='idle'
def negedge():
    global cycles,idle,din,state,Max
    cycles += 1
    veri.force('tb.cycles',str(cycles))
    if (cycles==1000):
        veri.listing('tb','1000','cucu.list')
        logs.finishing('ENOUGH CYCLES')
        return
    

    rst_n = veri.peek('tb.rst_n')
    if (rst_n!='1'):
        din = veri.peek('tb.din')
        Len = len(din)
        #Max = 1<<Len
        Max = 65536
        return


    if state=='idle':
        veri.force('tb.start','1')
        din = random.randint(0,Max)
        veri.force('tb.din',logs.make_str(din))
        veri.force('tb.vldin','1')
        
        state='wait0'
    
    elif state=='wait0':
        veri.force('tb.vldin','0')
        ready = logs.peek('tb.ready')
        if ready==1:
            Out = logs.peek('tb.dout')
            Exp = int(math.sqrt(din))
            if Out==Exp:
                logs.log_correct('in=%d out=%d'%(din,Out))
            else:
                logs.log_wrong('din=%d max=%d expected=%d act=%d'%(din,Max,int(math.sqrt(din)),Out))
            veri.force('tb.start','0')
            state='idle'


