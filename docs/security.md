# Security scope

This is a learning lab, with a plain HTTP demo and a single manager. It is not a hardened production deployment.

## Join tokens

The original presentation contains visible worker and manager join tokens. If that Swarm still exists, rotate the exposed tokens on its manager and check membership:

```bash
docker swarm join-token --rotate worker
docker swarm join-token --rotate manager
docker node ls
```

Rotation prevents new joins using the old token. It does not remove nodes that already joined. Investigate any unexpected nodes before changing membership. Do not publish the command outputs containing new tokens.

## Network exposure

Restrict cluster management and overlay ports to trusted cluster hosts. Allow the demo port only from lab clients. Swarm encrypts management communication, but application overlay traffic is not encrypted by default. The included overlay has no encryption option, and the routing mesh does not add HTTP TLS. A production design needs a separate TLS and data-traffic protection plan.

## Runtime and supply chain

The HTTP image uses its upstream defaults. This repository does not claim that it runs fully as a non-root service or with a read-only filesystem. The separate Python example uses a non-root numeric user. Pin verified image digests, review image provenance, and scan the chosen images before broader use. Resource limits constrain tasks but do not make the application secure.

## Availability and observability

One manager is a control-plane failure point. Three managers can tolerate one manager loss if quorum and connectivity remain available. Application replication depends on healthy nodes and capacity. Add application health checks, central logs, monitoring, backup procedures and measured failure tests before making availability claims.

References: [Swarm networking](https://docs.docker.com/engine/swarm/networking/), [manager administration](https://docs.docker.com/engine/swarm/admin_guide/).
