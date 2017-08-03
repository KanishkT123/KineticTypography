#!/usr/bin/env python
# -*- coding: utf-8 -*-

#DONE: identify why the lemmas extract part is so long + 5 minutes/500ko utf8 file!
#TODO:Finding the appropriate tree tagger command to avoid conditionals. 

from Chiasme import Chiasme
import sys
import os
import re
import time
from xml.dom.minidom import Document
from xml.dom.minidom import getDOMImplementation

startT = time.clock()
listInput=sys.argv
if len(listInput)!=3:
	raise Exception("\n\n ERROR You didn't run the programm correctly. You must provide a corpus file and a name for the outputfile \n e.g. python Main.py MyInputFile.txt MyOutputName.txt \n\n Please provide correct arguments")
corpus=listInput[1]#Corpus file e.g. 'Churchill.txt'
sortie=listInput[2]#output file name
stopfile=open("StopWords","r")#file with the stopwords list

stoplist=stopfile.read().splitlines()[1:]

weightfile=open("weights","r")
weightList=[float(weight[0:weight.index(":")]) for weight in weightfile.read().splitlines()[2:]]
weightfile.close()
#*******************************************************************************************
#*********************************First Output******************************************
#*******************************************************************************************

def parseTexte(fichier):
	"""(string)->[[list], [list], [list]...]
	
	returns the text of the file in the form of a list of lists. Each list contain 3 items.
	this fonction calls treetagger and collects the answer of the software to create the lists
	1rst item = the word (with the order of the text respected), 2° item= the tagg, 3rd item = the list of lemmas
	
	>>>toto.txt "The cat sleeps. The dog sleeps"
	[[The, det, the] ,[cat, noun,cat] ,[sleeps, verb, sleep], [., sent,.]]
	
	"""
	#startT=time.clock()
	os.system("tree-tagger-english  "+fichier+" >output")#
	#taggT = time.clock()
	#print "Treetagger has finished tagging, timing:",taggT-startT,"start collecting lemmas"
	print("Treetagger has finished tagging, start collecting lemmas")
	newfile=open("output","r")#transition output given by treetagger
	newTaggedText=newfile.readlines()
	newfile.close()
	regex=re.compile("<.*>")
	listTagLn=[]
	for line in newTaggedText:
		to3Line=[]
		if regex.match(line)==None:

			to3Line=line[:-1].split('\t')
			if to3Line[2]=='<unknown>':#Condition we need to avoid
				to3Line[2]=to3Line[0]
				listTagLn.append(to3Line)
				

			elif to3Line[2]=='IN':#correction of a bug particular to "that		IN	that"
				to3Line.remove('')
				listTagLn.append(to3Line)
			else:
				listTagLn.append(to3Line)

	#lemmCollT=time.clock()			
	#print "the lemmas collect finished, timing:",lemmCollT-taggT,"\n\n\n********start looking for chiasmus********"
	print("the lemmas collect is finished.\n\n\n********start looking for chiasmus********\n")
	return listTagLn
	
textList=parseTexte(corpus)
lemmCollT=time.clock()
tailleliste = len(textList)


punctList=[",",".","'","[","]","!","»","’","\"",":"]
regex=re.compile("^[A-Za-z\'-]+$")#For other languages: "^[A-Za-zàùéèçâîûêôëïöäœ\'-]+$"
def absurd(word):#Caution:this is an hard constraint
	"""(String)->True/False
	
	returns True if the string does not correspond the pattern of a normal english word (=a set of alphabetic letters), False if the word is normal
	
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
lemmLwLst = [lemm[2].lower() for lemm in textList]
wordLst=[word[0] for word in textList]


#================Main loop================
iRevers=0#a count of the total reversion in the text
iA=0#"i" means the position number of the word in the text e.g. in the text "The cat is blue" if motA is the word 'cat' iA==1
chiasmaList={}#dictionary will contain every chiasm extracted indexed by there ranking score, e.g.{99,999:trust in money, money in trust, 5,5:One for all all for one}
for motA in textList:
	if absurd(motA[0]):
		iA=iA+1
		continue
	iD=iA+1
	motALower=lemmLwLst[iA]

	for motD in textList[iA+1:iA+30]:#this loop check 30 words after word A in order to catch an aidentical pair A A' (or motA motD pair)
			
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

					for motC in textList[iB+1:iD]:#Do not forget that the end limit is NOT inclusive so NO iD-1
						
						if motBLower!=lemmLwLst[iC]:#motC[2].lower():
							
							iC=iC+1
						
							
						else:								
							iRevers+=1
							chiasmus = Chiasme(motA,motB,iA,iD,textList,iB,iC,stoplist,weightList,motALower,motBLower,lemmLwLst,wordLst)
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

#### Proceed now the writing of the result file###


weightfile=open("weights","r")
weightList=weightfile.read().splitlines()
weightfile.close()
featureList=weightList[1].split(",")


 
imp = getDOMImplementation() 
doctype = imp.createDocumentType(qualifiedName="output",publicId="",systemId="dtd/output.dtd")  
doc = Document()

doc.appendChild(doctype)
root = doc.createElement('output')
doc.appendChild(root)
weights = doc.createElement('weights')
root.appendChild(weights)


for i in range(len(featureList)):
	featureElement=doc.createElement('feature')
	weights.appendChild(featureElement)
	
	featureElement.setAttribute('weight',str(weightList[i+2][0:weightList[i+2].index(":")]))
	featText=doc.createTextNode(str(featureList[i]))
	featureElement.appendChild(featText)
	
iRank=1
iPosition=0

for key in sorted(list(chiasmaList.keys()), reverse=True):
	
	tie = doc.createElement('tie')
	tie.setAttribute('rank',str(iRank))
	root.appendChild(tie)
	tie.setAttribute('score',str(key))
	iRank+=1
	for result in chiasmaList[key]:

		iPosition+=1
		chiasmElem = doc.createElement('chiasm')
		chiasmElem.setAttribute('position',str(iPosition))
		tie.appendChild(chiasmElem)
		wa = doc.createElement('wA')
		chiasmElem.appendChild(wa)
		waText=doc.createTextNode(result[0])
		wa.appendChild(waText)
		wa.setAttribute('iA',str(result[5]))
		wa.setAttribute('iD',str(result[8]))		
		
		wb = doc.createElement('wB')
		chiasmElem.appendChild(wb)
		wb.setAttribute('iB',str(result[6]))
		wb.setAttribute('iC',str(result[7]))
		wbText=doc.createTextNode(result[1])
		wb.appendChild(wbText)
		
		
		extractElem = doc.createElement('extract')
		contextElem = doc.createElement('context')
		chiasmElem.appendChild(extractElem)
		chiasmElem.appendChild(contextElem)
		contextText = doc.createTextNode(result[3])
		contextElem.appendChild(contextText)
		extractText=doc.createTextNode(result[2])
		extractElem.appendChild(extractText)
		
	
	
chiasmCollT=time.clock()
#print "End of the chiasmus collect and ranking. Timing: ",chiasmCollT,"\n Preparation of the XML file (First output)"
print("End of the chiasmus collect and ranking.\n Preparation of the XML file (First output)")
g=open(sortie+".xml","w")
g.write(doc.toprettyxml(indent='\t'))
g.close()
print("XML File done.")
print("Preparation of the annotation file via xsl stylesheet (Secondary output)")
os.system("xsltproc  "+"annotationDoc.xsl "+sortie+".xml"+" >"+sortie+"_annot.txt")#
secondaryT=time.clock()
print("annotation file done.")
#print "End of secondary output production, timing:",secondaryT-chiasmCollT," \nTotal time of the program=", secondaryT-startT
print("End of secondary output production ")#\nTotal time of the program=", secondaryT-startT
print("\n\n\nYour results are in 2 different outputs.\n-"+str(sortie)+".xml= detailed result in XML \n-"+str(sortie)+"_annot.txt = user friendly result for human annotators")
