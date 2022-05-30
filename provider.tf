terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {}
variable "pvt_key" {}
variable "pub_key" {}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "machiron" {
  name = "machiron"
}
data "digitalocean_tag" "k8s-test" {
  name = "k8s-test"
}
data "template_file" "hosts" {
  template = "${file("${path.module}/templates/hosts.tpl")}"
  depends_on = [
    "digitalocean_droplet.master1",
    "digitalocean_droplet.master2",
    "digitalocean_droplet.master3",
    "digitalocean_droplet.worker",
    "digitalocean_droplet.ha"
  ]
  vars = {
    ip_master1 = "${join("\n", digitalocean_droplet.master1.*.ipv4_address )}"
    ip_master2 = "${join("\n", digitalocean_droplet.master2.*.ipv4_address )}"
    ip_master3 = "${join("\n", digitalocean_droplet.master3.*.ipv4_address )}"
    ip_workers = "${join("\n", digitalocean_droplet.worker.*.ipv4_address )}" 
    ip_ha      = "${join("\n", digitalocean_droplet.ha.*.ipv4_address )}"
    tag_master1 = "${join("\n", digitalocean_droplet.master1.*.name )}"
    tag_master2 = "${join("\n", digitalocean_droplet.master2.*.name )}"
    tag_master3 = "${join("\n", digitalocean_droplet.master3.*.name )}"
    tag_workers = "${join("\n", digitalocean_droplet.worker.*.name )}"
    tag_ha = "${join("\n", digitalocean_droplet.ha.*.name )}"
  }
}
