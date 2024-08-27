import json
import logging
from typing import List

from expense_ai.connections.db import Database
from expense_ai.models.groups import GroupConfig


class GroupRepository:
    def __init__(self):
        self.db = Database()
        self.logger = logging.getLogger("GroupRepository")

    def create_or_update(self, group_config: GroupConfig) -> int:
        params = [json.dumps(group_config.model_dump())]
        result = self.db.execute_fn("select public.create_or_update_group(%s::json)", params)
        return result.get("create_or_update_group")

    def get_user_groups(self, owner_id: int):
        results = self.db.find_many("select group_id, title, category, photo, description from public.groups where owner_id = %s order by created_at desc", [owner_id])
        return results

    def get_user_group(self, group_id: int, owner_id: int):
        result = self.db.find_one("select group_id, title, category, photo, description from public.groups where owner_id = %s and group_id = %s order by created_at desc", [owner_id, group_id])
        return result
