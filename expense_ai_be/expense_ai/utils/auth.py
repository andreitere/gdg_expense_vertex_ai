from datetime import timedelta, datetime
from typing import Optional

from fastapi import Request, HTTPException, Depends
from fastapi.security import OAuth2PasswordBearer, HTTPBearer
from jose import jwt, JWTError

from expense_ai.models.users import TokenUser
from expense_ai.repositories.user import UserRepository
from expense_ai.utils.config import get_config

config = get_config()
users_repository = UserRepository()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/auth/connect")


def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=config.access_token_expire_minutes)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(data, config.secret_key, algorithm=config.algorithm)
    return encoded_jwt


def create_refresh_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(days=7)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, config.refresh_secret_key, algorithm=config.algorithm)
    return encoded_jwt


async def get_current_user(token: str = Depends(oauth2_scheme)) -> TokenUser:
    credentials_exception = HTTPException(
        status_code=401,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, config.secret_key, algorithms=[config.algorithm])
        email: str = payload.get("sub")
        if email is None:
            raise credentials_exception
    except JWTError as e:
        print(e)
        raise credentials_exception
    return TokenUser(**payload)
