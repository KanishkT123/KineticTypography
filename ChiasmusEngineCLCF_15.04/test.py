import nltk
from nltk import pos_tag, word_tokenize
from nltk.stem import WordNetLemmatizer

corpus = input ("Enter your sentence: ")


def lemma(word):
	WordNetLemmatizer().lemmatize(word)


def getTag(inputString):
	tokenized = pos_tag(word_tokenize(inputString))
	result = []
	for item in tokenized:
		result.append(list(item)) 
	for item in result:
		lemmatized = WordNetLemmatizer().lemmatize(item[0])
		item.append(lemmatized)
	print("the lemmas collect is finished.\n********start looking for chiasmus********\n")	
	print(result)




def ChiasmusMain(corpus):

	# get input from user
	
	getTag(corpus)

ChiasmusMain(corpus)
