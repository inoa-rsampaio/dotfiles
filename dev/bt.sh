#!/bin/bash

echo -e "${VIOLET}* Running RabbitMQ and SQL Server${NC}"
echo

docker compose -p bt-dev down
docker compose -f ~/.inoa/dev/bt.deps.docker-compose -p bt-dev up -d

# TODO: health-check
