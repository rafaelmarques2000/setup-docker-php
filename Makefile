server:
	@docker-compose -f docker-compose.yml up
shell:
	@docker-compose exec server_php_fpm bash
