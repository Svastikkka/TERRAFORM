region="us-east-2"
availabilityZone1="us-east-2a"
availabilityZone2="us-east-2b"
app_instance_count=1
app_ec2_device_names=[ "/dev/sdd", "/dev/sde"]
db_instance_count=1
db_ec2_device_names=[ "/dev/sde"]

app_ebs_volume_size=7
db_ebs_volume_size=7

app_root_volume_type="gp2"
db_root_volume_type="gp2"

app_ebs_volume_type="gp2"
db_ebs_volume_type="gp2"

instanceTenancy="default"
dnsSupport=true
dnsHostNames=true
vpcCIDRblock="10.0.0.0/16"
subnetCIDRblock1="10.0.1.0/24"
subnetCIDRblock2="10.0.2.0/24"
destinationCIDRblock="0.0.0.0/0"
mapPublicIP=true