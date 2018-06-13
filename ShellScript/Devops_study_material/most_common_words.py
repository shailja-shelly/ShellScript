import collections
from collections import defaultdict,Counter
from nltk import word_tokenize
from nltk.corpus import stopwords
from pymongo import MongoClient
from operator import itemgetter
from datetime import datetime
import re
import os
# from logging_check import *
import businessexceptionHandlingFramework
from businessexceptionHandlingFramework import *
import applicationExceptionHandlingFramework
from applicationExceptionHandlingFramework import *
import exceptionEnum
from exceptionEnum import *

import ConfigParser

from log import error_logger

Config = ConfigParser.ConfigParser()
present_working_dir = os.getcwd()
Config.read(os.path.join(present_working_dir,"property.ini"))

b=exceptionEnum()
#classIncorrectType=IncorrectTypeException(b.incorrectTypeException)
fetchQuestionsException=FetchQuestionsException(b.fetchQuestionsException)
mostCommonWords=MostCommonWordsException(b.mostCommonWords)

def fetch_questions(start_date, end_date):
    question_list = []
    # client = MongoClient('172.31.24.242', 27017)
    mongo_IP = Config.get('db_details','mongo_IP')
    mongo_PORT = Config.get('db_details','mongo_PORT')
    client = MongoClient(mongo_IP, int(mongo_PORT))
    # db = client.ukpostDB
    db = client.laureteDB
    collection = db.chatbotlogs
    # question = [collection.find({"date": {"$gte":"2018-01-12T18:30:00.000Z", "$lte":"2018-01-19T18:30:00.000Z"}})['question']]
    try:
        start_date =  start_date.split('-')
        end_date = end_date.split('-')
        sDate = datetime(int(start_date[0]), int(start_date[1]), int(start_date[2]),0,0,0)
        eDate = datetime(int(end_date[0]), int(end_date[1]), int(end_date[2]),0,0,0)
        for field in collection.find({"date": {"$gte": sDate, "$lt": eDate}}):
            question = field['question'].strip()
            question = re.sub("\"+|\?+","",question)
            question = re.sub("  {2,10}"," ",question)
            question_list.append(question)
            # count += 1
            # collection.update({"name":terms}, {"$set" : {"count" : count}})
            # return count,terms
            # return count
    except FetchQuestionsException:
        error_logger.error(b.fetchQuestionsException,exc_info=True)
        print fetchQuestionsException.errormessage
        #print dir(e)
        #error_logger.error(e)

    # print question_list
    return question_list


def most_common_words(question_list,flag):
    count = 0
    commonwords = ["I","want","know","branch","branches","details","detail","near","nearest","please","tell","give","me",
                   "locate","information","about","location","postoffice","find","show","can","could","post","office","see",
                   "need","direction","directions","postal","located","list","help","nearby","reach","pincode","weekends","open",
                   "route","operational","hours","timings","mobile","service",
                   "the", "a", "an", "is", "are", "were", "hi", "hey", "hello", "bye", "."," ","  ","<strong>"]
    # question_list = fetch_questions()
    '''question_list = ['I need an Accounts Payable role to Create Voucher', 'Where I can create Voucher in PeopleSoft',
                     'Where I can create Expense Report in PeopleSoft',
                     'I want to create a ticket for PeopleSoft Support team',
                     'My Pay cycle is stuck in between, I am unable to proceed',
                     'I want to know the status of my ticket raised with Support team',
                     'Where I can check the status of Vendor',
                     'I want to reset PeopleSoft password',
                     'I am a new Employee, I want to create Expense / Reimbursement in Peoplesoft, how do I do that',
                     'What is frequency of LIAP02 or Voucher Build process']'''

    final_word_list = []
    termdict = {}
    questiondict = {}
    final_termdict = {}
    termvalue_list = []
    for question in question_list:
        question = question.lower()
        question = ''.join([i if ord(i) < 128 else ' ' for i in question])
        # print question
        filtered_words = [word.strip() for word in question.split(" ") if word not in stopwords.words('english') and word not in commonwords]
        # final_word_list.append(' '.join(filtered_words))
        # final_word_list = [word for word in question.split(" ") if word not in stopwords.words('english')]
        for word in filtered_words:
            final_word_list.append(word)
    # print final_word_list
    # print dict(Counter('abracadabra').most_common(3))
    termdict = dict(Counter(final_word_list))
    print termdict
    # termdict = dict(Counter(final_word_list).most_common(5))
    sum_val = sum(termdict.values())
    for (key,val) in Counter(final_word_list).most_common(flag):
    # for key,val in termdict.items():
        percentage = round((((float)(val)/sum_val) * 100),1)
        termvalue_list.append({'term':key,'percent':percentage})
        count += 1
        '''if count == flag:
            break'''
    return termvalue_list


def get_terms(start_date,end_date,flag):
    # flag = 4
    # start_date = "2018-01-12T18:30:00.000Z"
    # end_date = "2018-01-19T18:30:00.000Z"
    try:
        question_list = fetch_questions(start_date, end_date)
    # except Exception as e:
    #     print dir(e)
    # error_logger.error(e)
    except FetchQuestionsException:
        error_logger.error(b.fetchQuestionsException,exc_info=True)
        print fetchQuestionsException.errormessage



    try:
        terms_count = most_common_words(question_list,flag)

    except MostCommonWordsException:
        error_logger.error(b.mostCommonWords,exc_info=True)
        print mostCommonWords.errormessage
    # except Exception as e:
    #     print dir(e)
        # error_logger.error(e)
    return terms_count

if __name__ == "__main__":
    start_date = '2018-02-26'
    end_date = '2018-03-28'
    flag = 5
    print get_terms(start_date, end_date, flag)
    
