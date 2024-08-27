import base64
import json
import os
from typing import TypedDict, List

import google.generativeai as genai
import typing_extensions as typing
from google.ai.generativelanguage_v1 import SafetySetting, HarmCategory, Part
from google.generativeai import GenerationConfig
from google.generativeai.types import HarmBlockThreshold


class Recipe(typing.TypedDict):
    recipe_name: str


genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

model = genai.GenerativeModel('gemini-1.5-flash',
                              # Set the `response_mime_type` to output JSON
                              # Pass the schema object to the `response_schema` field
                              generation_config={"response_mime_type": "application/json",
                                                 "response_schema": list[Recipe]})

prompt = "List 5 popular cookie recipes"

response = model.generate_content(prompt)
print(response.text)

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
            Extract a title, category and write a photo description. If persons are involved in the photo make it vague."""

extract_expense_items_prompt = """attached picture is a receipt. Has products, prices and quantitty. Optionally a date and name of the market shop. 
        Extract the items  as {title, quantity, price} and the total. Output should look like: {total, items: {title, quantity, price} .
        If a date is present add it to the output {date}. Try to also generate a title for this expense {title}"""


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
            "title": {
                "type": "string"
            },
            "date": {
                "type": "string"
            },
            "total": {
                "type": "number",
            },
            "items": {
                "type": "array",
                "items": {
                    "type": "object",
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
        "required": ["total", "items", "title"],
    }


def generate_group_details(description: str, categories: List[str] = available_group_categories) -> GroupDetails:
    assert description.strip() != "", "Description cannot be empty"
    print(f"trying to genereate group from description '{description}'")

    _resp = model.generate_content(
        generate_group_details_prompt.format(description=description),
        generation_config=GenerationConfig(
            response_mime_type="application/json", response_schema=get_group_details_output_schema(categories)
        ),
        safety_settings={
            HarmCategory.HARM_CATEGORY_HATE_SPEECH: HarmBlockThreshold.BLOCK_LOW_AND_ABOVE,
            HarmCategory.HARM_CATEGORY_HARASSMENT: HarmBlockThreshold.BLOCK_LOW_AND_ABOVE,
        }
    )
    return json.loads(_resp.text)


def extract_expense_items(image_str: str) -> dict:
    assert image_str.strip() != "", "Image must be provided"
    image = Part.from_data(
        mime_type="image/png",
        data=base64.b64decode(image_str)
    )

    _resp = model.generate_content(
        [extract_expense_items_prompt, image],
        generation_config=GenerationConfig(
            response_mime_type="application/json", response_schema=get_expense_items_output_schema()
        ),
        safety_settings={
            HarmCategory.HARM_CATEGORY_HATE_SPEECH: HarmBlockThreshold.BLOCK_LOW_AND_ABOVE,
            HarmCategory.HARM_CATEGORY_HARASSMENT: HarmBlockThreshold.BLOCK_LOW_AND_ABOVE,
        }
    )
    return json.loads(_resp.text)
