access_key = ""
secret_key = ""

region="us-east-1"

availabilityZone="us-east-1a"

vpcCIDRblock="10.0.0.0/16"
instanceTenancy="default"
dnsSupport=true
dnsHostNames=true

subnetCIDRblock="10.0.1.0/24"
mapPublicIP=true


app_db_ami="ami-057fd9c10186a9a20"
app_db_count=1
app_db_instance_type="t2.xlarge"

desknow_roundcube_ami="ami-0e597e1cc2bcdf6b8"
desknow_roundcube_count=1
desknow_roundcube_instance_type="t2.medium"

slave_ami="ami-015a29c26f175bfaa"
slave_count=1
slave_instance_type="t2.medium"

master_ami="ami-057409d7f6f61e8ad"
master_count=1
master_instance_type="c5a.large"