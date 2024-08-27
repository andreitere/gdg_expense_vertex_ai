import json
import logging
from typing import List

from expense_ai.connections.db import Database
from expense_ai.models.auth import ConnectUserResult
from expense_ai.models.groups import GroupConfig


class AuthRepository:
    def __init__(self):
        self.db = Database()
        self.logger = logging.getLogger("UserSessionsRepository")

    def connect_user(self, email: str, password: str) -> ConnectUserResult:
        result = self.db.execute_fn("select public.connect_user(%s,%t)", [email, password])
        return ConnectUserResult(**result.get("connect_user"))
