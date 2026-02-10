import os
from pathlib import Path
from dotenv import load_dotenv

env_path = Path(__file__).resolve().parents[1] / ".env"
if env_path.exists():
    load_dotenv(env_path, override=True, encoding="utf-8-sig")
else:
    load_dotenv(override=True)


class Data:
    def __init__(self) -> None:
        self.LOGIN = (os.getenv("LOGIN") or "").strip()
        self.PASSWORD = (os.getenv("PASSWORD") or "").strip()

        if not self.LOGIN or not self.PASSWORD:
            raise ValueError("LOGIN and PASSWORD must be set in environment or .env")
