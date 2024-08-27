from enum import Enum
from typing_extensions import TypedDict, Optional, Union

from pydantic import BaseModel


class UserRegisterRequest(BaseModel):
    email: str
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    bio: Optional[str] = None
    password: str
    confirm_password: Optional[str] = None
    profile_picture_url: Optional[str] = None
    invite_code: Optional[str] = None


class UserLoginRequest(BaseModel):
    platform: Union[str, None]
    username: str
    password: str


class TokenUser(BaseModel):
    user_id: int
    email: Optional[str] = None
    profile_picture_url: Optional[str] = None
