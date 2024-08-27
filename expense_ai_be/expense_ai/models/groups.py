from typing import Union, Optional

from pydantic import BaseModel
from typing_extensions import List


class GroupConfig(BaseModel):
    group_id: Optional[int] = None
    title: Optional[str] = None
    description: Optional[str] = None
    category: Optional[str] = None
    photo: Optional[str] = None
    photo_desc: Optional[str] = None
    owner_id: Optional[int] = None
