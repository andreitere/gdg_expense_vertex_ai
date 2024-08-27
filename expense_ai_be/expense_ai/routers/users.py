import json
import logging
from typing import List

import psycopg
from fastapi import APIRouter, Body, HTTPException, Depends, Request

from expense_ai.models.users import TokenUser
from expense_ai.repositories.user import UserRepository
from expense_ai.utils.auth import get_current_user

users_router = APIRouter(prefix="/users", tags=["users"])

logger = logging.getLogger(__name__)

user_repository = UserRepository()


@users_router.get("/invite/{invite_code}")
async def get_invite_details(invite_code: str):
    try:
        return user_repository.get_invite_details(invite_code)
    except psycopg.Error as e:
        raise HTTPException(500, e.diag.message_detail)


@users_router.post("/confirm/{invite_code}")
async def confirm_account(invite_code: str):
    try:
        return user_repository.confirm_account(invite_code)
    except psycopg.Error as e:
        raise HTTPException(500, e.diag.message_detail)


@users_router.post("/connect")
async def connect_with_user(email: str = Body(embed=True), user: TokenUser = Depends(get_current_user)):
    try:
        return user_repository.connect_with_user(email, None, user.user_id)
    except psycopg.Error as e:
        logger.error(e)
        raise HTTPException(500, e.diag.message_detail)


@users_router.get("/connections")
async def get_user_connections(user: TokenUser = Depends(get_current_user)):
    try:
        return user_repository.get_user_connections(user.user_id)
    except psycopg.Error as e:
        raise HTTPException(500, e.diag.message_detail)


@users_router.get("/invites")
async def get_user_invites(user: TokenUser = Depends(get_current_user)):
    try:
        return user_repository.get_user_invites(user.user_id)
    except psycopg.Error as e:
        print(e)
        raise HTTPException(500, e.diag.message_detail)
