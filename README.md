# wordpress-dockerswarm

WordPress Deployment with Docker Swarm and Traefik.

## Prerequisites

- Docker
- Docker Compose
- Docker Swarm
- Traefik

## Installation

1. Clone the repository
2. Run the following command to deploy the stack: `docker stack deploy -c docker-compose.yml wordpress`
3. Access the WordPress site at `http://localhost`
4. Access the Traefik dashboard at `http://localhost:8080`

## License

MIT
