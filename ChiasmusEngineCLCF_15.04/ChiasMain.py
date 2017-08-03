#!/usr/bin/env python
# -*- coding: utf-8 -*-

#DONE: identify why the lemmas extract part is so long + 5 minutes/500ko utf8 file!
#TODO:Finding the appropriate tree tagger command to avoid conditionals. 
import nltk
from nltk import pos_tag, word_tokenize
from nltk.stem import WordNetLemmatizer
from Chiasme import Chiasme
import sys
import os
import re
import time

# startT = time.clock()
# listInput=sys.argv
# if len(listInput)!=3:
# 	raise Exception("\n\n ERROR You didn't run the programm correctly. You must provide a corpus file and a name for the outputfile \n e.g. python Main.py MyInputFile.txt MyOutputName.txt \n\n Please provide correct arguments")
# corpus=listInput[1]#Corpus file e.g. 'Churchill.txt'
# sortie=listInput[2]#output file name

# get input from user
corpus = input ("Enter your sentence: ")

stopfile=open("StopWords","r")#file with the stopwords list
stoplist=stopfile.read().splitlines()[1:]

weightfile=open("weights","r")
weightList=[float(weight[0:weight.index(":")]) for weight in weightfile.read().splitlines()[2:]]
weightfile.close()
#*******************************************************************************************
#*********************************First Output******************************************
#*******************************************************************************************


def getTag(inputString):
	"""(string)->[[list], [list], [list]...]
	
	returns the text of the file in the form of a list of lists. Each list contain 3 items.
	this fonction calls treetagger and collects the answer of the software to create the lists
	1rst item = the word (with the order of the text respected), 2° item= the tagg, 3rd item = the list of lemmas
	
	>>>toto.txt "The cat sleeps. The dog sleeps"
	[[The, det, the] ,[cat, noun,cat] ,[sleeps, verb, sleep], [., sent,.]]
	[['The', 'DT', 'The'], ['cat', 'NN', 'cat'], ['sleeps', 'NN', 'sleep'], ['.', '.', '.'], ['The', 'DT', 'The'], ['dog', 'NN', 'dog'], ['sleeps', 'NNS', 'sleep']]
	"""

	tokenized = pos_tag(word_tokenize(inputString))
	result = []
	for item in tokenized:
		result.append(list(item)) 
	for item in result:
		lemmatized = WordNetLemmatizer().lemmatize(item[0])
		item.append(lemmatized)
	print("********Here is the chiasmus word and their location********")	
	return result

# the punctuation list 
punctList=[",",".","'","[","]","!","»","’","\"",":"]
# the regular expression object
regex=re.compile("^[A-Za-z\'-]+$")#For other languages: "^[A-Za-zàùéèçâîûêôëïöäœ\'-]+$"


def absurd(word):#Caution:this is an hard constraint
	"""(String)->True/False
	
	returns True if the string does not correspond the pattern of 
	a normal english word (=a set of alphabetic letters), False if the word is normal
	
	>>>"_hell@"
	True
	>>>"Hello"
	False		
	
	"""
	if regex.match(word)==None:
		return True
	if word=="-" or word=="'" or word=="''":
		return True
	return False

def absurd2(word1,word2):
	"""(String1, String2)->True/False
	
	returns True if the two lowercased strings are exacltly the same False if not.
	
	>>>"Hello", "hello"
	True
	>>>"Hello", "bonjour"
	False		
	
	"""
	if word1==word2:
		return True
	return False


#================Main loop================
def ChiasmusMain(corpus):

	# file with the stopwords list
	stopfile=open("StopWords","r")
	stoplist=stopfile.read().splitlines()[1:]

	#file with the weights list
	weightfile=open("weights","r")
	weightList=[float(weight[0:weight.index(":")]) for weight in weightfile.read().splitlines()[2:]]
	weightfile.close()

	# textList is the tagged result of the input string (corpus) in format of 
	# [[list], [list], [list]...]
	# tailleliste is the length of textList (how long is the sentence in terms of word)	
	textList=getTag(corpus)
	tailleliste = len(textList)

	# the punctuation list 
	# punctList=[",",".","'","[","]","!","»","’","\"",":"]
	# the regular expression object
	# regex=re.compile("^[A-Za-z\'-]+$")#For other languages: "^[A-Za-zàùéèçâîûêôëïöäœ\'-]+$"

	# change to lower case for all lemmatized word om textList (3rd argument)
	lemmLwLst = [lemm[2].lower() for lemm in textList]
	# print (lemmLwLst)
	# the original word list from textList (1st argument)
	wordLst=[word[0] for word in textList]
	# print (wordLst)

	#a count of the total reversion in the text
	iRevers=0
	#"i" means the position number of the word in the text 
	# e.g. in the text "The cat is blue" if motA is the word 'cat' iA==1
	iA=0
	#dictionary will contain every chiasm extracted indexed by there ranking score, 
	#e.g.{99,999:trust in money, money in trust, 5,5:One for all all for one}
	chiasmaList={}
	for motA in textList:
		if absurd(motA[0]):
			iA=iA+1
			continue
		iD=iA+1
		motALower=lemmLwLst[iA]

		#this loop check 30 words after word A 
		#in order to catch an aidentical pair A A' (or motA motD pair)
		for motD in textList[iA+1:iA+30]:
				
				if motALower==lemmLwLst[iD]:#motD[2].lower():				
					
					iB=iA+1#iB is the position of motB
					
					for motB in textList[iA+1:iD-1]:#only up to D-2
					
						if absurd(motB[0]):
							iB=iB+1
							continue
						motBLower=lemmLwLst[iB]
						
						if absurd2(motALower,motBLower):
							iB=iB+1
							continue
						iC=iB+1

						#Do not forget that the end limit is NOT inclusive so NO iD-1
						for motC in textList[iB+1:iD]:
							
							if motBLower!=lemmLwLst[iC]:#motC[2].lower():
								
								iC=iC+1
							
								
							else:								
								iRevers+=1
								chiasmus = Chiasme(motA,motB,iA,iD,textList,iB,iC,stoplist,weightList,motALower,motBLower,lemmLwLst,wordLst)
								# print (chiasmaList)
								chiasmusTxt = chiasmus.extract()
								chiasmusContxt=chiasmus.extractContext()
								chiasmusScore=chiasmus.rank()
								if chiasmusScore>=0: 
									if chiasmusScore in chiasmaList:
										chiasmaList[chiasmusScore].append([motA[2], motB[2],chiasmusTxt,chiasmusContxt,chiasmusScore,iA,iB,iC,iD])
										
									else:
										# create a new array in this slot
										chiasmaList[chiasmusScore] = [[motA[2]]+ [motB[2]]+[chiasmusTxt]+[chiasmusContxt]+[chiasmusScore]+[iA]+[iB]+[iC]+[iD]]
										
								
								iC=iC+1			
						iB=iB+1
				iD=iD+1
				
		iA=iA+1	
	maxRank = 0
	for rank in chiasmaList:
		if rank > maxRank:
			maxRank = rank
	if not chiasmaList:
		print ("No chiasmus")
	else:
		result = chiasmaList[maxRank][0]
		sentence = result[2]
		firstWord = result[0]
		secondWord = result[1]
		indexOfFirstWord = [result[5],result[8]]
		indexOfSecondWord = [result[6],result[7]]
		print (firstWord, indexOfFirstWord, secondWord, indexOfSecondWord)

	# print (chiasmus)

	#### Proceed now the writing of the result ###


	# weightfile=open("weights","r")
	# weightList=weightfile.read().splitlines()
	# weightfile.close()
	# featureList=weightList[1].split(",")


	 
	# imp = getDOMImplementation() 
	# doctype = imp.createDocumentType(qualifiedName="output",publicId="",systemId="dtd/output.dtd")  
	# doc = Document()

	# doc.appendChild(doctype)
	# root = doc.createElement('output')
	# doc.appendChild(root)
	# weights = doc.createElement('weights')
	# root.appendChild(weights)


	# for i in range(len(featureList)):
	# 	featureElement=doc.createElement('feature')
	# 	weights.appendChild(featureElement)
		
	# 	featureElement.setAttribute('weight',str(weightList[i+2][0:weightList[i+2].index(":")]))
	# 	featText=doc.createTextNode(str(featureList[i]))
	# 	featureElement.appendChild(featText)
		
	# iRank=1
	# iPosition=0

	# for key in sorted(list(chiasmaList.keys()), reverse=True):
		
	# 	tie = doc.createElement('tie')
	# 	tie.setAttribute('rank',str(iRank))
	# 	root.appendChild(tie)
	# 	tie.setAttribute('score',str(key))
	# 	iRank+=1
	# 	for result in chiasmaList[key]:

	# 		iPosition+=1
	# 		chiasmElem = doc.createElement('chiasm')
	# 		chiasmElem.setAttribute('position',str(iPosition))
	# 		tie.appendChild(chiasmElem)
	# 		wa = doc.createElement('wA')
	# 		chiasmElem.appendChild(wa)
	# 		waText=doc.createTextNode(result[0])
	# 		wa.appendChild(waText)
	# 		wa.setAttribute('iA',str(result[5]))
	# 		wa.setAttribute('iD',str(result[8]))		
			
	# 		wb = doc.createElement('wB')
	# 		chiasmElem.appendChild(wb)
	# 		wb.setAttribute('iB',str(result[6]))
	# 		wb.setAttribute('iC',str(result[7]))
	# 		wbText=doc.createTextNode(result[1])
	# 		wb.appendChild(wbText)
			
			
	# 		extractElem = doc.createElement('extract')
	# 		contextElem = doc.createElement('context')
	# 		chiasmElem.appendChild(extractElem)
	# 		chiasmElem.appendChild(contextElem)
	# 		contextText = doc.createTextNode(result[3])
	# 		contextElem.appendChild(contextText)
	# 		extractText=doc.createTextNode(result[2])
	# 		extractElem.appendChild(extractText)
			
		
ChiasmusMain(corpus)	
	#print "End of the chiasmus collect and ranking. Timing: ",chiasmCollT,"\n Preparation of the XML file (First output)"
# print("End of the chiasmus collect and ranking.\n ")

