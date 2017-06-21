from nltk.corpus import cmudict
import nltk
#import shlex, subprocess

#Global Constants
#SERVER = StanfordCoreNLP('http://localhost:9000')
ELIMINATION = set(["DT", "IN", "PDT", "PRP$", "PRP" "CC", "POS", "TO", ",", ".", ")", "(", ":"])


# def coreParser(inputString):
# 	'''Takes an inputString and tries to identify interesting characteristics
# 	by removing unnecessary words and punctuation by parsing with
# 	Stanford CORE NLP
# 	Input: Sentence string
# 	Output: String of keywords'''

# 	#This simply takes the word and parses it with CoreNLP, outputs in JSON
# 	output = SERVER.annotate(inputString, properties={
# 		'annotators': 'tokenize,ssplit,pos',
# 		'outputFormat': 'json'
# 		})
# 	wordIndex = (output['sentences'][0]['tokens'])
# 	final = ""
# 	for word in wordIndex:
# 		#Eliminate Determiners, prepositions, possessive pronouns, possessive or plural endings, etc
# 		if len(word['word']) <4 and word['pos'] in ELIMINATION:
# 			continue
# 		else:
# 			final += " " + word['word']
# 	return final[1:]

def nltkParser(inputString):
	'''Takes an inputString and tries to identify interesting characteristics
	by removing unnecessary words and punctuation by parsing with
	NLTK UPENN Parser
	Input: Sentence string
	Output: String of keywords'''
	tokenizedString = nltk.word_tokenize(inputString)
	output = nltk.pos_tag(tokenizedString)
	final = ""
	for word in output:
		if len(word[0]) < 4 and word[1] in ELIMINATION:
			continue
		else:
			final += " " + word[0]
	return final[1:]


def pronounceParse(parsedString):
	'''Takes an input string and passes it to the CMU pronounce dictionary
	And outputs the pronunciations of each word
	Input: Sentence string
	Output: List of lists of pronounciation syllables'''
	inputStringl = parsedString.lower().split()
	transcriber = cmudict.dict()
	pronunciations = []
	for word in inputStringl:
		try:
			pronunciations.append(transcriber[word][0])
		#if the word is not in the dictionary
		#Try shortening the word from the end
		#This assumes that we will eventually reach the semantic root of the word
		except KeyError:
			for x in range(len(word))[::-1]:
				try:
					pronunciations.append(transcriber[word[:x]][0])
					break
				except KeyError:
					continue
	return pronunciations

def alliterator(pronounceList):
	'''Takes in a list of lists of pronunciations from the CMU dictionary
	And then tries to look for alliteration among the pronunciations.
	Input: List of pronunciations from CMU Dict
	Output: A count of how often each sound appears, and the places where it appears'''
	#Take the first syllable for every pronounciation
	stressed = [x[0][0] for x in pronounceList]
	countDict = {}
	syllDict = {}
	#Populate dictionary with the stressed syllables and their positions
	for j in range(len(stressed)):
		if stressed[j] in countDict:
			countDict[stressed[j]] += 1
			syllDict[stressed[j]].append(j)
		else:
			countDict[stressed[j]] = 1
			syllDict[stressed[j]] = [j]
	return [countDict, syllDict]

def filter(allitDict, alignDict, parsedList):
	#Remove all the letters that occur only once
	allitWords = {}
	for key in allitDict:
		if allitDict[key] < 2:
			del alignDict[key]
		else:
			allitWords[key] = set([parsedList[pos] for pos in alignDict[key]])
	return allitWords

def main(inputString = False):
	#Requires Java Stanford core NLP to be in the same directory
	#Starts the core NLP server
	#args = 'java -mx4g -cp "*" edu.stanford.nlp.pipeline.StanfordCoreNLPServer'
	#args = shlex.split(args)
	#StanfordServer = subprocess.Popen(args, shell=False, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
	if inputString:
		print(inputString)
		#Parse the string to remove determiners, etc
		parsedString = nltkParser(inputString)
		print(parsedString)
		unimportantString = [x if x not in parsedString else "" for x in inputString]
		#Find the pronounciations of important words
		pronunciationsList = pronounceParse(parsedString)
		#Find the alliterating letters and return as a dictionary
		allitDict, alignDict = alliterator(pronunciationsList)
		finalOutput = filter(allitDict, alignDict, parsedString.split())
		print(finalOutput)
		return(finalOutput)
	else:
		while True:
			inputString = input("Enter Sentence for detection: ")
			print(inputString)
			#Parse the string to remove determiners, etc
			parsedString = nltkParser(inputString)
			print(parsedString)
			unimportantString = [x if x not in parsedString else "" for x in inputString]
			#Find the pronounciations of important words
			pronunciationsList = pronounceParse(parsedString)
			#Find the alliterating letters and return as a dictionary
			allitDict, alignDict = alliterator(pronunciationsList)
			finalOutput = filter(allitDict, alignDict, parsedString.split())
			print(finalOutput)
			continueToken = input("Another sentence? (Y/N): ")
			if continueToken in ("y", "Y", "yes", "YES", "Yes"):
				continue
			else:
				break
		#StanfordServer.kill()

if __name__=='__main__':
	main()