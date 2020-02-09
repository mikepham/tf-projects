data "null_data_source" "ombi" {
  inputs = {
    tasks = jsonencode([
      {
        cpu       = 256
        essential = true
        image     = "nativecode/ombi:latest"
        memory    = 512
        name      = "ombi"

        environment = [
          {
            name  = "PUID"
            value = "0"
          },
          {
            name  = "PGID",
            value = "0"
          },
          {
            name  = "TZ",
            value = "America/New_York"
          },
          {
            name  = "BUCKET_NAME",
            value = local.private_bucket_name
          }
        ]

        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = "ombi"
            awslogs-region        = "us-east-1"
            awslogs-stream-prefix = "prod"
          }
        }

        portMappings = [
          {
            containerPort = 3579
            hostPort      = 3579
          }
        ]

        secrets = [
          {
            name      = "SECRETS"
            valueFrom = module.secrets.arn
          }
        ]
      }
    ])
  }
}
