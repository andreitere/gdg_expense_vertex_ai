---
hideFooter: true
---

# Simplified forms (I) - image

```python
image_prompt = """a 200x200 cartoonized sketch  for 
                  an expenses group based on this description: '{description}'"""
```

```python
image_model.generate_images(
    prompt=image_prompt.format(description=generated_photo_desc),
    negative_prompt="people faces",
    number_of_images=1,
    language="en",
    aspect_ratio="1:1",
    safety_filter_level="block_some",
    person_generation="allow_adult",
)
```