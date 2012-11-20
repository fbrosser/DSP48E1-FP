### Python test bench generator for floating point core
### Fredrik Brosser 2012-11-16

import random
import binascii
import struct
import bitview
import sys

# Error to give on invalid input
class InputError(Exception):
     def __init__(self, value):
         self.value = value
     def __str__(self):
         return repr(self.value)

# Get binary from unpacked struct value (lambda function)
getBin = lambda x: x > 0 and str(bin(x))[2:] or "-" + str(bin(x))[3:]  
  
# Convert python float to binary32
def floatToBinary32(value):  
    val = struct.unpack('i', struct.pack('f', value))[0]  
    return getBin(val)
  
# Get single precision representation as string
def floatToIEEE754String(value):
        a = (floatToBinary32(value))
        aL = len(a)
        aLm = 32 - aL
        aStr = str(a)
        for j in range(aLm):
            aStr = '0' + aStr
        s = random.randint(0, 1)
        aStr = str(s) + aStr[1:]
        return aStr

# Help message
def printHelp():
    wStr = "\nPython Test Bench Generator for Floating Point Core\n"
    wStr += "v1.0 Fredrik Brosser\n"
    wStr += "Usage: \n"
    wStr += "python tbGen.py <stimulus file> <results file> <delay> <#tests> <operand range>\n"
    print wStr
    return

# Main script line
if __name__ == "__main__":

    # Filenames
    fN = "stimulus.txt"
    rfN = "results.txt"
    # Delay between stimulus
    sD = 10
    # Number of tests
    nT = 100
    # Range of test values
    mx = 999999
    # Operation (mult or addsub)
    op = 0

    # Help line
    if(len(sys.argv) == 2 and sys.argv[1] == '-h'):
        printHelp()
        sys.exit()
    elif(len(sys.argv) < 6):
        raise InputError("Not enough arguments given!")
        sys.exit()
    else:
        try:    
            fN = sys.argv[1]
            rfN = sys.argv[2]
            sD = int(sys.argv[3])
            nT = int(sys.argv[4])
            mx = int(sys.argv[5])
        except InputError as e:
            print 'Not enough arguments given!', e.value
            sys.exit()

    # Valid input flag
    vIp = 0
    while(vIp == 0):
        k = raw_input("Multiplication or Addition/Subtraction? (*/+): ")
        if(k == '+'):
            op = 0
            vIp =  1
        elif(k == '*'):
            op = 1
            vIp =  1
        else:
            print "Bad input"

    print "\n*** Generating Stimulus File ***"
    print "< ./" + fN + " >"

    # A Operator
    As = []
    Astrs = []
    # B Operator
    Bs = []
    Bstrs = []
    # Control bit (+/-)
    Cs = []
    # Result
    Zs = []
    Zstrs = []

    # Generate array contents
    for i in range(nT):
        a = random.uniform(0, mx)
        b = random.uniform(0, mx)
        c = random.randint(0, 1)
        z = 0
        s = 0
        aSt = floatToIEEE754String(a)
        bSt = floatToIEEE754String(b)
        # Negative floating point number (sign bit = 1)
        if(aSt[0] == '1'):
            a = -a;
        if(bSt[0] == '1'):
            b = -b;
        if(op == 1):
            z = a * b 
        else:
            if(c == 0):
                z = (a+b)
            else:
                z = (a-b)
        zSt = floatToIEEE754String(abs(z))
        # Result is negative
        if(((c == 0) and ((a+b)<0)) or ((c == 1) and ((a-b)<0))):
            s = 1
        zSt = str(s) + zSt[1:]
        As.append(a)
        Bs.append(b)
        Cs.append(c)
        Zs.append(z)
        Astrs.append(aSt)
        Bstrs.append(bSt)
        Zstrs.append(zSt)

    oF = open('./' + fN, 'w') 
    for i in range(nT):

        # Print operands and result in decimal
        wStr = "\n// TEST #"
        wStr += str(i+1)
        wStr += "\n// "
        wStr += str(As[i])
        if(Cs[i] == 0):
            wStr += str(" + ")
        else:
            wStr += str(" - ")
        wStr += str(Bs[i])
        wStr += str(" = ")
        wStr += str(Zs[i])
        wStr += "\n"

        # Print result in IEEE754
        wStr += "// Expected Z = "
        wStr += Zstrs[i]
        wStr += "\n"

        # Print stimulus code to test bench
        wStr += str("#")
        wStr += str(sD)
        wStr += str(" a = 32'b")
        wStr += Astrs[i]
        wStr += str("; b = 32'b")
        wStr += Bstrs[i]
        wStr += str("; operation = 1'b")
        wStr += str(Cs[i])
        wStr += str("; $display(\"%b\", result);\n")
        oF.write(wStr)
        if(i%(nT/10)==0):
            sys.stdout.write('|')

    # Print trailing result outputs and simulation finish
    wStr = "\nfor(i=0; i<=10; i=i+1) begin"
    wStr += "\n\t#10 $display(\"%b\", result); \nend \n"
    wStr += "\n#100 \n"
    wStr += "\n#10 $finish; \n"
    oF.write(wStr)
    sys.stdout.write(' 100%')
    print "\n*** Write Complete! ***\n"

    print "*** Writing Results File ***"
    print "< ./" + rfN + " >"

    # Print only result (in IEEE754)
    oF = open('./' + rfN, 'w') 
    for i in range(nT):
        oF.write(Zstrs[i])
        oF.write("\n")
        if(i%(nT/10)==0):
            sys.stdout.write('|')
    sys.stdout.write(' 100%')        
    print "\n*** Write Complete! ***\n"

    # Valid input flag
    vIp = 0
    while(vIp == 0):
        k = raw_input("Match results with file? (Y/N): ")
        if(k == 'N' or k == 'n'):
            print "\n*** All Done. ***"
            print "\n*** Good-Bye! ***\n"
            sys.exit()
        elif(k == 'Y' or k == 'y'):
            vIp = 1
        else:
            print "Bad input"

    # Simulation result file name
    srFn = ""
    srFn = raw_input("Input file ./<filename>: ")
    sL = []
    ersS = []
    ersR = []
    ersL = []
    RDsS = []
    RDsR = []
    RDsL = []
    # Check if file exists. Else, raise error
    try:
        sF = open(srFn, 'r')
    except IOError:
        print 'Cannot find file \"', srFn, '\"'
    else:
        sL = sF.readlines()
        sF.close()

    # Rounding disagreements
    nRD = 0
    # 'Real' errors
    nErs = 0
    # Passed
    nPsd = 0

    snL = len(sL)
    for i in range(snL):
        sr = long(sL[i])
        r = long(Zstrs[i])
        d = abs(sr - r)
        if(d == 0):
            nPsd = nPsd + 1
        elif(d == 1):
            nRD = nRD + 1
            RDsS.append(sL[i])
            RDsR.append(Zstrs[i])     
            RDsL.append(i+1)
        else:
            nErs = nErs + 1
            ersS.append(sL[i])
            ersR.append(Zstrs[i])     
            ersL.append(i+1)

        if(i%(nT/10)==0):
            sys.stdout.write('|')
    sys.stdout.write(' 100%')

    print "\n\n*** Testing Reults ***"
    print "Passed: ", nPsd
    print "Errors: ", nErs
    print "Rounding disagreements: ", nRD

    print "\n*** Done! ***"
    # Promt string
    q = "Print errors and/or rounding disagreement lines? (E/RD/ERD/N): "
    vIp = 0
    while(vIp == 0):
        k = raw_input(q)
        if(k == 'N' or k == 'n'):
            break
        elif(k == 'E' or k == 'E'):
            vIp = 1
            for i in range(len(ersL)):
                print "Error on line", ersL[i], ":"
                print "Simulation: ", ersS[i]
                print "Expected  : ", ersR[i], "\n"
        elif(k == 'RD' or k == 'rd'):
            vIp = 1
            for i in range(len(RDsL)):
                print "Rounding disagreement on line", RDsL[i], ":"
                print "Simulation: ", RDsS[i]
                print "Expected  : ", RDsR[i], "\n"
        elif(k == 'ERD' or k == 'erd'):
            vIp = 1
            for i in range(len(ersL)):
                print "Error on line", ersL[i], ":"
                print "Simulation: ", ersS[i]
                print "Expected  : ", ersR[i], "\n"
            for i in range(len(RDsL)):
                print "Rounding disagreement on line", RDsL[i], ":"
                print "Simulation: ", RDsS[i]
                print "Expected  : ", RDsR[i], "\n"
        else:
            print "Bad input"

    print "\n*** All Done. ***"
    print "\n*** Good-Bye! ***\n"

