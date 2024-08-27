import logging
import os
from functools import lru_cache
from typing import Optional

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict

logger = logging.getLogger("config")


class TCConfig(BaseSettings):
    api_key: Optional[str] = Field(description="api key", default=None)
    pg_uri: Optional[str] = Field(description="Postgre connection uri")

    secret_key: str = Field(description="secret key used for generating access_token")
    refresh_secret_key: str = Field(description="secret key used for generating refresh_token")
    algorithm: str = Field(description="algorithm used to generate the keys", default="HS256")
    access_token_expire_minutes: int = Field(description="Acces token validity duration")
    refresh_token_expire_minutes: int = Field(description="Refresh token validity duration")
    zipline_token: str = Field(description="zipline auth token")
    zipline_folder: str = Field(description="zipline folder id")

    model_config = SettingsConfigDict(env_file=".env", extra='ignore')

@lru_cache
def get_config() -> TCConfig:
    return TCConfig()
