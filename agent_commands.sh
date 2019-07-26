bash -c "$(curl -sSL https://controlagent.streamsets.net/getagent.sh)"

bash -c "$(curl -sSL https://controlagent.streamsets.net/delagent.sh)"

curl -sSL https://get.replicated.com/kubernetes-init | sudo bash -s reset


function getAzurePublicIp()
{
    return $(curl -s -H Metadata:true "http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/publicIpAddress?api-version=2017-08-01&format=text")
}

function getAWsPublicIp()
{
    local ip=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
    return ip
}

function getGcpPublicIp()
{
    return $(curl --noproxy "*" --max-time 5 --connect-timeout 2 -qSfs -H 'Metadata-Flavor: Google' http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip 2>/dev/null)    
}

function checkIpProper() {
	local IP_REGEX="^[0-9]+.[0-9]+.[0-9]+.[0-9]+$"
	local IP=$($1)
	echo 
	if [[ $IP =~ $IP_REGEX ]]; then
		return $1
	else
		return
	fi
}

function getPublicIp() 
{
	if [ -z "$PUBLIC_IP" ]; then
		echo "AWS"
		PUBLIC_IP=$(checkIpProper getAWsPublicIp)
	fi
	if [ -z "$PUBLIC_IP" ]; then
		echo "GCP"
		PUBLIC_IP=$(checkIpProper getGcpPublicIp)
	fi
	if [ -z "$PUBLIC_IP" ]; then
		echo "Azure"
		PUBLIC_IP=$(checkIpProper getAzurePublicIp)
	fi
	if [ -z "$PUBLIC_IP" ]; then
		echo "Failed to determine the Public Ip for this machine, Please  Set it in PUBLIC_IP variable "
  		exit 1
  	fi
}
