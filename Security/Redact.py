import re

# Constant
# We could use a much better regex that wouldn't handle 999.999.999.999
# but let's go with this one for the moment.
IPADDR_REGEX = r"\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b"

def replaceAllIPAddr(fileLocation, ipAddrDict):
    # Create Regex
    ipAddrRegex = re.compile(IPADDR_REGEX)

    # Read in the content of the file
    with open(fileLocation, 'r') as file :
        inputString = file.read()

    # Find all IP addressses in the file
    matches = ipAddrRegex.findall(inputString)

    for match in matches:
        if match not in ipAddrDict:
            ipAddrDict[match] = "IP" + str(len(ipAddrDict))

        inputString = inputString.replace(match, "["+ipAddrDict[match]+"]")
    
    with open(fileLocation, 'w') as file:
        file.write(inputString)

    return ipAddrDict

ipAddrDict = dict()
fileLocation = r"C:\Users\satal\Downloads\test.txt"

ipAddrDict = replaceAllIPAddr(fileLocation, ipAddrDict)

for keys,values in ipAddrDict.items():
    print(keys)
    print(values)
