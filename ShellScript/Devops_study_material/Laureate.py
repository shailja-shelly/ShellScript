import nltk
from flask import Flask, jsonify, request, session
import re
import aiml
import doc_similitude
import os
import sys
import re
import time
import textblob
from textblob import TextBlob
#import unicodedata
import salutation_refined
from spell_check import sentence_correction
from log import *
import ConfigParser
import applicationExceptionHandlingFramework
from applicationExceptionHandlingFramework import *
import businessexceptionHandlingFramework
from businessexceptionHandlingFramework import *
import exceptionEnum
from exceptionEnum import *
import pandas as pd

output_file = os.path.join(os.getcwd(), 'salutation.csv')
salutation_laureate_file=pd.read_csv(output_file)
salutation_laureate_file['Salutation'].fillna("None", inplace=True)
salutations = list(salutation_laureate_file['Salutation'])
salutation_response = list(salutation_laureate_file['Expected_Response'])


# output_file = os.path.join(os.getcwd(), 'salutation.csv')
# intent_file = pd.read_csv(output_file)
# salutation_list = list(intent_file['Salutation'])

try:
    kernel = aiml.Kernel()
    Config = ConfigParser.ConfigParser()
    present_working_dir =  os.getcwd()
    Config.read(os.path.join(present_working_dir,"property.ini"))

    #below 4 original
    # kernel.bootstrap(learnFiles=Config.get('path', 'data_aiml'), commands="load aiml b")
    # kernel.saveBrain("bot_brain.brn")
    # info_logger.info("kernal loaded")
    # print "kernal loaded"
except (ConfigParser.NoOptionError, ConfigParser.NoSectionError ) as e:
    error_logger.error(e,exc_info=True )


onewordquery_msg = Config.get("message","onewordquery_msg")
rephrase_msg = Config.get("message","rephrase_msg")
is_specific=Config.get("message","is_specific")
msg_when_score_less_than_threshold=Config.get("message_to_user","msg_when_score_less_than_threshold")
msguserwensalutation=Config.get("message","msguserwensalutation")
msg_to_user_only_1_ans=Config.get('message_to_user','msg_to_user_only_1_ans')


def start(user_query, aiml_file_path,selected_question_flag,path_filter):
    s_flag=0
    blankarray=[]
    blankmsg=""
    #thattaglist=["credit card related","if credit card information is not empty","acad discipline related","preferred or non preferred merchant related"]

    print "path_filter",path_filter

    kernel=aiml.Kernel()
    del(kernel)

    kernel=aiml.Kernel()

    if path_filter=="Laureate Procedures & Policies_English":   #Config.get('path', 'data_aiml_peoplesoft'):
         print Config.get('path', 'data_aiml_laureate_procedures_and_policies')
         kernel.bootstrap(learnFiles=Config.get('path', 'data_aiml_laureate_procedures_and_policies'), commands="load aiml b")

    else:
         print "learnFiles"
         print Config.get('path', 'data_aiml_peoplesoft')
         kernel.bootstrap(learnFiles=Config.get('path', 'data_aiml_peoplesoft'), commands="load aiml b")


    kernel.saveBrain("bot_brain.brn")
    info_logger.info("kernal loaded")
    print "kernal loaded"


    try:
        b=exceptionEnum()
        questionNotCorrectException= QuestionNotCorrectException(b.questionNotCorrectException)
        #msguserwensalutation=""
        indexerarraywensalutation=[]
        user_query = user_query.lower().strip()

        user_query99 = nltk.word_tokenize(user_query)
        print "nltk.pos_tag(user_query99)",nltk.pos_tag(user_query99)


        postagggd_usrqry=nltk.pos_tag(user_query99)

        print "postagggd_usrqry : ",postagggd_usrqry
        if len(user_query99)==1 and user_query not in salutations:
            #nouns = [word for word, pos in pos_tag(word_tokenize(s)) if pos.startswith('NN')]
            if [s for s in postagggd_usrqry if s[1] != 'NN']:
            #if postagggd_usrqry[1] == 'NN':
                print "not noun"
                return rephrase_msg,blankmsg,blankarray,s_flag

        #myaddedcodebelow
        print "USer queryyyy is:",user_query
        info_logger.info("USer queryyyy is: %s",user_query)
        # spell corection
        b = TextBlob(user_query)
        ques=b.correct()
        ques=str(ques)
        print "After correction : ",ques
        info_logger.info("After correction : %s",ques)

        match, score = salutation_refined.checkSalutation(ques,salutations)
        #print "score",score

        if score> 0.4551:

                s_flag=1
                print s_flag
                print"It is Salutation"
                info_logger.info("It is Salutation")
        index=salutation_laureate_file['Salutation']

        #calculating the index in salutations where match is found
        for i in range(0,100,1):
                if salutations[i]==match:
                    actual_index=i
                    break

        #fetching the required response from the salutation_Response column

        if score>0.4551:

            answer=salutation_response[actual_index]

            if pd.isnull(answer):
            # if math.isnan(answer):
                print"be specific"
                return rephrase_msg,msguserwensalutation,indexerarraywensalutation,s_flag
            print "Reply :",answer
            info_logger.info("Reply :%s",answer)
            return answer,msguserwensalutation,indexerarraywensalutation,s_flag
            #return make_response(jsonify({"s_flag": s_flag , "answer" : answer }),200)

        else:
            s_flag=0

            #use below autocorrection , if required.
            # c = TextBlob(user_query)
            # correctedquery=c.correct()
            # correctedquery=str(ques)
            # print "After correction  correctedquery : ",correctedquery
            user_query = sentence_correction(user_query)
            print "user_query after correction is in laureate.py:",user_query
            info_logger.info("user_query is : %s",user_query)
            len_target = len(user_query.split(' '))
            print "len_target",len_target

            #fetching the target question, message to be displayed to user and the alternative question set.
            target_question,msgfrusr,indexerarray = doc_similitude.main(user_query,selected_question_flag)  #,selected_question_flag=doc_similitude/

            print "target_question aahee : ",target_question
            print "msgfrusr 1",msgfrusr
            print "indexerarray aahee:",indexerarray
            info_logger.info("msgfrusr 1: %s",msgfrusr)
            print "len_target",len_target

            #getting top 4 matching qns in  altarray
            altarray=[]
            for i in indexerarray:
                print doc_similitude.data_list[i]
                altarray.append(doc_similitude.data_list[i])

            print "altarray aahe before sortnng: ",altarray
            #user_query=user_query.encode("ascii")
            cleaneduserquery=re.sub(r'\W+', ' ', user_query) #removing unwanted chars
            cleaneduserquery=cleaneduserquery.strip() #removing unwanted spaces
            cleaneduserquery=str(cleaneduserquery)
            print "cleaneduserquery :",cleaneduserquery


            if cleaneduserquery in altarray:
                target_question=user_query

            indexerarray=altarray
            #below swapping logoc
            if (cleaneduserquery in altarray) and (altarray[-1]!= cleaneduserquery):
                    tgtqnindx=altarray.index(cleaneduserquery)
                    #otherindx=-1
                    print "tgtqnindx",tgtqnindx
                    altarray[tgtqnindx]=altarray[-1]
                    altarray[-1]=cleaneduserquery.encode("ascii")
                    indexerarray=altarray

            print "altarray aahe after sortnng: ",indexerarray
            if  len_target >= 2:
                #rephrasing of query required
                info_logger.info("len_target >= 2:")
                if Config.get('message','is_rephrase') in target_question:
                    info_logger.info("'message','is_rephrase' : True")
                    return rephrase_msg,msgfrusr,indexerarray,s_flag

                #user query not specific
                elif Config.get('message','is_specific') in target_question:
                    info_logger.info("'message','is_specific' : True")
                    return onewordquery_msg,s_flag,blankarray,s_flag


                else:
                    #tried below logic fr <that> qns
                    # if target_question in thattaglist and selected_question_flag==0:
                    #     return rephrase_msg,msg_to_user_only_1_ans,indexerarray,s_flag

                    #fetching response here
                    response = kernel.respond(target_question)

                    final_response = response_on_click(response)
                    print "final_response ahheEEEEEE :",response

                    if not final_response:
                        return rephrase_msg,msgfrusr,indexerarray,s_flag

                    return final_response,msgfrusr,indexerarray,s_flag

            elif len_target < 2 and target_question in ['inter', 'intra']:
                #s_flag=0
                info_logger.info("['inter', 'intra']:")

                print "kernel.respond(target_question) aahe",kernel.respond(target_question)
                return kernel.respond(target_question),msgfrusr,indexerarray,s_flag

            #TO DO :
            else:
                blankstr=""
                #handling of 1word query message

                if Config.get('message','is_rephrase') in target_question:
                    if msgfrusr==msg_when_score_less_than_threshold:
                        return rephrase_msg,msg_when_score_less_than_threshold,indexerarray,s_flag

                    info_logger.info("'message','is_rephrase' : True")
                    print "final_response INDIA :"
                    return rephrase_msg,blankstr,indexerarray,s_flag

                #user query not specific
                elif Config.get('message','is_specific') in target_question:
                    if msgfrusr==msg_when_score_less_than_threshold:
                        return rephrase_msg,msg_when_score_less_than_threshold,indexerarray,s_flag

                    info_logger.info("'message','is_specific' : True")
                    return onewordquery_msg,s_flag,blankarray,s_flag

                else:

                    #fetching response here
                    response = kernel.respond(target_question)
                    final_response = response_on_click(response)
                    if not final_response:
                        return rephrase_msg,blankstr,indexerarray,s_flag

                    return final_response,blankstr,indexerarray,s_flag

    except QuestionNotCorrectException:
        questionNotCorrectException.errormessage
        error_logger.error(b.questionNotCorrectException,exc_info=True )


def response_on_click(query_response):

    question_mark = "?"
    question_words = ['what', 'which', 'How', 'can', 'is', 'are', 'do' ]

    mail_address = re.search(r'\w+(\.|_)?\w+@\w+\.?\w+',query_response)

    if question_mark in query_response :
        print "qn mrk vala before :",query_response # Which type of asset transfer you want to do? 1. Inter Asset 2. Intra Asset
        response_list = (re.sub(r'\d+\.+','--|',query_response)).split("--")
        print "qn mrk vala after :",response_list#['Which type of asset transfer you want to do? ', '| Inter Asset ', '| Intra Asset']
        filter_response = filter(lambda x : x.strip().startswith("|") ,response_list)
        filter_info = filter(lambda x : not x.strip().startswith("|") ,response_list)
        click_response = [response.replace("|","") for response in filter_response]
        print "filter_response",filter_response#['| Inter Asset ', '| Intra Asset']
        print "click_response",click_response#[' Inter Asset ', ' Intra Asset']
        response_dict = {'info': filter_info ,'button':click_response}
        return response_dict
    elif mail_address is not None:
        return {'info': query_response ,'mail_to': mail_address.group()}
    else:
        return query_response


if __name__ == "__main__":

    question = sys.argv[1]
    path = sys.argv[2]
    info_logger.info("starting Laureate")
    info_logger.info("User_query : " + question)
    answer = start(question, path)
    info_logger.info("response : " + str(answer))





