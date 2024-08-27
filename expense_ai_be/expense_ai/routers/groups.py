import logging
from fastapi import APIRouter, Depends
from starlette.responses import JSONResponse

from expense_ai.connections.ai_v2 import generate_group_details, generate_group_image
from expense_ai.connections.zipline import upload_image
from expense_ai.models.groups import GroupConfig
from expense_ai.models.users import TokenUser
from expense_ai.repositories.group import GroupRepository
from expense_ai.utils.auth import get_current_user

groups_router = APIRouter(prefix="/groups", tags=["groups"])

logger = logging.getLogger(__name__)

groups_repository = GroupRepository()


@groups_router.post("/")
async def create_or_update_group(group: GroupConfig, user: TokenUser = Depends(get_current_user)):
    if group.description.strip() == "":
        raise ValueError("Invalid description")

    group.owner_id = user.user_id

    group_id = None

    try:
        if group.group_id is not None:
            # create
            group_id = groups_repository.create_or_update(group)
        else:
            details = generate_group_details(description=group.description)
            group.title = details["title"]
            group.category = details["category"]
            group.photo_desc = details["photo"]
            image_url = upload_image(generate_group_image(group.description)).replace("http:", "https:")
            group.photo = image_url
            group_id = groups_repository.create_or_update(group)
    except Exception as e:
        print(e)
    finally:
        return JSONResponse(content={"group_id": group_id})


@groups_router.get("/")
async def get_user_groups(user: TokenUser = Depends(get_current_user)):
    return groups_repository.get_user_groups(user.user_id)


@groups_router.get("/{group_id}")
async def get_user_groups(group_id: int, user: TokenUser = Depends(get_current_user)):
    return groups_repository.get_user_group(group_id, user.user_id)
