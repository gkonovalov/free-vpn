import json
import os
import subprocess

from builtins import input

ROOT = os.path.dirname(os.path.abspath(__file__))
TERRAFORM = os.path.join(ROOT, 'terraform')
ANSIBLE = os.path.join(ROOT, 'ansible')
SERVERS = os.path.join(ROOT, 'servers')

CONFIG_FILE = 'config.json'
OPEN_VPN = 'openvpn.yml'
WIREGUARD = 'wireguard.yml'

REGION_TO_CITY = {
    # North America
    "us-east-1": "N. Virginia",
    "us-east-2": "Ohio",
    "us-west-1": "N. California",
    "us-west-2": "Oregon",
    "ca-central-1": "Canada (Central)",
    "ca-west-1": "Canada West (Calgary)",
    # South America
    "sa-east-1": "São Paulo",
    # Europe
    "eu-west-1": "Ireland",
    "eu-west-2": "London",
    "eu-west-3": "Paris",
    "eu-central-1": "Frankfurt",
    "eu-north-1": "Stockholm",
    "eu-south-1": "Milan",
    "eu-south-2": "Spain",
    "eu-central-2": "Zurich",
    # Middle East & Africa
    "me-south-1": "Bahrain",
    "me-central-1": "UAE",
    # Asia Pacific
    "ap-southeast-1": "Singapore",
    "ap-southeast-2": "Sydney",
    "ap-southeast-3": "Jakarta",
    "ap-southeast-4": "Melbourne",
    "ap-southeast-5": "Malaysia",
    "ap-northeast-1": "Tokyo",
    "ap-northeast-2": "Seoul",
    "ap-northeast-3": "Osaka",
    "ap-south-1": "Mumbai",
    "ap-south-2": "Hyderabad",
    "ap-east-1": "Hong Kong",
    # China
    "cn-north-1": "Beijing",
    "cn-northwest-1": "Ningxia",
}


def main():
    print("Welcome to the Free VPN management tool!")
    print("You can choose one of the following actions:")
    print("  'deploy'  : Set up a new VPN server.")
    print("  'destroy' : Remove an existing VPN server.")
    print("  'list'    : View all active VPN servers.")

    action = pinput("Enter action", "deploy", ["deploy", "destroy", "list"])

    if action == "deploy":
        print("Available AWS Regions:")
        region_selection(get_available_regions, deploy_vpn_resources)
    elif action == "destroy":
        print("Existing VPN servers:")
        region_selection(get_existing_regions, destroy_vpn_resources)
    elif action == "list":
        print("Existing VPN servers:")
        print_city_regions(get_existing_regions())
    else:
        print(f"Invalid action '{action}'")


def deploy_vpn_resources(region):
    if region in get_existing_regions():
        print(f"VPN server for the {region} region already exists!")
        print("You will need to destroy the server before applying any changes!")
        return

    var_file, vpn_server_type = parameters_selection(region)

    subprocess.run(['terraform', '-chdir=' + TERRAFORM, 'workspace', 'select', '-or-create', region])
    subprocess.run(['terraform', '-chdir=' + TERRAFORM, 'init', '-var-file=' + var_file])
    subprocess.run(['terraform', '-chdir=' + TERRAFORM, 'plan', '-var-file=' + var_file])
    run_result = subprocess.run(['terraform', '-chdir=' + TERRAFORM, 'apply', '-var-file=' + var_file, '-auto-approve'])

    if run_result.returncode == 0:
        ansible_configuration_update(region, vpn_server_type)


def destroy_vpn_resources(region):
    print(f"Destroying VPN server in region:'{region}'")

    var_file = os.path.join(SERVERS, region, CONFIG_FILE)

    subprocess.run(['terraform', '-chdir=' + TERRAFORM, 'workspace', 'select', region])
    run_result = subprocess.run(['terraform', '-chdir=' + TERRAFORM, 'destroy', '-var-file=' + var_file, '-auto-approve'])

    if run_result.returncode == 0:
        print(f"Deleting config files: {region}")
        delete_file(var_file)
        delete_folder(os.path.join(SERVERS, region))

        print(f"Deleting workspace: {region}")
        subprocess.run(['terraform', '-chdir=' + TERRAFORM, 'workspace', 'select', 'default'])
        subprocess.run(['terraform', '-chdir=' + TERRAFORM, 'workspace', 'delete', region])


def ansible_configuration_update(region, vpn_server_type):
    print("Configuring VPN server...")
    ansible = os.path.join(ANSIBLE, vpn_server_type)
    config = '@' + os.path.join(SERVERS, region, CONFIG_FILE)

    subprocess.run(['ansible-playbook', ansible, "-i 'servers_group',", '--extra-vars', config])


def region_selection(get_regions, action):
    regions = get_regions()

    if not regions:
        print("AWS regions is not available!")
        return

    print_city_regions(regions)

    action(pinput("Enter region name", "us-east-1", regions))


def parameters_selection(region):
    instance_name = pinput("Enter instance name", "vpn-server")
    instance_type = pinput("Enter instance type", "t3.micro")
    vpn_server_type = pinput("Enter VPN Server type (wireguard|openvpn)", "wireguard", ["wireguard", "openvpn"])
    vpn_dpi_bypass = False

    if vpn_server_type == "wireguard":
        vpn_port = pinput("Enter VPN port", "1194")
        vpn_protocol = 'udp'
        vpn_server_type = WIREGUARD
    else:
        vpn_server_type = OPEN_VPN
        vpn_dpi_bypass = pinput("Use VPN DPI bypass (yes|no)", "yes", ["yes", "no"]) == "yes"

        if vpn_dpi_bypass:
            vpn_port = 443
            vpn_protocol = 'tcp'
        else:
            vpn_port = pinput("Enter VPN port", "1194")
            vpn_protocol = pinput("Enter VPN protocol (tcp|udp)", "udp", ["tcp", "udp"])

    settings = {
        "aws_region": region,
        "instance_name": instance_name,
        "instance_type": instance_type,
        "vpn_port": vpn_port,
        "vpn_protocol": vpn_protocol,
        "vpn_dpi_bypass": vpn_dpi_bypass
    }

    return save_config_file(region, settings), vpn_server_type


def get_existing_regions():
    return list(set(get_existing_workspaces()) & set(get_files_list(SERVERS)))


def get_available_regions():
    run_result = subprocess.run(
        ['aws', 'ec2', 'describe-regions', '--query', "Regions[*].RegionName", '--output', 'text'],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
    )

    if run_result.returncode == 0:
        return run_result.stdout.strip().split()
    else:
        print(f"Error fetching regions: {run_result.stderr.strip()}")
        return []


def get_existing_workspaces():
    run_result = subprocess.run(
        ['terraform', '-chdir=' + TERRAFORM, 'workspace', 'list'],
        capture_output=True, text=True
    )

    workspaces = []
    for line in run_result.stdout.splitlines():
        workspace = line.strip().lstrip('* ').strip()
        if workspace and 'default' not in workspace:
            workspaces.append(workspace)

    return workspaces


def print_city_regions(regions):
    sorted_regions = sorted(regions)

    for region in sorted_regions:
        city = REGION_TO_CITY.get(region)

        if city:
            print(f"{region} - {city}")
        else:
            print(f"{region} - City not found")


def pinput(prompt, default=None, options=[]):
    if default:
        parameter = input(f"{prompt} (default is '{default}'): ").lower() or default
    else:
        parameter = input(f"{prompt}: ")

    if options and parameter not in options:
        print("Invalid parameter, try again!")
        return pinput(prompt, default, options)

    return parameter


def save_config_file(region, data):
    var_file = os.path.join(SERVERS, region, CONFIG_FILE)

    create_folder(os.path.join(SERVERS, region))

    with open(var_file, 'w') as file:
        json.dump(data, file, indent=4)

    return var_file


def get_files_list(path):
    if os.path.isdir(path):
        return os.listdir(SERVERS)

    return []


def read_config_file(region):
    var_file = os.path.join(SERVERS, region, CONFIG_FILE)

    if os.path.isfile(var_file):
        with open(var_file, 'r') as file:
            return json.load(file)


def create_folder(path):
    if not os.path.isdir(path):
        os.makedirs(path, exist_ok=True)


def delete_file(path):
    if os.path.isfile(path):
        os.remove(path)


def delete_folder(path):
    if os.path.isdir(path):
        subprocess.run(['rm', '-rf', path])


if __name__ == "__main__":
    main()
