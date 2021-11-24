docker-compose run --rm --user=1000:1000 composer install

docker-compose run --rm --user=1000:1000 npm install

docker-compose run --rm --user=1000:1000 artisan migrate
