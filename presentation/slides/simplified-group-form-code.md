---
hideFooter: true
---

# Simplified forms (I) - group details

```python
group_details_prompt = """The following is an expenses group description: '{description}'. 
            Extract a title, category and write a photo description."""
```

````md magic-move
```python
content_model.generate_content(
    group_details_prompt.format(description=description_from_form),
    generation_config=GenerationConfig()
)
```
```python
content_model.generate_content(
    group_details_prompt.format(description=description_from_form),
    generation_config=GenerationConfig(
        response_schema={
            "type": "object",
            "properties": {
                "title": {
                    "type": "string",
                },
                "category": {
                    "type": "string",
                },
                "photo": {
                    "type": "string",
                },
            },
            "required": ["title", "category", "photo"]
        }
    )
)
```
````