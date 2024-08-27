import logging

from starlette.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
import expense_ai.routers as routers
from contextlib import asynccontextmanager
from expense_ai.middlewares.APIKeyMiddleware import APIKeyMiddleware
from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI, Request

app = FastAPI(
    title="TC Budget Split",
)

logger = logging.getLogger("server")


@app.exception_handler(Exception)
async def unicorn_exception_handler(request: Request, exc: Exception):
    logger.error(exc)
    return JSONResponse(
        status_code=500,
        content={"message": f"Oops! {exc} did something. There goes a rainbow..."},
    )


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)



app.add_middleware(APIKeyMiddleware, whitelisted_paths={"/docs", "/openapi.json"})

app.include_router(routers.expenses.expenses_router, prefix="/api")
app.include_router(routers.auth.auth_router, prefix="/api")
app.include_router(routers.groups.groups_router, prefix="/api")

app.mount("/", StaticFiles(directory="./web", html=True))

@app.get("/health")
def health_check():
    return {"ok": True}
