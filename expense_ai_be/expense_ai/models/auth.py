from typing import Optional

from pydantic import BaseModel


class LoginRequest(BaseModel):
    username: str
    password: str


class ConnectUserResult(BaseModel):
    exists: bool
    created: Optional[bool] = None
    success: bool
    user_id: Optional[int] = None
