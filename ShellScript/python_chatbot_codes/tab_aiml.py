import sys
import os
import csv
import re
import string
from collections import OrderedDict
import ConfigParser
# from log import *


try:
    Config = ConfigParser.ConfigParser()
    present_working_dir =  os.getcwd()
    if not os.path.exists(os.path.join(present_working_dir,"property.ini")):
        print "No such file : {}".format('property.ini')
    Config.read(os.path.join(present_working_dir,"property.ini"))
except (ConfigParser.NoOptionError, ConfigParser.NoSectionError ) as e:
    print "error :", e
    # error_logger.error(e)

def ans_trans(ip_text):
    ip_text=ip_text.strip('\'"')
    ip_text=ip_text.strip('\'')
    ip_text=ip_text.replace('\"','')
    ip_text=ip_text.replace('&','and')
    # ip_text=ip_text.replace('-', 'or')
    print "ip_text ans :",ip_text
    #ip_text=ip_text.translate(None,string.punctuation)
    #punctuation_replacer = string.maketrans(string.punctuation, ' ' * len(string.punctuation))
    #return ' '.join(ip_text.translate(punctuation_replacer).split()).strip()
    return ip_text

def row_trans(input_text):

    input_text=input_text.strip('"').replace('\"','')
    #print "input_text",input_text
    #mylist = line.strip('\n').replace('\"','')
    if '&' in input_text:
        input_text = input_text.replace('&', 'and')
    elif '-' in input_text:
        input_text = input_text.replace('-', 'or')
    # elif '  "' in input_text:
    #     input_text=input_text.replace('"','')
    # elif '."' in input_text:
    #     input_text=input_text.replace('"','')
    else:
        input_text = input_text
    punctuation_replacer = string.maketrans(string.punctuation, ' ' * len(string.punctuation)) #punctuations replaced by space?
    return ' '.join(input_text.translate(punctuation_replacer).split()).strip()


def file_reader(unique_record_dict , dir_path):
    # dir_path = ''
    # present_working_dir = os.getcwd()
    # for f in os.listdir(present_working_dir):
    #     file_path = os.path.join(present_working_dir, f)
    #     if os.path.isdir(file_path):
    #         dir_path = file_path

    # print dir_path
    os.chdir(dir_path) #chnge currnt wrkng dirctry to dir_path
    tabFiles = [f for f in os.listdir(dir_path) if f.endswith('.txt') or f.endswith('.TXT')]
    # print "tabFiles :",tabFiles
    for tabFile in tabFiles:
        #below : delimiter indicates 1 char string used to separate fields.
        #original : csvData = csv.reader(open(tabFile),delimiter="\t", quotechar="'")
        csvData = csv.reader(open(tabFile,'rU'),delimiter="\t", quotechar="'")
        #csvData = csv.reader(open(tabFile), dialect=csv.excel_tab, quotechar="'")

        csvMalformed = csv.writer(open(Config.get('path','malformed_file'), 'w'), delimiter="\t", quotechar="'")

        for row in csvData:
            if row and len(row) == 2: #if row in qn ans format
                clean_row = row_trans(row[0]) #replace &, - by and , or in qn.
                #clean_ans=ans_trans(row[1])
                unique_record_dict[clean_row] = ans_trans(row[1].strip()) #add the cleaned qn, its strpiied ans in unique_record_dict
            else:
                csvMalformed.writerow([row])
    print "unique_record_dict : ",unique_record_dict
    return unique_record_dict , tabFiles


def data_file(unique_data): #writes questions to Doc file?
    present_working_dir = os.getcwd()
    data_file = os.path.join(present_working_dir, Config.get('path','data_txt'))
    question_file = os.path.join(present_working_dir, Config.get('path','doc_file'))
    # question_file = os.path.join(present_working_dir, Config.get('path','ques_file'))
    csvWriter = csv.writer(open(data_file, 'w'), delimiter="\t") #removed quotechar to write as original in data.txt.
    #original : csvWriter = csv.writer(open(data_file, 'w'), delimiter="\t", quotechar="'")
    questionData = open(question_file, 'w')

    for ques, ans in unique_data.items():
        ques = ques.strip()
        ans = ans.strip()
        csvWriter.writerow([ques, ans]) #write to data.txt
        questionData.write(ques + "\n") # write to Documents file

    questionData.close()

    #remove the latest txt file


def tab_csv_converter(path): # ACTUAL WRITING INTO DATA.AIML FILE
    os.chdir(path)

    data_file_path = os.path.join(os.getcwd(), Config.get('path','data_txt'))
    data_file = Config.get('path','data_txt')

    aimlFile = data_file[:-4] + '.aiml' #aimlFile will contain 'data.aiml'
    #print "itheeeeee aimlFile : ",aimlFile #

    csvData = csv.reader(open(data_file_path), delimiter="\t", quotechar="'")
    aimlData = open(aimlFile, 'w')

    aimlData.write('<aiml version = "1.0.1" encoding = "UTF-8">' + "\n")
    # there must be only one top-level tag
    aimlData.write('<!-- ' + aimlFile + ' -->' + "\n")
    aimlData.write("\n")

    rowNum = 0
    for row in csvData:
        # print "row :",row
        if row:
            if rowNum == 0:
                tags = row
                for i in range(len(tags)):
                    tags[i] = tags[i].replace(' ', '_')
                    # print tags
            else:
                aimlData.write('    ' + '<category>' + "\n")

                for i in range(len(tags)):
                    if tags[i] == "pattern":
                        aimlData.write('        ' + '<' + tags[i] + '>'
                                       + row[i].upper() + '</' + tags[i] + '>' + "\n")
                    elif tags[i] == "template":
                        aimlData.write('        ' + '<' + tags[i] + '>' + "\n" + '        '
                                        +row[i]+"\n"+'        ' +'</' + tags[i] + '>' + "\n")
                                        # + re.sub('\|', '\n\t\t\t\t', row[i]) + "\n"
                                       # '        ' + '</' + tags[i] + '>' + "\n")

                aimlData.write('    ' + '</category>' + "\n")
                aimlData.write("\n")

            rowNum += 1
        else:
            continue

    aimlData.write('</aiml>' + "\n")
    aimlData.close()


def remove_files(dir_path,txt_files):

    try:
        for txt_file in txt_files:
            txt_file_path = os.path.join(dir_path,txt_file)
            if not 'data' in txt_file:
                print "Removing {} file from data directory".format(txt_file)
                os.remove(txt_file_path)
            else:
                continue
    except TypeError as e:
        print e



if __name__ == "__main__":

    dir_path = os.getcwd()
    parent_dir =  os.path.dirname(dir_path)
    # data_folder="C:\\ANIRBAN LAUREATE GIT CHECKOUT 29TH APRIL 2018\\LAUREATE_CHATBOT\\CHATBOT_LAUREATE\\py"
    # data_folder =  os.path.join(parent_dir, 'C:\\Users\\aditya.h.haralikar\\Desktop\\LAUREATE APRIL 24 2018 CREATED\\CHATBOT_LAUREATE\\py')
    # print data_folder
    data_folder = os.getcwd() #data_folder contains wrkng dirctry
    unique_record_dict = OrderedDict() #ordered dictionary
    unique_data, txt_files = file_reader(unique_record_dict, data_folder) #after method  call , 'unique_data' will contain cleaned qns and their answers.'txt_files' will contain the txt files.
    data_file(unique_data) # writes qns ans to data.txt and qns to Documents file
    tab_csv_converter(data_folder) #ACTUAL WRITING TO DATA.AIML FILE
    remove_files(data_folder ,txt_files)

