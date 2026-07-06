from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def v1():
    return {"version": "v1"}