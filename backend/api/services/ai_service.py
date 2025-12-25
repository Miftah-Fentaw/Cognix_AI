"""AI service helpers.

This module calls the external Groq API to analyze text and returns a dict
matching the schema:

{
  "summary": "string",
  "short_notes": ["string", "..."],
  "questions": ["string", "..."],
  "answers": ["string", "..."]
}

Configure via environment variables:
- GROQ_API_KEY: required
- GROQ_API_URL: optional; defaults to https://api.groq.com/openai/v1/chat/completions

The module exposes:
- analyze_text_with_grok(text: str) -> dict
- analyze_text(text: str) -> dict  (alias, used by file processing)
"""

import json
import logging
import os
from typing import Dict

import requests
# Try to load .env if python-dotenv is available, but don't crash if not
try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass

logger = logging.getLogger(__name__)


def _build_prompt(text: str) -> str:
    return (
        "You are an academic assistant.\n"
        "Analyze the following text and respond ONLY with valid JSON that exactly "
        "matches this schema (no markdown, no explanation, no extra text):\n\n"
        "{\n"
        "  \"summary\": \"3-5 detailed paragraphs covering all key concepts\",\n"
        "  \"short_notes\": [\"note 1\", \"note 2\", ... \"note 10-15\"],\n"
        "  \"quiz\": [\n"
        "    {\n"
        "      \"question\": \"The question text?\",\n"
        "      \"options\": [\"Option A\", \"Option B\", \"Option C\", \"Option D\"],\n"
        "      \"answer\": \"The correct option text\"\n"
        "    },\n"
        "    ... (20 questions)\n"
        "  ]\n"
        "}\n\n"
        "Requirements:\n"
        "- Summary: 3-5 comprehensive paragraphs\n"
        "- Short Notes: 10-15 detailed, informative bullet points\n"
        "- Quiz: Exactly 20 detailed multiple-choice questions. \n"
        "  - 'options' MUST contain 4 distinct choices (1 correct, 3 distractors).\n"
        "  - 'answer' MUST be one of the strings from 'options'.\n\n"
        "If you cannot produce content, return empty string/arrays for the fields.\n\n"
        "TEXT:\n"
        f"{text}\n"
    )


def analyze_text_with_grok(text: str) -> dict:
    if not text or not text.strip():
        raise ValueError("No text to analyze. Ensure extracted text is provided.")

    api_key = os.getenv("GROQ_API_KEY")
    # For Groq, the endpoint usually ends in /chat/completions
    api_url = os.getenv("GROQ_API_URL", "https://api.groq.com/openai/v1/chat/completions")
    model = os.getenv("GROQ_MODEL", "llama-3.3-70b-versatile")

    if not api_key:
        raise EnvironmentError("GROQ_API_KEY not set in environment")

    prompt = _build_prompt(text)

    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
    }

    # API Payload for Chat Completions
    payload = {
        "model": model,
        "messages": [
            {"role": "system", "content": "You are a helpful JSON-only API assistant."},
            {"role": "user", "content": prompt}
        ],
        "temperature": 0.3,
        "max_tokens": 8000,
        "response_format": {"type": "json_object"}
    }

    try:
        resp = requests.post(api_url, json=payload, headers=headers, timeout=120)
        
        if resp.status_code != 200:
             # Try to get error message from body
            try:
                err_body = resp.json()
                error_msg = err_body.get('error', {}).get('message', resp.text)
            except:
                error_msg = resp.text
            raise Exception(f"Groq API error {resp.status_code}: {error_msg}")

        try:
            resp_json = resp.json()
        except ValueError:
            raise ValueError("Groq response not JSON")

        # Extract content from Chat Completion response structure
        # { "choices": [ { "message": { "content": "..." } } ] }
        raw_text = ""
        if isinstance(resp_json, dict) and "choices" in resp_json:
             choices = resp_json["choices"]
             if choices and isinstance(choices, list):
                 message = choices[0].get("message", {})
                 raw_text = message.get("content", "")
        
        # Fallback if standard structure isn't found
        if not raw_text:
             # Try direct keys just in case
             raw_text = (
                resp_json.get("output")
                or resp_json.get("text")
                or resp_json.get("response")
                or resp_json.get("result")
                or json.dumps(resp_json)
            )

        logger.debug("Raw Groq response: %s", raw_text)

        # Try direct JSON parse
        try:
            parsed = json.loads(raw_text)
        except Exception:
            # Try to extract JSON substring
            start = raw_text.find("{")
            end = raw_text.rfind("}")
            if start != -1 and end != -1 and end > start:
                candidate = raw_text[start : end + 1]
                parsed = json.loads(candidate)
            else:
                raise ValueError("Failed to parse JSON from Groq response")

        # Normalize result to ensure correct types
        final_result = {
            "summary": parsed.get("summary", "No summary generated"),
            "short_notes": parsed.get("short_notes", []),
            "quiz": parsed.get("quiz", []),
        }

        # Ensure lists
        for k in ("short_notes", "quiz"):
            if not final_result.get(k) or not isinstance(final_result[k], list):
                final_result[k] = []

        return final_result

    except requests.exceptions.Timeout:
        raise Exception("Groq API request timed out. Please try again.")
    except requests.exceptions.RequestException as e:
        raise Exception(f"Failed to connect to Groq API: {str(e)}")
    except json.JSONDecodeError as e:
        raise Exception(f"Failed to parse JSON from Groq response: {str(e)}")
    except Exception as e:
        logger.exception("Error processing Groq response: %s", e)
        raise


def analyze_text(text: str) -> Dict:
    """Compatibility wrapper used by file-processing endpoint; delegates to Grok."""
    return analyze_text_with_grok(text)


def generate_study_material(text: str, pages: int) -> str:
    """
    Generates detailed study material based on the input text/topic.
    Target length is approximated by the requested number of pages.
    """
    if not text or not text.strip():
        raise ValueError("No text provided for generation.")

    api_key = os.getenv("GROQ_API_KEY")
    api_url = os.getenv("GROQ_API_URL", "https://api.groq.com/openai/v1/chat/completions")
    # Using a model capable of long context/output if possible, or standard versatile
    model = os.getenv("GROQ_MODEL", "llama-3.3-70b-versatile")
    
    if not api_key:
        raise EnvironmentError("GROQ_API_KEY not set in environment")
    
    # Estimate word count: approx 400 words per page
    target_words = pages * 400
    
    prompt = (
        f"You are an expert academic content generator.\n"
        f"Generate a comprehensive, detailed study guide based on the following topic/content:\n\n"
        f"TOPIC/CONTENT: {text}\n\n"
        f"REQUIREMENTS:\n"
        f"1. The output must be approximately {target_words} words long to fill about {pages} pages.\n"
        f"2. Structure the content with clear headings (Heading 1, Heading 2), bullet points, and paragraphs.\n"
        f"3. Include a detailed Introduction, Core Concepts, In-depth Analysis, Examples, and a Conclusion.\n"
        f"4. Return ONLY the content in plain text format (Markdown-like structure is okay for headings, but do not use code blocks).\n"
        f"5. Do NOT include any 'Here is your file' or conversational filler. Just the study material.\n"
        f"6. Make it educational, professional, and easy to read.\n"
    )

    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
    }
    
    payload = {
        "model": model,
        "messages": [
            {"role": "system", "content": "You are a knowledgeable academic assistant."},
            {"role": "user", "content": prompt}
        ],
        "temperature": 0.5,
        "max_tokens": 8000, # Requesting long output
    }
    
    try:
        resp = requests.post(api_url, json=payload, headers=headers, timeout=180) # Longer timeout for generation
        
        if resp.status_code != 200:
             try:
                err_body = resp.json()
                error_msg = err_body.get('error', {}).get('message', resp.text)
             except:
                error_msg = resp.text
             raise Exception(f"Groq API error {resp.status_code}: {error_msg}")
             
        resp_json = resp.json()
        content = ""
        if isinstance(resp_json, dict) and "choices" in resp_json:
             choices = resp_json["choices"]
             if choices and isinstance(choices, list):
                 content = choices[0].get("message", {}).get("content", "")
                 
        if not content:
            raise ValueError("No content generated by Groq.")
            
        return content

    except Exception as e:
        logger.exception("Error generating study material: %s", e)
        raise

