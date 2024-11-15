import os
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from starlette.middleware.sessions import SessionMiddleware
from dotenv import load_dotenv
from supabase import create_client, Client
from routes import user_routes, enterprise_routes
from fastapi.templating import Jinja2Templates
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_ANON_KEY = os.getenv("SUPABASE_ANON_KEY")
SUPABASE_SERVICE_ROLE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY")

supabase_admin: Client = create_client(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)
supabase: Client = create_client(SUPABASE_URL, SUPABASE_ANON_KEY)

app = FastAPI()

app.add_middleware(
    SessionMiddleware, 
    secret_key=os.getenv("SESSION_SECRET_KEY", "your-secret-key")
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:8000", "http://127.0.0.1:8000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Get the directory of the current file (main.py)
project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Mount static files
app.mount("/static", StaticFiles(directory=os.path.join(project_root, "static")), name="static")

# Set up templates
templates = Jinja2Templates(directory=os.path.join(project_root, "templates"))

# Include routers
app.include_router(user_routes.router, prefix="/user")
app.include_router(enterprise_routes.router, prefix="/enterprise")

@app.get("/")
async def read_root(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})

@app.middleware("http")
async def session_middleware(request: Request, call_next):
    try:
        # Try to get session from cookies
        access_token = request.cookies.get("sb-access-token")
        refresh_token = request.cookies.get("sb-refresh-token")

        if access_token and refresh_token:
            # Store tokens in request state
            request.state.access_token = access_token
            request.state.refresh_token = refresh_token
            logger.info("Session tokens found in cookies")
        else:
            logger.info("No session tokens found in cookies")

    except Exception as e:
        logger.error(f"Session middleware error: {str(e)}")

    response = await call_next(request)
    return response

if __name__ == "__main__":
    import uvicorn
    logger.info("Starting FastAPI server...")
    uvicorn.run(app, host="127.0.0.1", port=8000)
