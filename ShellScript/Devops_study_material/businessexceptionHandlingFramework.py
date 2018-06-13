#class ServiceException(Exception):



class POSTRequestError(Exception):
    def __init__(self,errormessage):
        self.errormessage=errormessage

class IncorrectTypeException(Exception):
    def __init__(self,errormessage):
        self.errormessage=errormessage



class ErrorLoadingDataException(Exception):
    def __init__(self,errormessage):
        self.errormessage=errormessage

class UnableToFetchBranchDetails(Exception):
    def __init__(self,errormessage):
        self.errormessage=errormessage

class UnableToGetAnswersBranch(Exception):
    def __init__(self,errormessage):
        self.errormessage=errormessage

class classInvalidAPICallException(Exception):
    def __init__(self,errormessage):
        self.errormessage=errormessage

class InvalidLocationDetails(Exception):
    def __init__(self,errormessage):
        self.errormessage=errormessage


class DocumentSimilarityException(Exception):
    def __init__(self,errormessage):
        self.errormessage=errormessage

class QuestionNotCorrectException(Exception):
    def __init__(self,errormessage):
        self.errormessage=errormessage

class FetchQuestionsException(Exception):
    def __init__(self,errormessage):
        self.errormessage=errormessage

class MostCommonWordsException(Exception):
    def __init__(self,errormessage):
        self.errormessage=errormessage
