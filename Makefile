.PHONY: help release dev dev-all nopromote opam clean dev-ci-windows dev-ci-osx

help:
	@echo "Welcome to lablgtk Dune-based build system. Targets are"
	@echo ""
	@echo "  - release:   build lablgtk package in release mode"
	@echo "  - dev:       build in developer mode [requires extra dependencies]"
	@echo "  - dev-all:   build in developer mode [requires extra dependencies]"
	@echo "  - nopromote: dev build but without re-running camlp5 generation"
	@echo "  - opam:      internal, used in CI testing"
	@echo "  - clean:     clean build tree"
	@echo ""
	@echo "WARNING: Packagers should not use this makefile, but call dune"
	@echo "directly with the right options for their distribution, see README"

release:
	dune build -p lablgtk3

dev:
	dune build

dev-ci-osx:
	echo "(dirs :standard \ src-goocanvas2)" >> dune
	dune build

dev-ci-windows:
	echo "(dirs :standard \ src-goocanvas2 src-gtkspell3)" >> dune
	dune build

# This also builds examples, will be the default once we set (lang dune 2.0)
dev-all:
	dune build @all

nopromote:
	dune build @all --ignore-promoted-rules

# We first pin lablgtk3 as to avoid problems with parallel make
OPAM_PKGS=lablgtk3 lablgtk3-sourceview4 lablgtk3-goocanvas2 lablgtk3-rsvg2 lablgtk3-gtkspell3

opam:
	for pkg in $(OPAM_PKGS) ; do \
		opam pin add $$pkg . --kind=path -y ; \
		opam install $$pkg ; \
	done

clean:
	dune clean
