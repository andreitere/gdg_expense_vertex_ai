import logging
from datetime import timedelta

from fastapi.security import OAuth2PasswordRequestForm
from fastapi.responses import JSONResponse
from jose import JWTError, jwt
from fastapi import APIRouter, HTTPException, Depends, Body
from starlette import status

from expense_ai.models.auth import LoginRequest
from expense_ai.repositories.auth import AuthRepository
from expense_ai.repositories.group import GroupRepository
from expense_ai.repositories.user import UserRepository
from expense_ai.utils.auth import create_access_token, create_refresh_token, get_current_user
from expense_ai.utils.config import get_config

auth_router = APIRouter(prefix="/auth", tags=["auth"])

logger = logging.getLogger(__name__)
config = get_config()
auth_repository = AuthRepository()
groups_repository = GroupRepository()
users_repository = UserRepository()


@auth_router.post("/connect")
async def connect(form_data: LoginRequest):
    _connect = auth_repository.connect_user(form_data.username, form_data.password)
    if not _connect or not _connect.success:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    user = users_repository.get_user(_connect.user_id)
    access_token_expires = timedelta(minutes=config.access_token_expire_minutes)
    print(user.model_dump())
    access_token = create_access_token(
        data={"sub": user.email, **user.model_dump()}, expires_delta=access_token_expires
    )
    _r = {
        "access_token": access_token,
        "user": user.model_dump()
    }

    return _r
