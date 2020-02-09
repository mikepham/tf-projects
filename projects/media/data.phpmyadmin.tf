data "null_data_source" "phpmyadmin" {
  inputs = {
    tasks = jsonencode([
      {
        cpu       = 256
        essential = true
        image     = "phpmyadmin/phpmyadmin:latest"
        memory    = 512
        name      = "phpmyadmin"

        environment = [
          {
            name  = "PMA_ARBITRARY",
            value = "1"
          },
          {
            name  = "PMA_HOST",
            value = module.rds.address
          },
          {
            name  = "UPLOAD_LIMIT",
            value = "102400"
          },
        ]

        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = "phpmyadmin"
            awslogs-region        = "us-east-1"
            awslogs-stream-prefix = "prod"
          },
        }

        portMappings = [
          {
            containerPort = 80
            hostPort      = 80
          },
        ]
      },
    ])
  }
}
