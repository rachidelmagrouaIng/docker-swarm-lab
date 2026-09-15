# Lab walkthrough

Use dedicated Linux lab machines. The suggested topology is one manager and two workers with stable private IP addresses, Docker Engine installed, and registry access. Commands assume permission to use Docker. Do not reuse a production cluster for failure exercises.

## 1. Network prerequisites

| Traffic | Destination | Allowed sources |
| --- | --- | --- |
| TCP 2377 | Managers | Cluster nodes |
| TCP and UDP 7946 | All nodes | Cluster nodes |
| UDP 4789 | All nodes | Cluster nodes only |
| TCP 8080 | All nodes, demo HTTP | Your lab client/network |
| SSH, usually TCP 22 | Administration interface | Your administration host |

Apply rules to host firewalls and any cloud network controls. Docker-published ports may not follow the host firewall assumptions used for ordinary processes. Test reachability from an allowed host and an outside host. Never expose overlay UDP 4789 to the public internet. HTTP here is a lab endpoint without TLS.

## 2. Build the introductory image

The slides show a Python greeting built with an Ubuntu-based Dockerfile. This reconstruction uses a Python base image and a numeric non-root user. It is separate from the HTTP Swarm service.

```bash
docker build -t swarm-hello:local examples/hello-python
docker run --rm swarm-hello:local
```

Expected output: `Hello, IRSI!`. The container exits normally after printing.

## 3. Initialize and join

On the manager, substitute its private address:

```bash
docker swarm init --advertise-addr <MANAGER_PRIVATE_IP>
docker swarm join-token worker
```

Run the generated join command on each worker through a private terminal. Treat the token as a secret and exclude it from recordings. On the manager:

```bash
docker node ls
```

Expected: three Ready/Active nodes, one Leader. Managers can also run application tasks in this lab. If joining times out, check address selection, routes, firewall rules and whether the host already belongs to another Swarm. Avoid forcing it out of an existing cluster.

## 4. Deploy and inspect

```bash
docker stack config --compose-file stack.yml
docker stack deploy -c stack.yml swarm-lab
docker stack services swarm-lab
docker service ps --no-trunc swarm-lab_web
docker service inspect --format '{{.Spec.TaskTemplate.ContainerSpec.Image}}' swarm-lab_web
curl --fail --max-time 10 http://<NODE_PRIVATE_IP>:8080/
```

Wait for 3/3 replicas. Record the resolved image digest and node versions. Swarm downloads the image on the nodes; this stack has no build step. Repeat the HTTP check against each reachable node. The routing mesh routes requests to service tasks, including when a contacted node has no local task. Responses alone do not establish even distribution.

## 5. Scale explicitly

```bash
docker service scale swarm-lab_web=5
docker service ls
docker service ps swarm-lab_web
docker service scale swarm-lab_web=3
```

Wait for the requested number of running tasks after each operation. Five replicas do not require five nodes. This exercise demonstrates manual scaling. Redeploying `stack.yml` restores its declared three replicas.

## 6. Observe task replacement

On a lab node with a running service task:

```bash
docker ps --filter label=com.docker.swarm.service.name=swarm-lab_web
```

Record one displayed container ID. Remove only that selected lab container:

```bash
docker rm -f <SELECTED_LAB_CONTAINER_ID>
```

On the manager, inspect until running replicas return to three:

```bash
docker service ps --no-trunc swarm-lab_web
docker service ls
```

Capture the replacement task ID and placement. Swarm may schedule the replacement on a different node. Measure elapsed time if reporting recovery speed; a screenshot alone does not prove uninterrupted HTTP availability.

## 7. Worker maintenance exercise

Select a worker from `docker node ls`, then on the manager:

```bash
docker node update --availability drain <WORKER_NODE_NAME>
docker service ps swarm-lab_web
docker node update --availability active <WORKER_NODE_NAME>
```

Draining moves service work away from the worker if other nodes have enough resources. This is planned maintenance, not proof of behavior during an abrupt host failure. Reactivating a node does not automatically rebalance existing tasks.

## 8. Rolling update and rollback

Choose a verified compatible HTTP image digest that differs from the current one. All nodes must be able to pull it. Replace the placeholder before running:

```bash
docker service update --image <VERIFIED_HTTPD_IMAGE_AT_SHA256_DIGEST> swarm-lab_web
docker service ps --no-trunc swarm-lab_web
docker service inspect --format '{{json .UpdateStatus}}' swarm-lab_web
docker service rollback swarm-lab_web
```

Rollback returns to the immediately previous service specification. Run it immediately after this image update to avoid reverting an unrelated later change. The stack limits update parallelism and requests rollback on detected update failure. No application health check is defined, so a running but faulty HTTP application may not trigger automatic rollback. After a successful intended change, update the image in `stack.yml` to keep configuration consistent.

## 9. Cleanup

```bash
docker stack rm swarm-lab
```

Wait for service/network removal. Leave an ephemeral cluster only after removing its workloads. Run `docker swarm leave` on each worker. On the sole manager of this disposable lab only, `docker swarm leave --force` removes its Swarm membership. Do not use that command on a shared cluster.

## Troubleshooting

| Symptom | Investigation |
| --- | --- |
| Join timeout | Manager private IP, TCP 2377, routing, previous Swarm membership |
| Rejected/pending tasks | `docker service ps --no-trunc`, image pulls, architecture and free resources |
| HTTP timeout | Running tasks, TCP 8080, ingress connectivity and host/cloud firewall rules |
| Traffic fails between hosts | TCP/UDP 7946, UDP 4789, MTU and overlay network configuration |
| No scheduling after manager failure | This one-manager lab has no alternate manager/quorum |

References: [stack deployment](https://docs.docker.com/engine/swarm/stack-deploy/), [networking](https://docs.docker.com/engine/swarm/networking/), [administration](https://docs.docker.com/engine/swarm/admin_guide/).
