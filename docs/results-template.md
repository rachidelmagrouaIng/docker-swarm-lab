# Test plan and results record

I use this record to track repeatable checks of the repository's Docker Swarm deployment. Completed cluster and container-recovery observations are documented in [Lab validation](evidence.md).

## Completed lab checks

| Check | Result | Supporting record |
| --- | --- | --- |
| Cluster membership | Three nodes Ready and Active, including one manager | [Node list](images/cluster-nodes.png) |
| HTTP service replication | Service reached 3/3 running replicas | [Service state](images/service-replicas.png) |
| Task placement | Tasks distributed across three hosts | [Task list](images/task-placement.png) |
| Container replacement | Replacement container appeared after forced removal | [Recovery sequence](images/container-recovery.png) |

These checks apply to the captured lab configuration. The repository stack has a separate validation run planned.

## Repository stack validation

**Run status: Planned**

| Environment detail | Value |
| --- | --- |
| Test date | To record |
| Git commit | To record |
| Host OS and Docker Engine versions | To record |
| Node roles, CPU, and memory | To record |
| Image digest | To record |
| Network and firewall configuration | To record |

## Test cases

| ID | Test | Acceptance criterion | Status | Observation / evidence |
| --- | --- | --- | --- | --- |
| T01 | Deploy `stack.yml` | `swarm-lab_web` reaches 3/3 running replicas | Planned | — |
| T02 | Access HTTP through each node | Each node returns a successful HTTP response on port 8080 | Planned | — |
| T03 | Scale from three to five replicas | Service reaches 5/5, then returns to 3/3 after scaling back | Planned | — |
| T04 | Remove one service container | A replacement task reaches Running and the service returns to 3/3 | Planned | — |
| T05 | Drain a worker | Service tasks move to eligible active nodes | Planned | — |
| T06 | Reactivate the worker | Worker returns to Active and is eligible for scheduling | Planned | — |
| T07 | Update the image | All running tasks use the selected image digest | Planned | — |
| T08 | Roll back the update | Service returns to the previous specification | Planned | — |

## Recovery measurements

For T04, record:

| Measurement | Value |
| --- | --- |
| Container removal timestamp | To measure |
| Replacement task Running timestamp | To measure |
| Time to restore three running replicas | To measure |
| HTTP probe interval and timeout | To record |
| Total probes and failed requests | To measure |
| Clock synchronization method | To record |

Task recovery and client-facing availability are separate observations. A replacement container reaching Running does not by itself confirm uninterrupted HTTP service.

## Run notes

Record unexpected behavior, relevant service logs, and corrective actions here. Attach terminal output or screenshots for each completed test, with credentials and join tokens removed.
