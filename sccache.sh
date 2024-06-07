#!/bin/bash

set -x
set -euo pipefail

main() {
	local triple="x86_64-unknown-linux-musl"
	local tag
	local td
	local url="https://github.com/mozilla/sccache"

	# Download our package, then install our binary.
	td="$(mktemp -d)"
	pushd "${td}"
	tag=$(git ls-remote --tags --refs --exit-code \
		"${url}" |
		cut -d/ -f3 |
		grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' |
		sort --version-sort |
		tail -n1)
	curl -LSfs "${url}/releases/download/${tag}/sccache-${tag}-${triple}.tar.gz" \
		-o sccache.tar.gz
	tar -xvf sccache.tar.gz
	rm sccache.tar.gz
	cp "sccache-${tag}-${triple}/sccache" "/usr/bin/sccache"
	chmod +x "/usr/bin/sccache"

	popd
	rm -rf "${td}"
}

main "${@}"
