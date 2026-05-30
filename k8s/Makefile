MODULE ?= 01-ingress-nginx
NAMESPACE ?= ingress-nginx

.PHONY: install upgrade uninstall status

install:
	helm install $(MODULE) ... -f kubernetes/$(MODULE)/values.yaml

upgrade:
	helm upgrade $(MODULE) ... -f kubernetes/$(MODULE)/values.yaml

uninstall:
	helm uninstall $(MODULE) -n $(NAMESPACE)

status:
	kubectl get pods -n $(NAMESPACE)