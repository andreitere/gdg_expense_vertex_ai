import logging
import random

from psycopg_pool import ConnectionPool
from psycopg.rows import dict_row
from expense_ai.utils.config import get_config

logger = logging.getLogger("db")


def log_notice(diag):
    print(f"PG says: {diag.severity} - {diag.message_primary}")


class Database:
    def __new__(cls, *args, **kwargs):
        if not hasattr(cls, 'instance'):
            logger.debug("DB Instance created")
            cls.instance = super(Database, cls).__new__(cls)
        return cls.instance

    def __init__(self):
        if not hasattr(self, 'initialized'):  # Check if the __init__ has been called before
            self.config = get_config()
            self.instance_id = random.randint(0, 10)
            self.db_pool = ConnectionPool(
                self.config.pg_uri,
                min_size=0,
                max_size=20
            )
            self.initialized = True  # Mark as initialized

    def find_one(self, *args):
        results = None
        with self.db_pool.connection() as con:
            results = con.execute(*args).fetchone()
        return results

    def find_many(self, *args):
        result = None
        with self.db_pool.connection() as con:
            con.row_factory = dict_row
            result = con.execute(*args).fetchall()
        logger.debug({"args": args, "result": result}, )
        return result

    def execute_fn(self, *args):
        logger.debug(args)
        result = None

        with self.db_pool.connection() as con:
            con.row_factory = dict_row
            con.add_notice_handler(log_notice)
            result = con.execute(*args).fetchone()
        return result
