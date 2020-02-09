data "null_data_source" "nzbhydra" {
  inputs = {
    tasks = jsonencode([
      {
        cpu       = 512
        essential = true
        image     = "nativecode/nzbhydra:latest"
        memory    = 1024
        name      = "nzbhydra"

        environment = [
          {
            name  = "PUID"
            value = "1000"
          },
          {
            name  = "PGID",
            value = "1000"
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
            awslogs-group         = "nzbhydra"
            awslogs-region        = "us-east-1"
            awslogs-stream-prefix = "prod"
          }
        }

        portMappings = [
          {
            containerPort = 5076
            hostPort      = 5076
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
