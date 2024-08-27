import logging

import yaml


def setup_logging():
    with open('./config/logging.yml', 'rt') as f:
        config = yaml.safe_load(f.read())
        # Configure the logging module with the config file
        logging.config.dictConfig(config)
        print("loaded logging config...")
