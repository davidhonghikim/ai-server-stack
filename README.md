# AI Server Stack

A comprehensive development environment for AI and web development, featuring a collection of essential services containerized with Docker.

## Services Included

- **Nginx**: Reverse proxy
- **PostgreSQL**: Primary database
- **PgAdmin**: PostgreSQL administration
- **Redis**: In-memory data store
- **Redis Commander**: Redis administration
- **MongoDB**: Document database
- **Mongo Express**: MongoDB administration
- **Neo4j**: Graph database
- **MinIO**: S3-compatible object storage
- **Nextcloud**: File hosting and collaboration
- **Supabase**: Open source Firebase alternative
- **N8N**: Workflow automation
- **Gitea**: Git service
- **Penpot**: Design and prototyping platform
- **OpenWebUI**: Web interface for Ollama

## Prerequisites

- Docker Engine 24.0.0+
- Docker Compose v2.20.0+
- Git

## Quick Start

1. Clone the repository:
   ```bash
   git clone https://github.com/davidhonghikim/ai-server-stack.git
   cd ai-server-stack
   ```

2. Create and configure your environment file:
   ```bash
   cp .env.example .env
   # Edit .env with your preferred settings
   ```

3. Start the stack:
   ```bash
   docker-compose up -d
   ```

4. Initialize Nextcloud (after containers are healthy):
   ```bash
   docker-compose exec nextcloud php occ maintenance:install \
     --database=pgsql \
     --database-host=postgres \
     --database-name=nextcloud \
     --database-user=nextcloud \
     --database-pass="${NEXTCLOUD_DB_PASSWORD}" \
     --admin-user="${ADMIN_USER}" \
     --admin-pass="${ADMIN_PASSWORD}"
   
   # Configure Redis cache
   docker-compose exec nextcloud php occ config:system:set redis host --value=redis
   docker-compose exec nextcloud php occ config:system:set redis port --value=6379
   docker-compose exec nextcloud php occ config:system:set redis password --value="${REDIS_PASSWORD}"
   docker-compose exec nextcloud php occ config:system:set memcache.local --value='\OC\Memcache\Redis'
   docker-compose exec nextcloud php occ config:system:set memcache.locking --value='\OC\Memcache\Redis'
   ```

## Accessing Services

- Nextcloud: http://nextcloud.localhost
- PgAdmin: http://pgadmin.localhost
- MinIO Console: http://minio.localhost:9091
- Gitea: http://gitea.localhost
- Penpot: http://penpot.localhost
- N8N: http://n8n.localhost
- Supabase Studio: http://studio.localhost
- OpenWebUI: http://openwebui.localhost

## Security Notes

1. This stack is configured for development use. For production:
   - Enable HTTPS
   - Change default passwords
   - Review and tighten security configurations
   - Implement proper backup strategies
   - Configure email settings

2. Default credentials are in your .env file. Change them before exposing services to the internet.

## Maintenance

### Backups
- Database backups are handled by pg_dump in cron jobs
- Nextcloud data is stored in Docker volumes
- MinIO data is stored in Docker volumes

### Updates
```bash
# Pull latest images
docker-compose pull

# Restart services
docker-compose up -d
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, please open an issue in the GitHub repository.
