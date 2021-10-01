resource "powerdns_record" "dns-a" {
  zone    = "dnhrrs.xyz"
  name    = "ha.dnhrrs.xyz."
  type    = "A"
  ttl     = 3600
  records = ["10.23.30.5"]
}

resource "powerdns_record" "dns-ptr" {
  zone    = "23.10.in-addr.arpa"
  name    = "5.30.23.10.in-addr.arpa."
  type    = "PTR"
  ttl     = 3600
  records = ["ha.dnhrrs.xyz."]
}

resource "powerdns_record" "kiwi-a" {
  zone    = "dnhrrs.xyz"
  name    = "kiwi.dnhrrs.xyz."
  type    = "A"
  ttl     = 3600
  records = ["10.23.20.11"]
}

resource "powerdns_record" "kiwi-ptr" {
  zone    = "23.10.in-addr.arpa"
  name    = "11.20.23.10.in-addr.arpa."
  type    = "PTR"
  ttl     = 3600
  records = ["kiwi.dnhrrs.xyz."]
}
