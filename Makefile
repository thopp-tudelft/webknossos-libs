packages_by_priority := webknossos wkcuber cluster_tools docs
packages_by_dependency := cluster_tools webknossos wkcuber docs
code_packages := cluster_tools webknossos wkcuber

define in_each_pkg_by_dependency
  for PKG in $(packages_by_dependency); do echo $$PKG; cd $$PKG; $1; cd ..; done
endef

define in_each_code_pkg
  for PKG in $(code_packages); do echo $$PKG; cd $$PKG; $1; cd ..; done
endef

.PHONY: list_packages_by_priority update update-internal install format lint typecheck flt test

list_packages_by_priority:
	@echo $(packages_by_priority)

update:
	$(call in_each_pkg_by_dependency, poetry update --no-dev)

update-internal:
	$(call in_each_pkg_by_dependency, poetry update $(packages_by_dependency))

install:
	$(call in_each_pkg_by_dependency, poetry install --extras all || poetry install)

format:
	$(call in_each_code_pkg, ./format.sh)

lint:
	$(call in_each_code_pkg, ./lint.sh)

typecheck:
	$(call in_each_code_pkg, ./typecheck.sh)

flt:
	$(call in_each_code_pkg, ./format.sh && ./lint.sh && ./typecheck.sh)

test:
	$(call in_each_code_pkg, ./test.sh)
