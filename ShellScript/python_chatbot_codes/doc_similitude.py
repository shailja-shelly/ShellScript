import nltk, string
from sklearn.feature_extraction.text import TfidfVectorizer
from nltk import PorterStemmer
from nltk import pos_tag
from log import error_logger, info_logger
from stopterms import ENGLISH_STOP_WORDS
import os
import time
from sklearn.metrics.pairwise import cosine_similarity
import warnings
import ConfigParser
import applicationExceptionHandlingFramework
from applicationExceptionHandlingFramework import *
import businessexceptionHandlingFramework
from businessexceptionHandlingFramework import *
from nltk.stem.wordnet import WordNetLemmatizer
import textblob
from textblob import TextBlob
#from Laureate_rest import selected_question_flag

stemmer = PorterStemmer()
Config = ConfigParser.ConfigParser()
present_working_dir = os.getcwd()
warnings.filterwarnings(action='ignore', category=UserWarning)
Config.read(os.path.join(present_working_dir,"property.ini"))
remove_punctuation_map = dict((ord(char), None) for char in string.punctuation)

onewordquery_msg = Config.get('message','onewordquery_msg')
rephrase_msg = Config.get('message','rephrase_msg')

scoregreater= Config.get('message_to_user','scoregreater')
scorelesser=Config.get('message_to_user','scorelesser')
scoreequal=Config.get('message_to_user','scoreequal')
scoretooless=Config.get('message_to_user','scoretooless')
msg_when_score_less_than_threshold=Config.get('message_to_user','msg_when_score_less_than_threshold')
msg_to_user=""
msg_to_user_only_1_ans=Config.get('message_to_user','msg_to_user_only_1_ans')

def stem_tokens(tokens):
    return [stemmer.stem(item) for item in tokens]

#below original
def normalize(text):
      return stem_tokens(nltk.word_tokenize(text.translate(remove_punctuation_map)))

#below my modified normalize function
# def normalize(text1):
#     # return lementize_tokens(nltk.word_tokenize(text.lower()))
#     #print "text :",text1
#     # for t in text1:
#     #     print("printinggg",TextBlob(t).correct())
#
#     correctedtext=[]
#     #b = TextBlob(text1)
#     #print "b",b
#     # for t in b:
#     #
#     #     ques=b.correct()
#     #     print "ques",ques
#     #     #correctedtext.append(ques)
#     #
#     #     #ques1=str(ques)
#     #print "After correction : ",text1
#     # print text.lower().translate(remove_punctuation_map)
#     #print "correctedtext",correctedtext
#     #text1=str(correctedtext)
#
#     tag_list = pos_tag(nltk.word_tokenize(text1.lower().translate(remove_punctuation_map)))
#     lematized_data = lementize_tokens(tag_list)
#     # print text
#     #info_logger.info("lematized data is :%s",lematized_data)
#     # print lematized_data
#     return lematized_data
#     # return (nltk.word_tokenize(text.lower().translate(remove_punctuation_map)))
# #MY added code below
#
#
# def lementize_tokens(tokens):
#     # print "Tokens before :",tokens
#
#     new_tokens=[]
#     for item ,pos in tokens:
#         if str(pos).startswith('NN'):
#             new_tokens.append((item,'n'))
#         elif str(pos).startswith('VB'):
#             new_tokens.append((item,'v'))
#         elif str(pos).startswith('JJ'):
#             new_tokens.append((item,'a'))
#         elif str(pos).startswith('RB'):
#             new_tokens.append((item,'r'))
#         else:
#             new_tokens.append((item,'n'))
#     # print "Tokens after :",new_tokens
#
#     return [lmtzr.lemmatize(item,pos) for item,pos in new_tokens]
#
# lmtzr = WordNetLemmatizer()

def cosine_similarity_mod(doc_list):
    try:
        print "doc_list from :",
        #calculating tfidf_vectorizer and applying fit_transform
        tfidf_vectorizer = TfidfVectorizer(tokenizer=normalize, stop_words=list(ENGLISH_STOP_WORDS), ngram_range=(1, 1),
                                           max_features=270, norm='l2', lowercase=True)

        #max_features=200 original
        tfidf_matrix = tfidf_vectorizer.fit_transform(doc_list)
        #print "tfidf_vectorizer.get_feature_names()",tfidf_vectorizer.get_feature_names()#[u'abl', u'acad', u'access', u'account
        #print "tfidf_matrix clclc",tfidf_matrix
        info_logger.info("tfidf_vectorizer calculated")
        info_logger.info("tfidf_matrix calculated")
        #print "tfidf_vectorizer.get_feature_names() aahe",tfidf_vectorizer.get_feature_names()
        return tfidf_vectorizer.get_feature_names(), tfidf_matrix

    except ValueError as err:
        error_logger.error(rephrase_msg,exc_info=True )
        return rephrase_msg, ""


def document_reader():
    present_dir = os.getcwd()
    Documents = Config.get('path','doc_file')
    input_file = os.path.join(present_dir, Documents)
    document_list = []

    with open(input_file) as f1:
        for line in f1:
            row = line.strip().lower()
            document_list.append(row)


    return document_list


data_list = document_reader()
#print "data_list",data_list   #can add below prints to info
#print "data_list",data_list
feature_names, tfidf_matrix = cosine_similarity_mod(data_list)
#print "feature_names aahhee:",feature_names
#print "tfidf_matrix aahhee :",tfidf_matrix

def question_type(query):
    yesnowords = ["can", "could", "would", "is", "does", "has", "was", "were", "had", "have", "did", "are", "will","possible"]
    query_type_flag = False
    yn_word = ""
    for yn in yesnowords:
        if query.startswith(yn):
            yn_word = yn
            query_type_flag = True
            break
        else:
            continue

    return yn_word,query_type_flag

def similarity_cal(test_doc):
    try:
        print "[0] : ", [0]
        feature_names_list = [0] * len(feature_names) #?..chk
        #print "feature_names_list : ",feature_names_list #array wid all 0s..like feature_names_list :  [0, 0, 0, ..0]
        test_feature_names, test_tfidf_matrix = cosine_similarity_mod(test_doc)
        #print "test_tfidf_matrix arrrree",test_tfidf_matrix #...(0, 1)	0.5773502691896258   (0, 2)	0.5773502691896258 ..
        print "test_feature_names arrrree",test_feature_names #[u'asset', u'how', u'transfer']

        if test_feature_names == rephrase_msg and test_tfidf_matrix == "":
            return rephrase_msg

        for tf_idf_row in test_tfidf_matrix.toarray():
            tf_idf_list = [(term, tfidf_val) for term, tfidf_val in zip(test_feature_names, tf_idf_row)]
        info_logger.info("tf_idf_list : %s",tf_idf_list)
        print "tf_idf_list iss",tf_idf_list#tf_idf_list [(u'asset', 0.5773502691896258), (u'how', 0.5773502691896258), (u'transfer', 0.5773502691896258)]
        for term, score in tf_idf_list:
            if term in feature_names:
                feature_names_list[feature_names.index(term)] = score
                #print "feature_names_list onn",feature_names_list #like feature_names_list [0, 0, 0, 0.707, ....0]
            else:
                continue
        return feature_names_list
    except ValueError as err:
        error_logger.error(rephrase_msg,exc_info=True )
        return rephrase_msg

#ORIGINAL sim function
# def sim(test_matrix):
#     try:
#         score_matrix = cosine_similarity([test_matrix], tfidf_matrix)
#         print "SCORE FOR SENTENCE ",score_matrix[0][score_matrix[0].argsort()[-1:][0]]
#         # print score_matrix[0][score_matrix[0].argsort()[-1:][0]]
#         print "SENTENCE IS  : ",data_list[score_matrix[0].argsort()[-1:][0]]
#
#         if score_matrix[0][score_matrix[0].argsort()[-1:][0]] > 0.55:
#
#             target_ans = data_list[score_matrix[0].argsort()[-1:][0]]
#             print "target_ans",target_ans
#         else:
#             target_ans = rephrase_msg
#         return target_ans
#     except ValueError as err:
#         error_logger.error(rephrase_msg,exc_info=True )
#         return rephrase_msg



#below is my sim functn vrsn 2 :
def sim(test_matrix,selected_question_flag):
     try:
         print "HERE"
         #print "tfidf matrix printng frm sim : ",tfidf_matrix
         mycreatedarray=[]
         blankarray=[]
         score_matrix = cosine_similarity([test_matrix], tfidf_matrix)
         #print "score_matrix calculated HERE"#NOT PRINTING IT
         print "SCORE FOR SENTENCE ",score_matrix[0][score_matrix[0].argsort()[-1:][0]]
         # print score_matrix[0][score_matrix[0].argsort()[-1:][0]]


         print "SENTENCE IS  : ",score_matrix[0].argsort()[-4:][0:4]


         # print "data_list[111]",data_list[111]
         # print "data_list[112]",data_list[112]
         # print "data_list[110]",data_list[110]
         # print "data_list[129]",data_list[129]
         print "printing thresholds : ",score_matrix[0][score_matrix[0].argsort()[-4:][0:4]]
         print "selected_question_flag_in_DCS",selected_question_flag
         if (score_matrix[0][score_matrix[0].argsort()[-1:][0]] > 0.55 and  selected_question_flag == 0):

             msg_to_user=scoregreater
             target_ans = data_list[score_matrix[0].argsort()[-1:][0]]
             print "target_ans",target_ans
             t2ans=score_matrix[0].argsort()[-1:][0:1]
             #print "t2ans",t2ans
             print "target_ans",target_ans

             return target_ans,msg_to_user,score_matrix[0].argsort()[-4:][0:4]
             #,selected_question_flag #idid [-4:][0:3] nstead of [-4:][0:4] to get othr 3 qns only

         elif (score_matrix[0][score_matrix[0].argsort()[-1:][0]] > 0.55 and  selected_question_flag == 1):


             target_ans = data_list[score_matrix[0].argsort()[-1:][0]]
             t2ans=score_matrix[0].argsort()[-1:][0:1]
             #print "t2ans",t2ans
             print "target_ans",target_ans
             return target_ans,msg_to_user_only_1_ans,score_matrix[0].argsort()[-4:][0:4]
             # original :return target_ans,msg_to_user,blankarray #,selected_question_flag#,

         if (score_matrix[0][score_matrix[0].argsort()[-1:][0]] < 0.55) and (score_matrix[0][score_matrix[0].argsort()[-1:][0]] > 0.170):
             target_ans = rephrase_msg
             msg_to_user=msg_when_score_less_than_threshold
             return target_ans,msg_to_user,score_matrix[0].argsort()[-4:][0:4]
         else:
              target_ans = rephrase_msg
              msg_to_user=scoretooless
              return target_ans,msg_to_user,blankarray

     except ValueError as err:
         error_logger.error(rephrase_msg,exc_info=True )
         return rephrase_msg


def main(test_doc,selected_question_flag):
    msgfrusr=""
    indexerarray=[]

    #removing 'can' from the qn to improve score
    if "how can" in test_doc:
        test_doc = test_doc.replace("can","")

    if len(test_doc.strip().split(" ")) >= 1:
        info_logger.info("IN len(test_doc.strip().split(" ")) > 1")
        test_doc_list = [test_doc, ]
        test_matrix = similarity_cal(test_doc_list) #test_matrix :  [0, 0, 0, 0.707,0..0]
        info_logger.info("test_matrix calculated")
        #print "test_matrix isssssssssssssssss: ",test_matrix
        info_logger.info("test_matrix calculated:")

        if test_matrix == rephrase_msg:

            info_logger.info(test_matrix == rephrase_msg)
            #msgfrusr="TO ASSIST YOU, PLEASE INFORM IF YOU MEANT ANY OF THE FOLLOWING"
            return rephrase_msg,msgfrusr,indexerarray
        elif test_matrix == onewordquery_msg:
        #elif "Will you please be more specific..?" in test_matrix:

            info_logger.info("test_matrix == onewordquery_msg")
            return onewordquery_msg,msgfrusr,indexerarray

        #calculate targetQn, mesage for user, array for alternate qns
        answer,msgfrusr,indexerarray = sim(test_matrix,selected_question_flag)
        #print "indexerarray aahe",indexerarray
        #for indexiterator in indexerarray:


        return answer,msgfrusr,indexerarray

    else:
        info_logger.info("IN : NOT len(test_doc.strip().split(" ")) > 1)")
        msg_to_user=scoretooless
        return onewordquery_msg,msgfrusr,indexerarray


if __name__ == "__main__":
    while True:
        test_doc = raw_input()
        test_doc_list = [test_doc, ]
        start_time = time.time()
        test_matrix = similarity_cal(test_doc_list)
        answer,msgfrusr,indexerarray = sim(test_matrix)
        end_time = time.time()
        print "time taken :", end_time - start_time
