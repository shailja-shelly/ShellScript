
import logging
formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s')


def setup_logger(name, log_file, level):

    handler = logging.FileHandler(log_file)
    handler.setFormatter(formatter)
    logger = logging.getLogger(name)
    logger.setLevel(level)
    logger.addHandler(handler)

    return logger

info_logger = setup_logger('Laureate_info', 'info_logfile.log',logging.INFO)
error_logger = setup_logger('Laureate_error', 'error_logfile.log', logging.ERROR)


