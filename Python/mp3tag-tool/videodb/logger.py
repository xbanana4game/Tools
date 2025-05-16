import configparser
import datetime
import logging
import os
import re
import sys

# CONFIGFILE_DEFAULT = os.getenv('CONFIG_DIR') + '\\debug.ini'
LOG_DIR = os.getenv('USERPROFILE') + os.sep + r'PycharmProjects\mp3tag-tool\log'
CONFIGFILE_DEFAULT = LOG_DIR + os.sep + 'logger.ini'

class WsLogger:
    pass


def _create_debug_ini(section, config_filename=CONFIGFILE_DEFAULT):
    fp = open(config_filename, 'a')
    config_logger = configparser.ConfigParser()
    config_logger.add_section(section)
    config_logger.set(section, 'FILE', section + '_{date}.log')
    config_logger.set(section, 'LEVEL', 'logging.INFO')
    config_logger.write(fp)
    fp.close()


def _read_debug_ini(section, config_filename=CONFIGFILE_DEFAULT):
    config_logger = dict()
    config_debug = configparser.ConfigParser()
    config_debug.read(config_filename, encoding='utf-8')
    if config_debug.has_section(section) is False:
        _create_debug_ini(section)
        config_debug.read(config_filename, encoding='utf-8')
    config_logger['file'] = config_debug.get(section, 'FILE')
    config_logger['level'] = eval(config_debug.get(section, 'LEVEL'))
    return config_logger


def set_logger(section: str, config_file=CONFIGFILE_DEFAULT):
    today = datetime.datetime.now().strftime("%Y%m%d")
    config_logger = _read_debug_ini(section, config_file)
    log_name = config_logger['file'].format(date=today)
    # log_name = log_name.format(date=today)
    log_directory = LOG_DIR
    os.makedirs(log_directory, exist_ok=True)
    FORMAT = '%(levelname)-9s  %(asctime)s  [%(name)s]  %(funcName)s()  %(message)s'
    if re.match('sys\.std.*', log_name):
        logging.basicConfig(stream=eval(log_name), format=FORMAT, level=config_logger['level'])
    else:
        logging.basicConfig(filename=log_directory + os.sep + log_name, format=FORMAT, level=config_logger['level'])


def _print_log_test():
    logger.debug('debug')
    logger.info('info')
    logger.warning('warning')
    logger.error('error')


if __name__ == '__main__':
    logger = logging.getLogger(__name__)
    filename = re.sub(r'\..*', '', os.path.split(__file__)[1])
    print(filename)
    set_logger(filename)
    _print_log_test()
