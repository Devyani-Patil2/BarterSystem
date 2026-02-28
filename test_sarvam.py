import urllib.request
import json
import ssl

url = "https://api.sarvam.ai/translate"
headers = {
    "Content-Type": "application/json",
    "api-subscription-key": "sk_w73niim4_FC1u1NXdtVNj05nc4edHSeSx"
}
data = {
    "input": "Home",
    "source_language_code": "en-IN",
    "target_language_code": "mr-IN",
    "speaker_gender": "Male",
    "mode": "formal",
    "model": "sarvam-translate:v1",
    "enable_preprocessing": True
}

req = urllib.request.Request(url, data=json.dumps(data).encode("utf-8"), headers=headers)
try:
    with urllib.request.urlopen(req) as res:
        print(res.read().decode("utf-8"))
except Exception as e:
    print(e)
    if hasattr(e, 'read'):
        print(e.read().decode('utf-8'))
