from starlette.middleware.base import BaseHTTPMiddleware
from fastapi import Request, Response
from fastapi.responses import JSONResponse

from expense_ai.utils.config import TCConfig, get_config


class APIKeyMiddleware(BaseHTTPMiddleware):
    def __init__(self, app, whitelisted_paths: set):
        super().__init__(app)
        config = get_config()
        self.api_key = config.api_key
        self.whitelisted_paths = whitelisted_paths

    async def dispatch(self, request: Request, call_next) -> Response:
        if not self.api_key:
            return await call_next(request)

        if request.url.path in self.whitelisted_paths:
            return await call_next(request)

        if (
            "X-API-KEY" in request.headers
            and request.headers["X-API-KEY"] == self.api_key
        ):
            return await call_next(request)

        return JSONResponse({"detail": "Invalid credentials"}, 401)
