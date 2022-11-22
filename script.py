import boto3

def createSecurityGroup(ec2_client):
    """
        The function creates a new security group in AWS
        The function retrievs the vsp_id from the AWS portal, as it is personal and needed for creating a new group
        It then creates the security group using boto3 package
        then it waits for the creation
        then it assigns new rules to the security group

        Parameters
        ----------
        ec2_client
            client that allows for sertain functions using boto3

        Returns
        -------
        SECURITY_GROUP : list[str]
            list of the created security group ids
        vpc_id : str
            the vpc_id as it is needed for other operations

        Errors
        -------
        The function throws an error if a security group with the same name already exists in your AWS

    """
    # Create security group, using SSH & HHTP access available from anywhere
    groups = ec2_client.describe_security_groups()
    vpc_id = groups["SecurityGroups"][0]["VpcId"]

    new_group = ec2_client.create_security_group(
        Description="SSH and HTTP access",
        GroupName="cc-individual-assignment",
        VpcId=vpc_id
    )

    # Wait for the security group to exist!
    new_group_waiter = ec2_client.get_waiter('security_group_exists')
    new_group_waiter.wait(GroupNames=["cc-individual-assignment"])

    group_id = new_group["GroupId"]

    rule_creation = ec2_client.authorize_security_group_ingress(
        GroupName="cc-individual-assignment",
        GroupId=group_id,
        IpPermissions=[{
            'FromPort': 22,
            'ToPort': 22,
            'IpProtocol': 'tcp',
            'IpRanges': [{'CidrIp': '0.0.0.0/0'}]
        },
        {
            'FromPort': 80,
            'ToPort': 80,
            'IpProtocol': 'tcp',
            'IpRanges': [{'CidrIp': '0.0.0.0/0'}]
        }]
    )

    SECURITY_GROUP = [group_id]
    return SECURITY_GROUP, vpc_id

def getAvailabilityZones(ec2_client):
    """
        Retrieving the subnet ids for availability zones
        they are required to assign for example instances to a specific availabilityzone

        Parameters
        ----------
        ec2_client
            client of boto3 tho access certain methods related to AWS EC2

        Returns
        -------
        dict
            a dictonary, with availability zone name as key and subnet id as value

        """
    # Availability zones
    response = ec2_client.describe_subnets()

    availabilityzones = {}
    for subnet in response.get('Subnets'):
        # print(subnet)
        availabilityzones.update({subnet.get('AvailabilityZone'): subnet.get('SubnetId')})

    return availabilityzones

def createInstance(ec2, INSTANCE_TYPE, COUNT, SECURITY_GROUP, SUBNET_ID, VALUE, KEY):
    """
            function that creates EC2 instances on AWS

            Parameters
            ----------
            ec2 : client
                ec2 client to perform actions on AWS EC2 using boto3
            INSTANCE_TYPE : str
                name of the desired instance type.size
            COUNT : int
                number of instances to be created
            SECURITY_GROUP : array[str]
                array of the security groups that should be assigned to the instance
            SUBNET_ID : str
                subnet id that assigns the instance to a certain availability zone
            VALUE : str
                value of the tag
            KEY : str
                key of the tag

            Returns
            -------
            array
                list of all created instances, including their data

            """
    # Don't change these
    KEY_NAME = "vockey"
    INSTANCE_IMAGE = "ami-08d4ac5b634553e16"

    return ec2.create_instances(
        TagSpecifications=[
            {
                'ResourceType': 'instance',
                'Tags': [
                    {
                        'Key': VALUE,
                        'Value': KEY,
                    },
                ]
            },
        ],
        ImageId=INSTANCE_IMAGE,
        MinCount=COUNT,
        MaxCount=COUNT,
        InstanceType=INSTANCE_TYPE,
        KeyName=KEY_NAME,
        SecurityGroupIds=SECURITY_GROUP,
        SubnetId=SUBNET_ID,
    )

def main ():
    """
        main function to process the apllication
    """

    """--------------------------------------- Get necesarry clients from boto3 ---------------------------------------"""
    ec2_client = boto3.client("ec2")
    ec2 = boto3.resource('ec2')

    """--------------------------------------- Create security group ---------------------------------------"""
    SECURITY_GROUP, vpc_id = createSecurityGroup(ec2_client)
    print("security_group: ", SECURITY_GROUP)
    print("vpc_id: ", str(vpc_id), "\n")

    """--------------------------------------- Get availability Zones ---------------------------------------"""
    availabilityZones = getAvailabilityZones(ec2_client)
    availability_zone_1a = availabilityZones.get('us-east-1a')
    print("Availability zones:")
    print("Zone 1a: ", availabilityZones.get('us-east-1a'), "\n")

    """--------------------------------------- Create the instances ---------------------------------------"""
    ins_master = createInstance(ec2, 't2.micro', 1, SECURITY_GROUP, availability_zone_1a, 'Function', 'Master')
    ins_slave_1 = createInstance(ec2, 't2.micro', 1, SECURITY_GROUP, availability_zone_1a, 'Function', 'Slave_1')
    ins_slave_2 = createInstance(ec2, 't2.micro', 1, SECURITY_GROUP, availability_zone_1a, 'Function', 'Slave_2')
    ins_slave_3 = createInstance(ec2, 't2.micro', 1, SECURITY_GROUP, availability_zone_1a, 'Function', 'Slave_3')
    ins_standalone = createInstance(ec2, 't2.micro', 1, SECURITY_GROUP, availability_zone_1a, 'Function', 'Standalone')
    print("Instance IDs:")
    '''
    print("Master:", ins_master.id, "\n")
    print("Slave 1:", ins_slave_1.id, "\n")
    print("Slave 2:", ins_slave_2.id, "\n")
    print("Slave 3:", ins_slave_3.id, "\n")
    print("Standalone:"), ins_standalone.id, "\n"
    '''
    """--------------------------------------- Install MySQL ---------------------------------------"""
    """--------------------------------------- ---------------------------------------"""
    """--------------------------------------- ---------------------------------------"""
    """--------------------------------------- ---------------------------------------"""
    """--------------------------------------- ---------------------------------------"""
    """--------------------------------------- ---------------------------------------"""
    """--------------------------------------- ---------------------------------------"""



main()
