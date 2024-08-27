import json

from psycopg.generators import fetch_many

from expense_ai.connections.db import Database
from expense_ai.models.users import UserRegisterRequest, TokenUser


class UserRepository:
    def __init__(self):
        self.db = Database()

    def get_user(self, user_id) -> TokenUser:
        result = self.db.execute_fn("select public.get_user(%s)", [user_id])
        return TokenUser(**result.get("get_user"))
