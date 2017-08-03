# -*- coding: utf-8 -*-
#import re
from nltk.util import ngrams

class Chiasme:
	mota=""
	motb=""
	posa=0
	posd=0#posd ou position de A' dans la figure A B B' A' à l'intérieur du texte
	text=""
	posb=0
	posc=0
	stoplist=[]#Stopwords list
	weightList=[]

	def __init__(self, arg1, arg2, arg3, arg4, arg5, arg6, arg7,arg8,arg9,arg10,arg11,arg12,arg13):
		self.mota = arg1
		self.motb = arg2
		self.posa = arg3
		self.posd = arg4
		self.text = arg5
		self.posb = arg6
		self.posc = arg7
		self.stoplist=arg8
		self.weightList=arg9
		self.motaLower=arg10
		self.motbLower=arg11
		self.lemmLwLst=arg12
		self.wordLst=arg13
	def extract(self):
		"""(Chiasme)->String
		
		given the words position and the all text returns the part of the text containing the chiasmus
		
		>>>one,all,125,128,"Blabla and Portos said : all for one , one  for all ! Then Aramis opens a good bottle of wine blablabla ",130,132, [the, all, i, a, an]
		"all for one , one  for all"
		"""

		sentlst=self.wordLst[self.posa:self.posd+1]
		sent=" ".join(sentlst)#this is the chiasmus as a string
		return sent
		
		
	def extractContext(self):
		"""
		(Chiasme)->String
		
		given the words position and the all text returns the part of the text containing the chiasmus+ a little bit of context (5 words extra)
		
		>>>one,all,125,128,"Blabla and Portos said : all for one , one  for all ! Then Aramis opens a good bottle of wine blablabla ", 130,132,[the, all, i, a, an]
		"and Portos said : all for one , one  for all ! Then Aramis opens a good bottle"
		"""

		sentContextlst=self.wordLst[self.posa-5:self.posd+5]
		sentContext=" ".join(sentContextlst)
		return sentContext
	
	def getFeat(self):
		"""
		(Chiasme)->list
		
		Given a chiamus returns a list of features values
		>>>one,all,125,128,"Blabla and Portos said : all for one , one  for all ! Then Aramis opens a good bottle of wine blablabla ", 130,132,[the, all, i, a, an]
		[5,0,2,3,5,5,47.6,59]
		"""
		sentlst=[]

		for trio in self.text[self.posa:self.posd+1]:
			sentlst.append(trio[0]) 

		hardPuncts=[":",".",";","*","?","!",")","("]
		softPuncts=","
		conjCoords=["and","as","because","for","yet","nor","so","or","but"]
		noPunctAllowed=[]
		noPunctAllowed=self.wordLst[self.posa+1:self.posb]+self.wordLst[self.posc+1:self.posd]
		#======================True/False Feature tests=====================
		punctScore=0
		softPunctScore=0
		isInStopListA=0
		isInStopListB=0
		diffSize=0
		sameStringBetween=0
		distance=0
		hasConjBC=0
		centralPunctScore=0
		simScore=0.0
		relativSimScore=0.0
		hasNo=0
		hasNot=0
		hasNever=0
		hasNothing=0
		hasIntoTo=0
		bigramScore=0
		trigramScore=0
		simContCent=0
		hasMainsRep=-2
		
		for punct in hardPuncts:#loop for checking the position of the ponctuations
			punctScore+=noPunctAllowed.count(punct)
		
		softPunctScore=noPunctAllowed.count(softPuncts)
		
		if self.motaLower in self.stoplist: #Filters -> THE cat live with a cat but THE dog
			isInStopListA=1
		if self.motbLower in self.stoplist:#Filters inner stopwords -> Max likes THE cat and THE dog but my cat does not like Max.
			isInStopListB=1	
		diffSize=len(self.text[self.posa:self.posb])-len(self.text[self.posc:self.posd])
		diffSize=abs(diffSize)
		
		if self.text[self.posa+1:self.posb]==self.text[self.posc+1:self.posd]:
			sameStringBetween=1
		distance=self.posc-self.posb
		
		centerPart=self.lemmLwLst[self.posb+1:self.posc]
		for punct in hardPuncts:#loop for checking the position of the ponctuations
			centralPunctScore+=centerPart.count(punct)


		for conj in conjCoords:
			if conj in centerPart:
				hasConjBC=1
	
		lemmsAtoB=self.lemmLwLst[self.posa+1:self.posb]
		lemmsCtoD=self.lemmLwLst[self.posc+1:self.posd]
		simScore=len(set(lemmsAtoB).intersection(lemmsCtoD))
		
		lengthAtoBCtoD=float(self.posb-self.posa+self.posd-self.posc)
		relativSimScore=10.0*simScore/lengthAtoBCtoD
		
		#***Negations dectection in chiasm AND context***
		lemmWthContlst=self.lemmLwLst[self.posa-5:self.posd+5]

		if "no" in lemmWthContlst:
			hasNo=1
				
		if "not" in lemmWthContlst:
			hasNot=1
		
		if "never" in lemmWthContlst:
			hasNo=1
		
		if "nothing" in lemmWthContlst:
			hasNothing=1
		
		if "to" in lemmsAtoB and "to" in lemmsCtoD or "into" in lemmsAtoB and "into" in lemmsCtoD or "from" in lemmWthContlst and "to" in lemmWthContlst and lemmWthContlst.index('from')<lemmWthContlst.index('to'):
			hasIntoTo=1
		
		bigrams1=ngrams(self.lemmLwLst[self.posa:self.posb+1],2)
		bigrams2=ngrams(self.lemmLwLst[self.posc:self.posd+1],2)
		bigramScore=len(set(bigrams1).intersection(bigrams2))
		
		trigrams1=ngrams(self.lemmLwLst[self.posa:self.posb+1],3)
		trigrams2=ngrams(self.lemmLwLst[self.posc:self.posd+1],3)
		trigramScore=len(set(trigrams1).intersection(trigrams2))
		
		contextLeft=self.lemmLwLst[self.posa-5:self.posa]
		simContCent=len(set(contextLeft).intersection(centerPart))
		
		hasMainsRep+=self.lemmLwLst[self.posa+1:self.posd].count(self.motaLower)+self.lemmLwLst[self.posa+1:self.posd].count(self.motbLower)

			
		return [punctScore,softPunctScore,isInStopListA,isInStopListB,diffSize,sameStringBetween,distance,centralPunctScore,hasConjBC,simScore,relativSimScore,hasNo,hasNot,hasNever,hasNothing,hasIntoTo,bigramScore,trigramScore,simContCent,hasMainsRep]
	def rank(self):#call it score please
		"""(Chiasme)->Float
		
		given a chiasmus and its words returns a score of probability
		
		>>>one,all,125,128,"Blabla and Portos said : all for one , one  for all ! Then Aramis opens a good bottle of wine blablabla ", 130,132,[the, all, i, a, an]
		42.0
		"""


		score=0
		featList=self.getFeat()
		i=0
		while i<len(featList):
			
			score=score+featList[i]*self.weightList[i]

			i=i+1
		return score+10
		
