[
  {
    "name": "expert-pancake-app",
    "image": "${app_image}",
    "portMappings": [
      {
        "containerPort": ${app_port},
        "hostPort": ${app_port}
      }
    ],
    "logConfiguration" : {
      "logDriver" : "awslogs",
      "options": {
          "awslogs-group": "${log_group}",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "${log_stream}"
      }
    }
  }
]
