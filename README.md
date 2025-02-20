# Deployment Template for Monolithic CRM System (Vite + Laravel) Using Role-Based Architecture  

This template simplifies deploying a monolithic CRM system built with Vite (frontend) and Laravel (backend) by organizing components into *modular roles* (e.g., web server, database, queue worker). Each role is containerized (using Docker/Kubernetes) to ensure scalability and easy management.  

**How It Works:**  
1. **Role-Based Structure:** Components are grouped by function (e.g., "API role," "Frontend role") for clarity.  
2. **Containerization:** Each role runs in isolated containers, enabling independent scaling (e.g., scale the API without affecting the database).  
3. **Simplified Scaling:** Add/remove container instances for specific roles as traffic grows.  

**Benefits:**  
- Easy to maintain and update individual components.  
- Effortlessly scale high-demand services.  
- Consistent environments (development, staging, production).  

Perfect for teams transitioning from monolithic apps to scalable, modern infrastructure.

**Source**
1. https://github.com/inertiajs/pingcrm (template laravel project)
2. https://medium.com/@dkhorev/docker-container-roles-pattern-for-laravel-apps-d445a62d230f (Docker Container Roles Pattern for Laravel Apps)
3. https://github.com/dkhorev/docker-container-roles-pattern-laravel
4. https://github.com/VirtuBox/nginx-ee (custom nginx)

**Prerequisites**
- Docker host (prefferably linux kernel)
- Node 20
- PHP 8.2 or higher & Composer 2 or higher
- GIT

# Deployment
**Build Project on host**
Clone repo 
```sh
git clone https://github.com/sigitbayutarnatanaya/ccrm-rolepattern-laravel/
cd ccr-rolepattern-laravel
```
Build CRM
```sh
composer install
npm ci
npm run build
cp .env.example .env
php artisan key:generate
```
Build image container
```sh
docker pull redis:7-alpine
docker build --pull -t role-app -f docker/app/Dockerfile .
docker build --pull -t role-app-nginx -f docker/nginx/Dockerfile .
```
RUN Stack
```sh
env $(cat .env | grep ^[A-Z] | xargs) docker-compose up -d
```

**Note**
- This project preferrable to build laravel project (composer&npm) on docker host before deployment for staging or testing scenario
- Using Nginx-EE (custom NGINX), change to Docker Image Nginx for more stable deployment (ccrm-rolepattern-larvel/docker/nginx/Dockerfile)

**Room to Improve**
- For automation deployment need to improve on image build for NodeJs and Composer inside Docker build
- Still Using Default setting and config for every dependecy
