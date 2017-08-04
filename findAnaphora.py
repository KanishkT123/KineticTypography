import nltk, re, pprint
from nltk import word_tokenize, sent_tokenize


""" Wrapper function that returns the phrase that repeats
    if the paragraph contains anaphora, and false if not.
"""
def anaphora(paragraph):
    return paragraph



""" Takes in a paragraph and then tokenizes it by sentence and then
    by word, outputting a list of lists of words, each inner list 
    being one sentence.

    input: string
    output: list of lists of strings
"""
def tokenizeThis(paragraph):
    sentList = sent_tokenize(paragraph)
    outputList = []
    for sentence in sentList:
        words = word_tokenize(sentence)
        outputList.append(words)
    return outputList


""" Takes in the output of tokenizeThis and checks if the first word
    of each inner list is the same within a three sentence window. 
    If yes, it returns true.
    If not, it continues onto successive reading windows.
    After reaching the end, if it did not yet return true, it returns false.

    input: list of lists of strings
    output: boolean
"""
def repeated(LoL):
    repeatedList = []
    length = len(LoL)
    # If paragraph is only one sentence:
    if length == 1:
        return False

    elif length == 2:
        if LoL[0][0] == LoL[1][0]:
            repeatedList.append(LoL[0][0])
        else: 
            return False
    
    else:
        for i in range(length-1):
            if LoL[i][0] == LoL[i + 1][0] or LoL[i][0] == LoL[i + 2][0]:
                if LoL[i][0] not in repeatedList:
                    repeatedList.append(LoL[i][0])
        if len(repeatedList) == 0:
            return False
        else:
            return repeatedList


""" Is only called when repeated(LoL) has found some repetition. Goes through
    the sentences and finds which word/phrase is repeated and returns it.

    input: list of lists of strings, and the first repeated word
    output: list of strings
"""
# def findRepetition(LoL, repWord):
#     length = len(LoL)
#     repIndex = [] # List of indices for the sentences which start with repWord
    
#     for i in range(length):
#         if repWord == LoL[i][0]:
#             repIndex.append(i) # Adds all indices which start with word to repIndex
    
#     sentLengths = [ len(sentence) for sentence in repIndex ]
#     shortestLen = min(sentLengths)

#     for i in range(len(repIndex)):
#         while LoL[]
    
