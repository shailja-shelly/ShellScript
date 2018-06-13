# -*- coding: utf-8 -*-
import nltk, string
import os
import codecs
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from nltk import PorterStemmer, pos_tag
from nltk.stem.wordnet import WordNetLemmatizer
import ConfigParser
import logging
import csv


"""salutation_refined.py: This file's purpose is to recognize and provide responses when salutations are received"""
__author__      = "Aditya Haralikar"
__copyright__   = "Copyright 2018, ATC"
__version__ = "1.0.0"

#ALgo step 1 : loading  csv files, filling out the blank fields, convertig the required columns into lists
output_file = os.path.join(os.getcwd(), 'salutation.csv')
salutation_laureate_file=pd.read_csv(output_file)
salutation_laureate_file['Salutation'].fillna("None", inplace=True)
salutations = list(salutation_laureate_file['Salutation'])
salutation_response = list(salutation_laureate_file['Expected_Response'])

lmtzr = WordNetLemmatizer() #for lemmatization
stemmer = PorterStemmer() #for stemming
remove_punctuation_map = dict((ord(char), None) for char in string.punctuation)

"""
for stemming
:param token
:return:stemmed tokens
"""
def stem_tokens(tokens):
    return [stemmer.stem(item) for item in tokens]

"""
for lemmatization of text
:param:tokens
:return:lemmatized tokens
"""
def lementize_tokens(tokens):


    new_tokens=[]
    for item ,pos in tokens:
        if str(pos).startswith('NN'):
            new_tokens.append((item,'n'))
        elif str(pos).startswith('VB'):
            new_tokens.append((item,'v'))
        elif str(pos).startswith('JJ'):
            new_tokens.append((item,'a'))
        elif str(pos).startswith('RB'):
            new_tokens.append((item,'r'))
        else:
            new_tokens.append((item,'n'))

    return [lmtzr.lemmatize(item,pos) for item,pos in new_tokens]


#for normalization of text
def normalize(text):

    tag_list = pos_tag(nltk.word_tokenize(text.lower().translate(remove_punctuation_map)))
    lematized_data = lementize_tokens(tag_list)

    return lematized_data

#applying TfidfVectorizer
#vectorizer = TfidfVectorizer(tokenizer=normalize, stop_words='english', ngram_range=(1,1), max_features=150)
vectorizer = TfidfVectorizer(tokenizer=normalize, ngram_range=(1,1), max_features=150)


"""
calculation of cosine similarity
:param:text1,text2 : the 2 texts to be compared
:return:cosine similarity value
"""
def cosine_sim(text1, text2):
    tfidf = vectorizer.fit_transform([text1, text2])
    #print vectorizer.get_feature_names()
    return ((tfidf * tfidf.T).A)[0, 1]

"""
calculating and returning best match and its index
:param: text1,sentences : text1 : the input to be checkd for salutation, 
sentences: the list of salutations
return : the best match and its score 
"""

def checkSalutation(text1, sentences):

  try:
    tf_lst = {}
    #print "sentences are",sentences
    for sentence in sentences: # cosine similarity calulation of every sentence in salutation list with question

        tf_lst[sentence] = cosine_sim(text1, sentence)


    matched_sentence = sorted(tf_lst, key=tf_lst.get, reverse=True)[:1][0]
    return matched_sentence, float(tf_lst[matched_sentence])

  except Exception as e:
        print "Exception issssss",e

if __name__ == "__main__":

        sentences_salutation=["thank you","hi", "thanks","hello","hey","bro","how are you","bye","good morning","good night","good afternoon","good evening","what do u mean","how do you do","are you a bot","what can you help me with",
                          "how can you help me","what do you do","hey you","hello how are you","how are you today","can you provide me few inputs","emma how are you","hello how are you","hi emma","i am not sure if a bot can help me but i want to give it a try",
                          "i need some help","What can you do",
                          "i am not sure if a bot can help me but","Wassup","Whats up","are you"]
        ques="I need a requestor role."
        #ques="hello emma mam"
        # ques = "Good to chat with you"
        s_flag=0 #the 'is_salutation' flag, initialized to 0
        match, score = checkSalutation(ques,salutations) #calculating the cosine similarity
        print salutations
        print "ques",ques
        print "match:",match
        print "SCore",score

        if score> 0.4551:
            s_flag=1
            print s_flag
            print"It is Salutation"

        #indexing on field 'Salutation'
        index=salutation_laureate_file['Salutation']

        #calculating the index in salutations where match is found
        for index_counter in range(0,100,1):
            if salutations[index_counter]==match:
                actual_index=index_counter
                break



        if score>0.4551:
            answer=salutation_response[actual_index]
            print "Answer is :",answer


