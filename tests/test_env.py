from dotenv import load_dotenv
import os
from openai import OpenAI

# Load environment variables
load_dotenv()

# Get API key
api_key = os.getenv("OPENAI_API_KEY")

print("ENV TEST -> API Key loaded:", "YES" if api_key else "NO")

# Test OpenAI
client = OpenAI(api_key=api_key)

response = client.chat.completions.create(
    model="gpt-4o-mini",
    messages=[
        {"role": "user", "content": "Say 'HEALIE setup works' in one sentence."}
    ]
)

print("\nModel response:")
print(response.choices[0].message.content)