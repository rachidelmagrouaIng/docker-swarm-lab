# Evidence from the original presentation

Source: Rachid EL MAGROUA, “Docker Swarm — Orchestration des conteneurs”, supplied 37-slide presentation. The screenshots below were extracted unchanged. They are historical observations, not outputs from the new stack configuration.

## Three-node cluster

![Original node list](images/cluster-nodes.png)

Three nodes are Ready and Active, with one Leader. The screenshot reports Docker Engine 19.03.6, a historical version, not an installation recommendation.

## Replicated HTTP service

![Original service replica count](images/service-replicas.png)

`myservice` shows 3/3 replicas with `httpd:latest`, published on port 80. The new stack uses `swarm-lab_web`, `httpd:2.4-alpine`, and published port 8080. It adds explicit deployment settings.

## Task placement

![Original task placement](images/task-placement.png)

The three running tasks are placed on three different hosts. This is an observed placement, not a permanent guarantee that each node has exactly one replica.

## Container replacement

![Original container removal and replacement](images/container-recovery.png)

The terminal sequence shows a running container, its forced removal, an empty subsequent container list, and a new running container for the service. It supports task replacement after removal. It does not establish recovery latency, zero downtime, or manager failover.

## Publication choices

The full presentation is excluded because other screenshots contain join tokens, and decorative assets have no documented reuse license. The selected terminal screenshots contain no visible join tokens. Their private lab host addresses and node identifiers remain as historical context. No license for third-party presentation artwork is asserted.

## Evidence still needed

The new deployment, manual scaling, drain/reactivation, rolling updates and rollback need new execution evidence. Use [the results template](results-template.md) and keep expected behavior separate from observed results.
