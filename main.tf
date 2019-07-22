// Configure the Google Cloud provider
variable "node_count" {
  default = 3
}

variable "data_count" {
  default = 2
}

provider "google" {
  credentials = file("test.json")
  project     = "projectid"
  region      = "us-central1-a"
}

// Terraform plugin for creating random ids

// A single Google Cloud Engine instance

// Google Cloud Engine instance for masters
resource "google_compute_instance" "default" {
  count        = var.node_count
  name         = "master${count.index + 1}"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  // Make sure flask is installed on all new instances for later steps
  metadata_startup_script = "sudo yum update; sudo yum install -y build-essential python-pip rsync; pip install flask"

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }
}

// Google Cloud Engine instance for masters
resource "google_compute_instance" "vinodh" {
  count        = var.data_count
  name         = "worker${count.index + 1}"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  // Make sure flask is installed on all new instances for later steps
  metadata_startup_script = "sudo yum update; sudo yum install -y build-essential python-pip rsync; pip install flask"

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }
}

