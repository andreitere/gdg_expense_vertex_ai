import base64
import io
import json
from typing import TypedDict, List

import vertexai
from vertexai.generative_models import GenerativeModel, GenerationConfig, Part, HarmCategory, HarmBlockThreshold
from vertexai.vision_models import ImageGenerationModel

vertexai.init()

content_model = GenerativeModel("gemini-1.5-flash-001")
image_model = ImageGenerationModel.from_pretrained("imagen-3.0-generate-001")

available_group_categories = [
    "Friends",
    "Family",
    "Roommates",
    "Work Colleagues",
    "Travel",
    "Special Events",
    "Clubs & Organizations",
    "Sports Teams",
    "Community Projects",
    "Study Groups",
    "Partnerships",
    "Miscellaneous"
]


class GroupDetails(TypedDict):
    title: str
    category: str
    photo: str


generate_group_details_prompt = """The following is an expenses group description: '{description}'. 
            Slang might be used so try to figure it out. Extract a title, category and write a photo description. If persons are involved in the photo make it vague."""

extract_expense_items_prompt = """attached picture is a receipt. Has products, prices and quantitty. some items might be split into two lines (for example some items - juices - might have a 'PFAND' indicated above them. 
        Extract the items  as {title, quantity, price} and the total. Output should look like: {total, items: {title, quantity, price} ."""


def get_group_details_output_schema(categories: List[str] = available_group_categories):
    return {
        "type": "object",
        "properties": {
            "title": {
                "type": "string",
            },
            "category": {
                "type": "string",
                "enum": categories
            },
            "photo": {
                "type": "string",
            },
        },
        "required": ["title", "category", "photo"],
    }


def get_expense_items_output_schema():
    return {
        "type": "object",
        "properties": {
            "total": {
                "type": "number",
            },
            "items": {
                "type": "array",
                "items": {
                    "type": "object",
                    "required": ["price", "quantity", "title"],
                    "properties": {
                        "price": {
                            "type": "number",
                        },
                        "quantity": {
                            "type": "number",
                        },
                        "title": {
                            "type": "string",
                        }
                    }
                }
            },
        },
        "required": ["total", "items"],
    }


def generate_group_details(description: str, categories: List[str] = available_group_categories) -> GroupDetails:
    assert description.strip() != "", "Description cannot be empty"
    print(f"trying to genereate group from description '{description}'")
    response = content_model.generate_content(
        generate_group_details_prompt.format(description=description),
        generation_config=GenerationConfig(
            response_mime_type="application/json", response_schema=get_group_details_output_schema(categories)
        ),
        safety_settings={
            HarmCategory.HARM_CATEGORY_HATE_SPEECH: HarmBlockThreshold.BLOCK_LOW_AND_ABOVE,
            HarmCategory.HARM_CATEGORY_HARASSMENT: HarmBlockThreshold.BLOCK_LOW_AND_ABOVE,
        }
    )
    return json.loads(response.text)


def extract_expense_items(image_str: str) -> dict:
    assert image_str.strip() != "", "Image must be provided"
    image = Part.from_data(
        mime_type="image/png",
        data=base64.b64decode(image_str)
    )
    response = content_model.generate_content(
        [extract_expense_items_prompt, image],
        generation_config=GenerationConfig(
            response_mime_type="application/json", response_schema=get_expense_items_output_schema()
        ),
        safety_settings={
            HarmCategory.HARM_CATEGORY_HATE_SPEECH: HarmBlockThreshold.BLOCK_LOW_AND_ABOVE,
            HarmCategory.HARM_CATEGORY_HARASSMENT: HarmBlockThreshold.BLOCK_LOW_AND_ABOVE,
        }
    )
    return json.loads(response.text)


def generate_group_image(description: str) -> bytes:
    prompt = f"""a 200x200 cartoonized sketch  for an expenses group based on this description: '{description}"""
    images = image_model.generate_images(
        prompt=prompt,
        negative_prompt="people faces",
        # Optional parameters
        number_of_images=1,
        language="en",
        # You can't use a seed value and watermark at the same time.
        # add_watermark=False,
        # seed=100,
        aspect_ratio="1:1",
        safety_filter_level="block_some",
        person_generation="allow_adult",
    )
    print(images)
    return images.images[0]._image_bytes
