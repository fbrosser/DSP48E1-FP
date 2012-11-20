### Python reading and matching from assembler source file
### Fredrik Brosser 2012-11-14

# Import regular expressions library
# (Overkill to use here, but includes powerful features for more advanced use)
import re

# File to be read and variables
fileName = "test.asm"
SPoffset = "No offset found"

# Array of register names as str (remember, python is untyped!)
registers = ['v0', 'v1', 'v2', 'v3', 'v4', 'v5']
usedRegisters = []
unusedRegisters = []

# Read line by line in file, stripping the newline character
lines = [line.strip() for line in open(fileName)]

# Pick stack pointer offset from first line that matches
for l in lines:
    # Note: this pattern is overly generic (for whitespace)
    m = re.match('\s?' + 'addiu' + '\s?' + 'sp'+ '\s?' + ',' + '\s?' + 'sp' + '\s?' + ',' + '\s?' +  '(-{0,1}\d+)', l)
    if m:
        # Pick out content of first bracket subgroup
        SPoffset = m.group(1)
        break

# Look for usage of registers as specified in the registers array
for l in lines:
    for i in range(len(registers)):
        m = re.search(registers[i], l)
        if m:
            usedRegisters.append(registers[i])

# Sort registers and remove duplicate entries
usedRegisters = sorted(set(usedRegisters))

# Check for unused registers
unusedRegisters = [r for r in registers if r not in usedRegisters]

# Sort registers and remove duplicate entries
unusedRegisters = sorted(set(unusedRegisters))

# Print results
print "\n ***** Raw assembler program ***** \n"
for l in lines:
    print l

print "\n ***** Stack pointer offset *****"
print SPoffset

print "\n ***** Used registers *****"
for r in usedRegisters:
    print r

print "\n ***** Unsed registers *****"
for r in unusedRegisters:
    print r

print ""
