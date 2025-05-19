# Route Calculator

A freight forwarding application that finds the best sailing options between ports.

## Prerequisites

- Docker
- Docker Compose

## Setup

```bash
docker-compose build
```

## Running the Application

The application can be run in three different modes:

### 1. Interactive Mode (Default)

```bash
# Run with interactive prompts
docker-compose run --rm route-calculator

docker-compose run route-calculator "-i"
```

You will be prompted to enter:

- Origin port (e.g., CNSHA)
- Destination port (e.g., NLRTM)
- Criteria (either 'cheapest-direct' or 'cheapest')

### 2. File Input Mode

```bash
# Create an input file
echo -e "CNSHA\nNLRTM\ncheapest-direct" > input.txt

# Run with input file
docker-compose run --rm route-calculator "-f input.txt"
```

The input file should contain exactly 3 lines:

```text
CNSHA
NLRTM
cheapest-direct
```

### 3. Help

```bash
# Show usage information
docker-compose run --rm route-calculator "--help"
```

## Running Tests

```bash
docker-compose run --rm test bundle exec rspec
```

## Example Output

For successful queries, the output will be JSON formatted:

```json
[
  {
    "origin_port": "CNSHA",
    "destination_port": "NLRTM",
    "departure_date": "2022-02-01",
    "arrival_date": "2022-03-01",
    "sailing_code": "ABCD",
    "rate": "500.00",
    "rate_currency": "USD"
  }
]
```

For errors, you'll receive:

```json
{
  "error": "Error message description"
}
```
