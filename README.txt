READ ME

DEPLOYMENT
Method Compile from docker-compose docker host using linux kernel
	
	1. Unzip/extract laravel project "pingcrm-dock.zip"
	2. docker pull redis:7-alpine
	3. docker build --pull -t role-app -f docker/app/Dockerfile .
	4. docker build --pull -t role-app-nginx -f docker/nginx/Dockerfile .
	5. env $(cat .env | grep ^[A-Z] | xargs) docker-compose up -d


Method using build image 
	
	1. unzip/extract images project 
	2. docker load -i redis.tar
	3. docker load -i role-app.tar
	4. docker load -i role-app-nginx.tar
	4. docker load -i myql.tar
	5. env $(cat .env | grep ^[A-Z] | xargs) docker-compose up -d