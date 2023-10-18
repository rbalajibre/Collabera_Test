from diagrams import Cluster, Diagram
from diagrams.aws.compute import ECS
from diagrams.aws.database import ElastiCache, RDS
from diagrams.aws.network import ELB
from diagrams.aws.network import Route53

with Diagram("Clustered Web Services", show=False):
    dns = Route53("dns")
    lb = ELB("lb")

    with Cluster("Services"):
        svc_group = [ECS("webServ1"),
                     ECS("webServ2"),
                     ECS("webServ3")]

    with Cluster("DB Cluster"):
        db_primary = RDS("database")
        db_primary - [RDS("database ro")]

    cachedMemory = ElastiCache("cachedMemory")

    dns >> lb >> svc_group
    svc_group >> db_primary
    svc_group >> cachedMemory