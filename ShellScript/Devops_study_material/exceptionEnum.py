import enum
from enum import Enum

class exceptionEnum:



    intentexception="Sorry, unable to capture intent."
    fileexception="The file name is incorect!"
    postrequestUnsuccessfull="Unsuccessful POST response"
    nullapiresponsemessage="I do not recognize this branch. Perhaps it is not in my database or has been mis-spelled. Could you please re-type the branch name or you can also check on branch finder <a href='http://www.postoffice.co.uk/branch-finder' target='_blank'>http://www.postoffice.co.uk/branch-finder</a>"
    errorloadingdata="Exception raised..Problem loading data"
    incorrectTypeException="raising Exception !Type mentioned in your request is incorrect."
    unableToFetchBranchDetails="Exception!..Error in fetching branch details"
    unableToGetAnswersBranch="Exception !..Error in getting answers branch"
    invalidAPICallException="Invalid API call Exception"
    invalidLocationDetailsfound="Exception! Invalid Location Details Found"
    documentSimilarityNewError="Exception (in Document Similarity New) to calculate match,score!  "
    documentSimilarityError="Exception (in Document Similarity) to calculate match,score!  "
    questionNotCorrectException="Exception ! Question is incorrect!"
    fetchQuestionsException="Exception occurred while fetching question!"
    mostCommonWords="Exception occurred while fetching most common words in terms_count!"


#incorrectTypeException=exceptionEnum("raising Exception !Type mentioned in your request is incorrect.")
