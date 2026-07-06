# Issue #6 - Docker Setup

## Goal

Create a production-ready Dockerfile.

---

## What we learned

- Multi-stage Docker builds
- Builder vs Runtime images
- Non-root user
- Healthcheck
- Docker layers
- Port mapping
- Docker build context

---

## Commands Used

docker build -t tiffinpin-backend .

docker run --rm -p 8000:8000 tiffinpin-backend

docker ps

docker images

docker history tiffinpin-backend

---

## Problems Faced

1. Docker not installed
2. Broken Docker symlink
3. requirements.txt contained editable Git dependency
4. main.py placed in wrong directory
5. Image size exceeded target

---

## How We Fixed Them

- Installed Docker Desktop
- Removed old binaries
- Removed editable dependency
- Moved main.py to app/
- Rebuilt image

---

## Backend Concepts Learned

- Multi-stage builds
- Container
- Image
- Builder stage
- Runtime stage
- HEALTHCHECK
- CMD
- EXPOSE

---

## Interview Questions

What is a Docker Image?

What is a Container?

Difference between CMD and ENTRYPOINT?

Why use multi-stage builds?

Why should containers run as non-root?

---

## Revision (30 seconds)

Docker builds an immutable image.

Container runs that image.

Builder installs dependencies.

Runtime stays lightweight.

Healthcheck verifies application health.

FastAPI starts with

uvicorn app.main:app