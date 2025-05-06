resource "yandex_mdb_kafka_cluster" "mykf" {
  environment         = "PRODUCTION"
  name                = "mykf"
  network_id          = yandex_vpc_network.mynet.id
  subnet_ids          = [ yandex_vpc_subnet.mysubnet.id ]
  security_group_ids  = [ yandex_vpc_security_group.mykf-sg.id ]
  deletion_protection = true

  config {
    assign_public_ip = true
    brokers_count    = 1
    version          = "3.5"
    kafka {
      resources {
        disk_size          = 10
        disk_type_id       = "network-ssd"
        resource_preset_id = "s2.micro"
      }
      kafka_config {}
    }

    zones = [
      "ru-central1-a"
    ]
  }
}

resource "yandex_vpc_network" "mynet" {
  name = "mynet"
}

resource "yandex_vpc_subnet" "mysubnet" {
  name           = "mysubnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.mynet.id
  v4_cidr_blocks = ["10.5.0.0/24"]
}

resource "yandex_vpc_security_group" "mykf-sg" {
  name       = "mykf-sg"
  network_id = yandex_vpc_network.mynet.id

  ingress {
    description    = "Kafka"
    port           = 9091
    protocol       = "TCP"
    v4_cidr_blocks = [ "0.0.0.0/0" ]
  }
}
