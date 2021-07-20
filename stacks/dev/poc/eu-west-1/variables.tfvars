## perf env ##

region = "eu-west-1"
environment = "poc"
cluster = "poc"
account="dev"
key_name = "Srini-capgemini"

springweb_enable = true

# these use ASG so we add a few more instances than # of regions (used as MIN) for the MAX
springwebnodes = "1"

sites = "poc-sites"

instance_types = {
    springweb      = "t3.micro",
}

springweb_prefix = "sw"
springweb_prj_prefix = "poc"
# SSL cert of Apache backend Auth for ELB
# get the cert from hiera or a running machine and run
# cat server.pem | openssl x509 -pubkey -noout | grep -v '\-\-\-\-' | tr -d '\n' > server.pubkey
# This is public info so we don't care to encrypt them
pubkeys = {
    # correct
    springweb = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA3DHcjoC+UZq0lj97EOpuRF293OHm1PvXM3zhHVU8Aiyew+H+hB4H3ZVOF4dEmY8Bi2GNVpfWltBOmn2yNKJLEU7vOV0id8FhTRx0BvqyhWn/mD36X2SVGZ0Z7LyTln7QWhi7fBA6wOOl5/vBcCgwfYDYysZYa3EWtL86x/mo/TStfz3Cgwcs3moJ6oWzLAUqG1gdMKQtas4S4B5ClvbiD3GhVrF9CZUNkeaksCzCjiI+Xw+kY4+487cXiNXbzErPCHSvxlLecERnJwdlp4cBtDxk0FJBhixnBqrdyH09HfKkEK2qnD9RkovLiPoQbPNcp0kMfRTZwPgPBeZKVVHVcwIDAQAB"
}
