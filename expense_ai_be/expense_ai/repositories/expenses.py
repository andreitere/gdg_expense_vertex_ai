import json
import logging
from typing import List

from expense_ai.connections.db import Database
from expense_ai.models.auth import ConnectUserResult
from expense_ai.models.groups import GroupConfig


class ExpensesRepository:
    def __init__(self):
        self.db = Database()
        self.logger = logging.getLogger("ExpensesRepository")

    def add_expense(self, group_id: int, user_id: int, total: float, title: str, items: List[dict], photo: str) -> ConnectUserResult:
        self.db.execute_fn("select public.add_expense(%s,%s,%s,%t,%s:jsonb,%t)", [group_id, user_id, total, title, items, photo])
        return True
