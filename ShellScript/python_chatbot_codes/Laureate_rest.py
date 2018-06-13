#!flask/bin/python
# encoding=utf8

import sys

reload(sys)
sys.setdefaultencoding('utf8')

import codecs
import werkzeug
from flask import Flask, jsonify, Response
import os
from flask import request
import string
import doc_similitude
from Laureate import start
from log import *
import ConfigParser
from most_common_words import *
import applicationExceptionHandlingFramework
from applicationExceptionHandlingFramework import *
import businessexceptionHandlingFramework
from businessexceptionHandlingFramework import *
selected_question_flag =None
app = Flask(__name__)

Config = ConfigParser.ConfigParser()
present_working_dir =  os.getcwd()
Config.read(os.path.join(present_working_dir,"property.ini"))
rephrase_msg = Config.get("message","rephrase_msg")
msg_to_user_only_1_ans=Config.get('message_to_user','msg_to_user_only_1_ans')
msg_to_user_when_button=Config.get('message_to_user','msg_to_user_when_button')

@app.route('/bot', methods=['POST'])
def create_task():

    path_filter = request.json['filter']
    #below logic to compare incoming qns with cleand 1
    def compare(s1, s2):
        s1=s1.lower()
        s2=s2.lower()
        remove = string.punctuation + string.whitespace
        return s1.translate(None, remove) == s2.translate(None, remove)
        #return sun.translate(remove) == moon.translate(remove)

    alternateqnarray=[]

    s_flag=0
    question = request.json['query']
    sun=question
    selected_question_flag = request.json['selected_question']
    path = present_working_dir
    info_logger.info("USER_QUERY : " + question)

    response,msgfrusr,indexerarray,s_flag = start(question , path,selected_question_flag,path_filter ) # selected_question_flag=start() id reqd.
    print "response iss : ",response
    #responselist=list(response)
    #print "responselist is",responselist
    print "INDEXERARRAY IS :",indexerarray

    #chk if ! salutation, more than 1 qns being returnd, and not sorry msg.
    if s_flag==0 and selected_question_flag==0 and response!=rephrase_msg:
        moon=indexerarray[-1]
        print "sun:",sun
        print "moon:",moon
        #compare_flag=compare(sun.decode('utf-8'),moon.decode('utf-8'))
        compare_flag=compare(sun.encode('utf-8'),moon.encode('utf-8'))
        if compare_flag== True:
            indexerarray[-1]=sun



    info_logger.info("printing INDEXERARRAY  : %s",indexerarray)
    print "MESSAGE FOR USER IS :",msgfrusr
    info_logger.info("MESSAGE FOR USER IS : %s",msgfrusr)
    print "RESPONSE IS :",response
    info_logger.info("RESPONSE IS : %s",response)
    print "RELATED QN SET : ",indexerarray
    info_logger.info("RELATED QN SET : %s",indexerarray)
    print "SELECTED_QUESTION_FLAG IS : ",s_flag
    info_logger.info("SELECTED_QUESTION_FLAG IS : %s",s_flag)
    print "S_FLAG FROM rest.py : ",s_flag
    info_logger.info("S_FLAG FROM rest.py : %s",s_flag)
    info_logger.info("RESPONSE : " + str(response))
    #print response

    if response and s_flag==1:
        return (jsonify({"s_flag": s_flag , "answer" : response}))

    if response and s_flag==0:
        if isinstance(response, dict):
            print "YES DICT"
            # msgfrusr=msg_to_user_when_button
            return jsonify({"message_to_user":msgfrusr,"answer": response,"alt_qns_set":indexerarray}) # chk if to add "s_flag": s_flag

        else:
            print "NOT DICT"
            print {"message_to_user":msgfrusr,'info':response,"alt_qns_set":indexerarray}
            return jsonify({"message_to_user":msgfrusr,'info':response,"alt_qns_set":indexerarray}) #chk if to add "s_flag": s_flag and 'selected_question':selected_question_flag

    else:
        error_logger.error(Config.get('message','bad_server'),exc_info=True )
        return jsonify({'info':Config.get('message','bad_server')})

@app.route('/common-terms', methods=['POST'])
def common_terms():
    start_date = request.json['startDate']
    end_date = request.json['endDate']
    flag = 5
    common_word_dict = get_terms(start_date,end_date, flag)
    return jsonify(common_word_dict)

@app.errorhandler(werkzeug.exceptions.BadRequest)
def handle_bad_request(e):
    error_logger.error(Config.get('message','bad_server'),exc_info=True )
    return 'bad request!'

if __name__ == '__main__':
    app.run(host= Config.get('address','host'), port= int(Config.get('address','port')), threaded=True)
    app.register_error_handler(400, lambda e: 'bad request!')



