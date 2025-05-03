# Ruby Docker Setup

This is a basic Docker setup for running Ruby applications without Rails.

## Prerequisites

- Docker
- Docker Compose

## Getting Started

1. Build the Docker image:

```bash
docker-compose build
```

2. Run the application:

```bash
docker-compose run route-calculator
```

## Project Structure

- `Dockerfile`: Contains the Docker image configuration
- `docker-compose.yml`: Defines the service configuration
- `Gemfile`: Lists Ruby dependencies
- `app.rb`: Sample Ruby application

## Adding Dependencies

To add new gems:

1. Add them to the `Gemfile`
2. Rebuild the Docker image:

```bash
docker-compose build
```

## Development

The project directory is mounted as a volume, so any changes you make to the Ruby files will be immediately available in the container. You don't need to rebuild the image for code changes.
