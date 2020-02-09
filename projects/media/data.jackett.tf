data "null_data_source" "jackett" {
  inputs = {
    tasks = jsonencode([
      {
        cpu       = 256
        essential = true
        image     = "nativecode/jackett:latest"
        memory    = 512
        name      = "jackett"

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
            awslogs-group         = "jackett"
            awslogs-region        = "us-east-1"
            awslogs-stream-prefix = "prod"
          }
        }

        portMappings = [
          {
            containerPort = 9117
            hostPort      = 9117
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
