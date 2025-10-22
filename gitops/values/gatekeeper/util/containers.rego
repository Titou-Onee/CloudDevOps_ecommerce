package util.containers

all[container] {
    some c
    container := input.review.object.spec.containers[c]
}
all[container] {
    input.review.object.spec.initContainers
    some c
    container := input.review.object.spec.initContainers[c]
}
all[container] {
    input.review.object.spec.ephemeralContainers
    some c
    container := input.review.object.spec.ephemeralContainers[c]
}