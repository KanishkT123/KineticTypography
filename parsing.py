import nltk, re, pprint
from pycorenlp import StanfordCoreNLP
nlp = StanfordCoreNLP('http://localhost:9000')
from nltk import word_tokenize, sent_tokenize
with open('anaphoraEx.txt', 'r') as f_open:
    data = f_open.read()
    data = data.split("|")

    # example = """ We shall not flag or fail. We shall go on to the end. We shall fight in France, we shall fight on the seas and oceans, we shall fight with growing confidence and growing strength in the air, we shall defend our island, 
    # whatever the cost may be, we shall fight on the beaches, we shall fight on the landing grounds, we shall fight in the fields and in the streets, we shall fight in the hills. We shall never surrender."""

    # example = "It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the epoch of belief, it was the epoch of incredulity, it was the season of Light, it was the season of Darkness, it was the spring of hope, it was the winter of despair."

    # example = "Shel Turtlestein was many things, but above all he was my friend. When I didn’t get a date with Fiona Gunderson, Shel was there. When I didn’t get to play the part of Tevye, Shel was there. And when a raccoon broke into my room, unfortunately, Shel was there."

    example = "America how can I write a holy litany in your silly mood?"

    sentEx = nltk.sent_tokenize(example) 
    # def tokenizeThis(sentence):
    #     output = []
    #     for sent in sentence:
    #         token = word_tokenize(sent)
    #         output.append(token)
    #     return output
    # tokenizeThis(sents)

    for sentences in sentEx:
        output = nlp.annotate(sentences, properties={'annotators': 'tokenize,ssplit,pos,depparse,parse', 'outputFormat': 'json'})
        tree = nltk.Tree.fromstring(output['sentences'][0]['parse'])
        print(tree)
        tree.draw()
