---
hideFooter: true
---
# Using Gemini Models through VertexAI?

###### via **rest** calls

<br/>

<v-click class="text-xs">
````md magic-move
```bash
curl \
  -H 'Content-Type: application/json' \
  -d '{
    "contents": [
      {
        "parts": [
          {
            "text": "Explain how AI works"
          }
        ]
      }
    ]
  }' \
  -X POST 'https://generativelanguage.googleapis.com/v1beta/' 
          \ 'models/gemini-1.5-flash-latest:generateContent?key=YOUR_API_KEY'
```
```python
url = """https://generativelanguage.googleapis.com/v1beta/models/
      gemini-1.5-flash-latest:generateContent?key=YOUR_API_KEY"""

payload = json.dumps({
  "contents": [
    {
      "parts": [
        {
          "text": "Explain how AI works"
        }
      ]
    }
  ]
})
headers = {
  'Content-Type': 'application/json'
}

response = requests.request("POST", url, headers=headers, data=payload)
```
````
</v-click>