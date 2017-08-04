import nltk, re, pprint
from nltk import word_tokenize
with open('anaphoraEx.txt', 'r') as f_open:
    data = f_open.read()
    data = data.split("|")

    example = """ We shall not flag or fail. We shall go on to the end. We shall fight in France, we shall fight on the seas and oceans, we shall fight with growing confidence and growing strength in the air, we shall defend our island, 
    whatever the cost may be, we shall fight on the beaches, we shall fight on the landing grounds, we shall fight in the fields and in the streets, we shall fight in the hills. We shall never surrender."""

    sents = nltk.sent_tokenize(example) 
    # tokens = word_tokenize(sents)
    # text = nltk.Text(tokens)
    # grammar = nltk.data.load("grammars/large_grammars/atis.cfg")
    # parser = nltk.parse.BottomUpChartParser(grammar)
    # char = parser.chart_parse(text)
    def tokenizeThis(sentence):
        output = []
        for sent in sentence:
            token = word_tokenize(sent)
            output.append(token)
        return output
    tokenizeThis(sents)


    
    # for example in data:
    #     toToken = example.splitlines()
    #     for sentence in toToken:
    #         tokens = word_tokenize(sentence)
    #         text = nltk.Text(tokens)

