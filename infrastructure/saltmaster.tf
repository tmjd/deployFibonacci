
resource "digitalocean_droplet" "saltmaster" {
    image = "ubuntu-15-04-x64"
    name = "saltmaster"
    region = "nyc3"
    size = "512mb"
    backups = false
    ipv6 = false
    private_networking = false
    ssh_keys = [ "${var.ssh_fingerprint}" ]
}
