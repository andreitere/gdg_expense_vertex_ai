---
hideFooter: true
---
# Let's bring some magic in


```python
THE_prompt =  """attached picture is a receipt. Has products, prices and quantitty. 
    Some items might be split into two lines - for example some items (beverages) might have
    'PFAND' indicated above/below them. Extract the items  as {title, quantity, price} and the total.  Output should look like: {total, items: {title, quantity, price} ."""
```

<div class="text-xs" v-click>

```
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
}
```

</div>