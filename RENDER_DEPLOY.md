# Render deploy: why you see `go build` and how to fix it

## Diagnosis

Deploy logs show:

- `Using Go version …`
- `Running build command 'go build …'`

That proves this deploy is **not** using Docker. It is a **native Go Web Service** created (or auto-detected) in the Render Dashboard.

Facts:

1. **`Dockerfile` + `render.yaml` in Git do not change an existing Go Web Service.** Only Dashboard/API/Blueprint controls runtime for that resource.
2. **`render.yaml` is Blueprint-only.** Render applies it after you create a **Blueprint** instance pointed at this repo (or sync an existing Blueprint). See [Infrastructure as Code](https://render.com/docs/infrastructure-as-code).
3. **Dashboard runtime switch:** Render documents that changing runtime **from the service Settings UI is not supported**; use **Blueprint sync** or **Update Service API**. See [Changing a service's runtime](https://render.com/docs/native-runtimes#changing-a-services-runtime).

Your troubleshooting doc is correct: wrong runtime → wrong build. The fix is to attach **Docker** (or sync `runtime: docker` via Blueprint), not more repo tweaks alone.

## Fix A — Blueprint (recommended; matches `render.yaml`)

1. Open [Render Dashboard](https://dashboard.render.com/) → **Blueprints**.
2. **New Blueprint Instance** → connect **`https://github.com/ManiPrithvi7/influxdb`** → branch **`main`**.
3. Confirm Blueprint path **`render.yaml`** (repo root).
4. **Apply / Sync.** Fill secrets when prompted (`DOCKER_INFLUXDB_INIT_PASSWORD`, `DOCKER_INFLUXDB_INIT_ADMIN_TOKEN`).
5. **Important:** If you already have an old **Go** Web Service that auto-deploys from this repo, **turn off Auto Deploy on that service or delete it**, otherwise it will keep failing on every push while you watch its logs. Use the **Docker** service created/managed by the Blueprint.

Successful Docker logs should mention **Docker / Dockerfile / BuildKit**, not `go build`.

## Fix B — New Docker Web Service (no Blueprint)

1. **Delete** the failing Go Web Service (or disconnect Git auto-deploy).
2. **New** → **Web Service** → same repo → **Language / Environment: Docker**.
3. **Dockerfile Path:** `Dockerfile`.
4. Copy env vars, disk (`/var/lib/influxdb2`), health check `/health`, and ports from `render.yaml`.

## Fix C — Render API

Use **Update service** with `runtime` / Docker details via `serviceDetails`. See [Update service](https://api-docs.render.com/reference/update-service) and the runtime note above.

## Repo name caveat

The repo is named **`influxdb`**. When creating a Web Service manually, Render may suggest **Go** (same name family as the upstream InfluxDB project). Always choose **Docker** explicitly unless you use a Blueprint.
