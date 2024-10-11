## Setting Up AWS Free Tier

As a new AWS customer, you are automatically enrolled in the Free Tier. For more information on using AWS services and VPN configurations, consider checking the following resources:

- **AWS Free Usage Tier**: The AWS Free Tier offers limited access to various AWS services free of charge for 12 months following your account creation. After the 12-month period, you will be charged at the standard pay-as-you-go rates. 
  - **Key Features**:
    - **EC2**: 750 hours of t2.micro or t3.micro instances each month.
    - **S3**: 5 GB of standard storage, 20,000 GET requests, and 2,000 PUT requests each month.
    - **RDS**: 750 hours of db.t2.micro or db.t3.micro instances each month, 20 GB of storage, and 20 GB of backup storage.
    - **Lambda**: 1 million free requests per month and 400,000 GB-seconds of compute time per month.
  - For more details, visit the [AWS Free Tier page](https://aws.amazon.com/free/).

## Create an AWS Account and AWS Access Key

1. **Create an AWS Account**:
    - Go to the [AWS sign-up page](https://aws.amazon.com/free/).
    - Enter your email address and choose a password.
    - Provide a phone number for verification.
    - Follow the prompts to complete your registration.
   
2. **Select an Plan**:
    - Choose the AWS Free Tier, which allows new AWS customers to use certain services free for 12 months.
    - Be aware of the limits (**750 hours** of **t3.micro** usage per month, 100 GB of outbound bandwidth, etc.).
    - After **12 months**, you will be billed at standard rates if you exceed free tier usage.
   
3. **Get Your AWS Access Key**:
    - Log in to the **AWS Console**.
    - Navigate to **IAM (Identity and Access Management)**:
      - Click on **Users** → **Create User**.
    - Enter a username (e.g., `vpnuser`), and check the box for **Attach policies directly**:
      - Select the necessary policies (e.g., `AdministratorAccess` for EC2 management).
    - Click on `vpnuser` in the user table → **Security Credentials**:
      - Click on **Access Keys** → **Create access key**.
    - Download the CSV file containing your **AWS Access Key ID** and **Secret Access Key**.




------------
Georgiy Konovalov 2024 (c) [MIT License](https://opensource.org/licenses/MIT)