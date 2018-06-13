

# class ErrorIntentCapture(RuntimeError):
#     def __init__(self,errormsg):
#         self.msg=errormsg

class ErrorIntentCapture(Exception):
    def __init__(self,errormsg):
        self.msg=errormsg

class null_api_response_messageCapture(Exception):
    def __init__(self,errormsg):
        self.msg=errormsg

class POSTRequestError(Exception):
    def __init__(self,errormsg):
        self.message=errormsg

class DocumentSimilarityExceptionWrittenProj(Exception):
    def __init__(self,errormsg):
        self.message=errormsg
