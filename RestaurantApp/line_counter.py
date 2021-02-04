import os
import datetime

fileType = '.dart'

totalLines = 0


def countLines(file):
    return sum(1 for line in open(file))


def getListOfFiles(dirName):
    listOfFile = os.listdir(dirName)
    allFiles = list()
    for entry in listOfFile:
        fullPath = os.path.join(dirName, entry)

        if os.path.isdir(fullPath):
            allFiles = allFiles + getListOfFiles(fullPath)
        elif fileType in fullPath:

            allFiles.append(fullPath)

    return allFiles


files = getListOfFiles(os.getcwd()+"\\lib\\")
for file in files:
    totalLines += countLines(file)

now = datetime.datetime.now()


out = 'All in all {} lines in {} files.'.format(totalLines, len(files))

f = open('log_count_lines.txt', 'a')
f.write(out + ' - {}.{}.{} - {}:{}\n'.format(now.day,
                                             now.month, now.year, now.hour, now.minute))
f.close()

print('\n' + out + '\n')
