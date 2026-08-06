---
name: deploy-jvm
description: Deploy a Java Spring Boot app fast during a timed build. Use when deploying JVM, Java, or Spring applications, or when Vercel is not an option for the backend.
---

# JVM Deploys Under a Clock

Vercel does not host Spring. Options ranked:

1. **Railway** — `railway login` (browser), `railway init`, `railway up`. Buildpacks detect
   Maven/Gradle automatically. One requirement: respect the injected port —
   `server.port=${PORT:8080}` in application.properties. Account pre-created the night
   before. Budget 15-25 min for the first successful build.
2. **Render** — dashboard-driven web service from the repo; simple but first builds are slow.
3. **Local demo + Dockerfile as artifact** — legitimate under a clock. Demo on localhost,
   commit a two-stage Dockerfile (`eclipse-temurin:21` build → `21-jre` run), and NARRATE:
   "deployable by `docker build`; I spent the deploy minutes on features — happy to walk
   through the pipeline I'd stand up."

## Decision rule

Decide by T+0:30 whether you're doing a real JVM deploy. Past that point, option 3 beats a
half-configured cloud deploy every time. A working local demo with a clean Dockerfile and a
confident explanation outscores a broken prod URL.
