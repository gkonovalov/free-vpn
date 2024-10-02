import os
import subprocess

from builtins import input

DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'terraform')

REGION_TO_CITY = {
    # North America
    "us-east-1": "N.Virginia",
    "us-east-2": "Ohio",
    "us-west-1": "N. California",
    "us-west-2": "Oregon",
    "ca-central-1": "Canada (Central)",
    "ca-west-1": "Canada West (Calgary)",
    # South America
    "sa-east-1": "SaoPaulo",
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
    print("Welcome to the VPN management tool!")
    print("You can choose one of the following actions:")
    print("  'create'  : Set up a new VPN server.")
    print("  'destroy' : Remove an existing VPN server.")
    print("  'list'    : View all active VPN servers.")

    action = pinput("Enter action", "create")

    if action == "create":
        create_vpn()
    elif action == "destroy":
        destroy_vpn()
    elif action == "list":
        list_vpn()
    else:
        print(f"Invalid action '{action}'. Please enter 'create', 'destroy' or 'list'.")


def create_vpn():
    print("Available AWS regions:")
    available_regions = get_available_regions()

    print_city_regions(available_regions)

    region = pinput("Enter region", "us-east-1")

    if region in available_regions:
        create_vpn_resources(region)
    else:
        print(f"Invalid region name '{region}'. Please select a valid region.")


def destroy_vpn():
    existing_regions = get_existing_workspaces()
    print("Existing AWS Regions:")
    print_city_regions(existing_regions)
    print("Type 'all' to delete all regions, or provide space-separated names (e.g., 'us-east-1 us-east-2')")

    selected_regions_input = pinput("Enter region(s)", "all")

    if selected_regions_input.lower() == "all":
        selected_regions = existing_regions
    else:
        selected_regions = selected_regions_input.split()

    for region in selected_regions:
        if region in existing_regions:
            destroy_vpn_resources(region)
        else:
            print(f"Skipping invalid region: {region}")


def list_vpn():
    print("Existing AWS Regions:")
    print_city_regions(get_existing_workspaces())


def create_vpn_resources(region):
    var_file = os.path.join(DIR, 'variables', f"{region}.tfvars")

    instance_name = pinput("Enter instance name", "open-vpn-server")
    instance_type = pinput("Enter instance type", "t2.micro")
    ssh_username = pinput("Enter SSH username", "admin")
    ssh_key_name = pinput("Enter SSH key name", "open_vpn_server_key.pem")
    openvpn_dpi_bypass = pinput("Use OpenVPN DPI bypass", "yes")
    openvpn_port = 443
    openvpn_protocol = 'tcp'

    if openvpn_dpi_bypass == 'no':
        openvpn_port = pinput("Enter OpenVPN port", "1194")
        openvpn_protocol = pinput("Enter OpenVPN protocol", "udp")

    create_terraform_vars(var_file, region, instance_name,
                          instance_type, ssh_username, ssh_key_name,
                          openvpn_dpi_bypass, openvpn_port, openvpn_protocol)
    create_client_folders(region)

    print(f"Launching VPN for region: {region}")
    run_result = subprocess.run(['terraform', '-chdir=' + DIR, 'workspace', 'select', region], capture_output=True)
    if run_result.returncode != 0:
        subprocess.run(['terraform', '-chdir=' + DIR, 'workspace', 'new', region], capture_output=True)

    subprocess.run(['terraform', '-chdir=' + DIR, 'init', '-var-file=' + var_file])
    subprocess.run(['terraform', '-chdir=' + DIR, 'plan', '-var-file=' + var_file])
    subprocess.run(['terraform', '-chdir=' + DIR, 'apply', '-var-file=' + var_file, '-auto-approve'])


def destroy_vpn_resources(region):
    var_file = os.path.join(DIR, 'variables', f"{region}.tfvars")

    print(f"Switching to workspace: {region}")
    subprocess.run(['terraform', '-chdir=' + DIR, 'workspace', 'select', region])

    print(f"Destroying resources in region: {region}")
    run_result = subprocess.run(['terraform', '-chdir=' + DIR, 'destroy', '-var-file=' + var_file, '-auto-approve'])

    if run_result.returncode == 0:
        delete_file(var_file)
        delete_folder(os.path.join('server'))
        delete_folder(os.path.join('client', region))

        print(f"Deleting workspace: {region}")
        subprocess.run(['terraform', '-chdir=' + DIR, 'workspace', 'select', 'default'])
        subprocess.run(['terraform', '-chdir=' + DIR, 'workspace', 'delete', region])


def get_available_regions():
    run_result = subprocess.run(
        ['aws', 'ec2', 'describe-regions', '--query', "Regions[*].RegionName", '--output', 'text'],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

    if run_result.returncode == 0:
        return run_result.stdout.strip().split()
    else:
        print(f"Error fetching regions: {run_result.stderr.strip()}")
        return []


def get_existing_workspaces():
    run_result = subprocess.run(
        ['terraform', '-chdir=' + DIR, 'workspace', 'list'],
        capture_output=True, text=True
    )

    workspaces = []
    for line in run_result.stdout.splitlines():
        workspace = line.strip().lstrip('* ').strip()
        if workspace and 'default' not in workspace:
            workspaces.append(workspace)

    if not workspaces:
        print("No VPN servers have been created yet!")

    return workspaces


def print_city_regions(regions):
    sorted_regions = sorted(regions)

    for region in sorted_regions:
        city = REGION_TO_CITY.get(region)
        if city:
            print(f"{city} -> {region}")
        else:
            print(f"City not found -> {region}")


def pinput(prompt, default=None):
    if default:
        return input(f"{prompt} (default is '{default}'): ").lower() or default
    else:
        return input(f"{prompt}: ")


def create_terraform_vars(var_file, region, instance_name,
                          instance_type, ssh_username, ssh_key_name,
                          openvpn_dpi_bypass, openvpn_port, openvpn_protocol):
    print(f"Writing variables to {var_file}...")
    os.makedirs(os.path.join(DIR, 'variables'), exist_ok=True)

    with open(os.path.join(DIR, var_file), 'w') as file:
        file.write(f"""
                       aws_region = "{region}"
                       instance_name = "{instance_name}"
                       instance_type = "{instance_type}"
                       ssh_username = "{ssh_username}"
                       ssh_key_name = "{ssh_key_name}"
                       openvpn_port = {openvpn_port}
                       openvpn_protocol = "{openvpn_protocol}"
                       openvpn_dpi_bypass = "{"" if openvpn_dpi_bypass == "yes" else "#"}"
                   """)


def create_client_folders(region):
    print(f"Create client folder structure for {region}...")
    client = os.path.join('client', region)

    os.makedirs(os.path.join(client, 'openvpn'), exist_ok=True)
    os.makedirs(os.path.join(client, 'scripts'), exist_ok=True)
    os.makedirs(os.path.join(client, 'keys'), exist_ok=True)


def delete_file(path):
    print(f"Removing file: {path}")
    if os.path.isfile(path):
        os.remove(path)
        print(f"File removed successfully!")


def delete_folder(path):
    print(f"Removing folder: {path}")
    if os.path.isdir(path):
        subprocess.run(['rm', '-rf', path])
        print(f"Folder removed successfully!")


if __name__ == "__main__":
    main()