---
showFooter: true
---

# Using Gemini Models through VertexAI?


###### via **SDK**s

<br/>
<div v-click v-motion
  :initial="{ y: 80 }"
  :enter="{ y: 0 }"
  :leave="{ y: -80 }" class="flex space-x-6">

<div w="1/3" text="xs" content="center">

- [console.cloud.google.com/vertex-ai/studio](https://console.cloud.google.com/vertex-ai/studio)
- For scaled deployments with **enterprise** ready data privacy and governance.

</div>

<div flex="grow">

```python
from vertexai.generative_models import GenerativeModel
content_model = GenerativeModel("gemini-1.5-flash-001")
content_model.generate_content(
        "Explain how AI works",
        generation_config=GenerationConfig(
            response_mime_type="application/json"
        ),
    )
```
</div>
</div>

<br/>

<div v-click v-motion
  :initial="{ y: -80 }"
  :enter="{ y: 0 }"
  :leave="{ y: 80 }" class="flex space-x-6">
<div flex="grow">
```python
import google.generativeai as genai
model = genai.GenerativeModel(
            'gemini-1.5-flash',
            generation_config={"response_mime_type": "application/json"}
        )
model.generate_content("Explain how AI works")
```
</div>
<div content="center" text="xs">

- [aistudio.google.com](https://aistudio.google.com)
- Recommended for *beginners*
</div>
</div>




<!-- 

#### vertex-ai
- needs a credentials file available in the environment
- will load it based on the `GOOGLE_APPLICATION_CREDENTIALS` env variable
- mention the package `vertexai`

#### google studio
- needs an API_KEY available as an env variable
- mentioned the package `google.generativeai`


Quite similar in terms of arguments and methods as you see

 -->