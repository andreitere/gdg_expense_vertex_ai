import os
from io import BytesIO

import requests

from expense_ai.utils.config import get_config

config = get_config()


def upload_image(image_bytes: bytes) -> str:
    url = 'https://cdn.swninja.win/api/upload'
    headers = {
        'Authorization': config.zipline_token,
        'x-zipline-folder': config.zipline_folder
    }

    files = {
        'file': ('random.png', BytesIO(image_bytes), 'image/png')
    }
    response = requests.post(url, headers=headers, files=files)
    _r = response.json()
    return _r.get("files")[0]
